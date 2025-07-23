/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.sql.Connection;

import context.DBContext;
import dao.CarDAO;
import dao.TestDriveDAO;
import dao.UserDAO;
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
import model.TestDrive;
import model.User;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "TestDriveManagementServlet", urlPatterns = {"/dashboard-testdrives", "/add-testdrives", "/edit-testdrives", "/delete-testdrives"})
public class TestDriveManagementServlet extends HttpServlet {

    private TestDriveDAO testDriveDAO;
    private CarDAO carDAO;
    private UserDAO userDAO;

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
            out.println("<title>Servlet TestDriveManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TestDriveManagementServlet at " + request.getContextPath() + "</h1>");
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
        try {
            Connection conn = DBContext.getConnection();
            testDriveDAO = new TestDriveDAO(conn);
            carDAO = new CarDAO(conn);
            userDAO = new UserDAO();
        } catch (Exception e) {
            throw new ServletException("Không thể kết nối DB", e);
        }
    }

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("currentUser");

    if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
        session.setAttribute("error", "Truy cập bị từ chối");
        response.sendRedirect("login.jsp");
        return;
    }

    String action = request.getServletPath();

    try {
        if ("/delete-testdrives".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            testDriveDAO.deleteTestDrive(id);
            session.setAttribute("success", "Xóa thành công!");
            response.sendRedirect(request.getContextPath() + "/dashboard-testdrives");
            return;
        }

        // ✅ Lấy dữ liệu từ form lọc (nếu có)
        String phone = request.getParameter("phone");
        String date = request.getParameter("date");

        List<TestDrive> list;

        // ✅ Nếu có điều kiện lọc, gọi hàm lọc
        if ((phone != null && !phone.trim().isEmpty()) ||
            (date != null && !date.trim().isEmpty())) {
            list = testDriveDAO.getFilteredTestDrives(phone, date);
        } else {
            // ✅ Nếu không, hiển thị toàn bộ
            list = testDriveDAO.getAllTestDrivesWithCarName();
        }

        // Các dữ liệu khác
        List<Car> cars = carDAO.getAllCars();
        List<User> users = userDAO.getAllUsers();

        request.setAttribute("testDrives", list);
        request.setAttribute("cars", cars);
        request.setAttribute("users", users);
        request.getRequestDispatcher("testdrive_management.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Không thể tải danh sách lịch lái thử");
        request.getRequestDispatcher("testdrive_management.jsp").forward(request, response);
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
            String userIdStr = request.getParameter("userId");
            Integer userId = (userIdStr != null && !userIdStr.trim().isEmpty()) ? Integer.parseInt(userIdStr) : null;
            int carId = Integer.parseInt(request.getParameter("carId"));
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phoneNumber");
            String province = request.getParameter("province");
            String address = request.getParameter("address");
            String timeStr = request.getParameter("scheduledTime");
            Timestamp scheduledTime = Timestamp.valueOf(timeStr.replace("T", " ") + ":00");

            if ("/add-testdrives".equals(action)) {
                TestDrive td = new TestDrive(0, userId, carId, fullName, phone, province, address, scheduledTime, null);
                testDriveDAO.insertTestDrive(td);
                session.setAttribute("success", "Thêm lịch lái thử thành công!");

            } else if ("/edit-testdrives".equals(action)) {
                int id = Integer.parseInt(request.getParameter("testDriveId"));
                TestDrive td = new TestDrive(id, userId, carId, fullName, phone, province, address, scheduledTime, null);
                testDriveDAO.updateTestDrive(td);
                session.setAttribute("success", "Cập nhật thành công!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/dashboard-testdrives");

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
