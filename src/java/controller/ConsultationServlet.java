/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.ConsultationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import context.DBContext;
import java.sql.Timestamp;
import java.util.List;
import model.Car;
import model.Consultation;
import model.User;
import java.sql.Connection;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "ConsultationServlet", urlPatterns = {"/consultations"})
public class ConsultationServlet extends HttpServlet {

    private ConsultationDAO consultationDAO;

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
            out.println("<title>Servlet ConsultationServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ConsultationServlet at " + request.getContextPath() + "</h1>");
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
    public void init() throws ServletException {
        consultationDAO = new ConsultationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ Thêm đoạn này để gửi danh sách xe vào form
        try {
            Connection conn = DBContext.getConnection(); // hoặc DBUtil.getConnection()
            CarDAO carDAO = new CarDAO(conn);
            List<Car> carList = carDAO.getAllCars();
            request.setAttribute("cars", carList);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách xe");
        }

        // Gửi danh sách lịch sử tư vấn nếu cần
        List<Consultation> consultations = consultationDAO.getConsultationsByUserId(currentUser.getUserId());
        request.setAttribute("consultations", consultations);

        request.getRequestDispatcher("consultation_form.jsp").forward(request, response);
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
    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("currentUser");

    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        int carId = Integer.parseInt(request.getParameter("carId"));
        Consultation consultation = new Consultation();
        consultation.setUserId(currentUser.getUserId());
        consultation.setCarId(carId);
        consultation.setRequestDate(new Timestamp(System.currentTimeMillis()));

        consultationDAO.insertConsultation(consultation);

        // ✅ Gửi lại danh sách xe để hiển thị form
        Connection conn = DBContext.getConnection();
        CarDAO carDAO = new CarDAO(conn);
        List<Car> carList = carDAO.getAllCars();
        request.setAttribute("cars", carList);

        // ✅ Gửi lại danh sách tư vấn
        List<Consultation> consultations = consultationDAO.getConsultationsByUserId(currentUser.getUserId());
        request.setAttribute("consultations", consultations);

        // ✅ Gửi thông báo thành công
        request.setAttribute("success", "Gửi yêu cầu tư vấn thành công!");
        request.getRequestDispatcher("consultation_form.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Đã xảy ra lỗi khi gửi yêu cầu tư vấn.");
        request.getRequestDispatcher("consultation_form.jsp").forward(request, response);
    }
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
