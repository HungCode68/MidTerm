/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import context.DBContext;
import dao.CarDAO;
import dao.UserDAO;
import dao.ConsultationDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.List;
import model.Car;
import model.Consultation;
import model.User;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "ConsultationManagementServlet", urlPatterns = {"/dashboard-consultations", "/add-consultation", "/edit-consultation", "/delete-consultation"})
public class ConsultationManagementServlet extends HttpServlet {

    private ConsultationDAO consultationDAO;
    private CarDAO carDAO;
    private UserDAO userDAO = new UserDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ConsultationManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ConsultationManagementServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    public void init() {
        consultationDAO = new ConsultationDAO();
        try {
            carDAO = new CarDAO(DBContext.getConnection());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("currentUser");
    String action = request.getServletPath(); // Lấy đường dẫn servlet hiện tại

    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"Admin".equals(currentUser.getRole())) {
        session.setAttribute("error", "Bạn không có quyền truy cập trang này.");
        response.sendRedirect("index.jsp");
        return;
    }

    try {
        // ✅ XỬ LÝ XÓA NẾU ĐÚNG ĐƯỜNG DẪN
        if ("/delete-consultation".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                int id = Integer.parseInt(idParam);
                consultationDAO.deleteConsultation(id);
                session.setAttribute("success", "Xóa tư vấn thành công!");
            } else {
                session.setAttribute("error", "Thiếu ID để xóa.");
            }
            response.sendRedirect("dashboard-consultations"); // Quay lại trang chính
            return;
        }

        // ✅ XỬ LÝ HIỂN THỊ DANH SÁCH
        String phoneFilter = request.getParameter("phone");
        String dateFilter = request.getParameter("date");

        List<Car> cars = carDAO.getAllCars();
        List<User> users = userDAO.getAllUsers();
        List<Consultation> consultations;

        if ((phoneFilter != null && !phoneFilter.trim().isEmpty())
                || (dateFilter != null && !dateFilter.trim().isEmpty())) {
            consultations = consultationDAO.getFilteredConsultations(phoneFilter, dateFilter);
        } else {
            consultations = consultationDAO.getAllConsultations();
        }

        for (Consultation c : consultations) {
            if (c.getUserId() != null) {
                for (User u : users) {
                    if (u.getUserId() == c.getUserId()) {
                        c.setUserName(u.getFullName());
                        c.setPhoneNumber(u.getPhoneNumber());
                        break;
                    }
                }
            } else {
                // Nếu không có user, dùng thông tin đã nhập
                c.setUserName(c.getFullName());
            }

            for (Car car : cars) {
                if (car.getCarId() == c.getCarId()) {
                    c.setCarModelName(car.getModelName());
                    break;
                }
            }
        }

        request.setAttribute("cars", cars);
        request.setAttribute("users", users);
        request.setAttribute("consultations", consultations);
        request.setAttribute("phone", phoneFilter);
        request.setAttribute("date", dateFilter);

        request.getRequestDispatcher("consultation_management.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
        response.sendRedirect("dashboard-consultations");
    }
}


    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        HttpSession session = request.getSession();

        try {
            switch (action) {
                case "/add-consultation":
                    int carId = Integer.parseInt(request.getParameter("carId"));
                    String userIdStr = request.getParameter("userId");
                    Integer userId = (userIdStr != null && !userIdStr.trim().isEmpty()) ? Integer.parseInt(userIdStr) : null;

                    String fullName = null;
                    String phoneNumber = null;

                    if (userId == null) {
                        // Trường hợp không chọn user → dùng input
                        fullName = request.getParameter("fullName");
                        phoneNumber = request.getParameter("phoneNumber");
                    }

                    Consultation newConsultation = new Consultation();
                    newConsultation.setUserId(userId);
                    newConsultation.setCarId(carId);
                    newConsultation.setFullName(fullName);
                    newConsultation.setPhoneNumber(phoneNumber);
                    newConsultation.setRequestDate(new Timestamp(System.currentTimeMillis()));

                    consultationDAO.insertConsultation(newConsultation);
                    session.setAttribute("success", "Thêm tư vấn thành công!");
                    break;

                case "/edit-consultation":
                    int consultationId = Integer.parseInt(request.getParameter("consultationId"));

                    String updatedUserStr = request.getParameter("userId");
                    Integer updatedUserId = (updatedUserStr != null && !updatedUserStr.trim().isEmpty()) ? Integer.parseInt(updatedUserStr) : null;

                    int updatedCarId = Integer.parseInt(request.getParameter("carId"));

                    String updatedFullName = null;
                    String updatedPhone = null;

                    if (updatedUserId == null) {
                        updatedFullName = request.getParameter("fullName");
                        updatedPhone = request.getParameter("phoneNumber");
                    }

                    Consultation editedConsultation = new Consultation();
                    editedConsultation.setConsultationId(consultationId);
                    editedConsultation.setUserId(updatedUserId);
                    editedConsultation.setCarId(updatedCarId);
                    editedConsultation.setFullName(updatedFullName);
                    editedConsultation.setPhoneNumber(updatedPhone);

                    consultationDAO.updateConsultation(editedConsultation);
                    session.setAttribute("success", "Cập nhật tư vấn thành công!");
                    break;

              
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi xử lý yêu cầu: " + e.getMessage());
        }

        response.sendRedirect("dashboard-consultations");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
