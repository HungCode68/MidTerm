/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.DepositDAO;
import dao.ShowroomDAO;
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
import java.sql.Connection;
import java.util.List;
import model.Deposit;
import model.Showroom;
import model.User;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "DepositManagementServlet", urlPatterns = {
    "/dashboard-deposits",
    "/add-deposit",
    "/edit-deposit",
    "/delete-deposit"
})
public class DepositManagementServlet extends HttpServlet {

    private DepositDAO depositDAO;
    private CarDAO carDAO;

    private ShowroomDAO showroomDAO;
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
            out.println("<title>Servlet DepositManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DepositManagementServlet at " + request.getContextPath() + "</h1>");
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
        Connection conn = (Connection) getServletContext().getAttribute("conn");
        depositDAO = new DepositDAO();
        carDAO = new CarDAO(conn);
        userDAO = new UserDAO();
        showroomDAO = new ShowroomDAO(); // thêm dòng này

    }

  @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("currentUser");

    if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
        session.setAttribute("error", "Bạn không có quyền truy cập.");
        response.sendRedirect("login.jsp");
        return;
    }

    String action = request.getServletPath();

    try {
        // Xoá đặt cọc
        if ("/delete-deposit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            depositDAO.deleteDeposit(id);
            session.setAttribute("success", "Xoá thành công!");
            response.sendRedirect("dashboard-deposits");
            return;
        }

        // Lấy thông tin lọc
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        String dayStr = request.getParameter("day");
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");

        Integer day = (dayStr != null && !dayStr.isEmpty()) ? Integer.parseInt(dayStr) : null;
        Integer month = (monthStr != null && !monthStr.isEmpty()) ? Integer.parseInt(monthStr) : null;
        Integer year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : null;

        // Gọi DAO có chứa JOIN đầy đủ thông tin
        List<Deposit> deposits;

        if ((phone != null && !phone.trim().isEmpty()) || (status != null && !status.trim().isEmpty())
                || day != null || month != null || year != null) {
            deposits = depositDAO.getFilteredDepositsWithNames(phone, status, day, month, year);
        } else {
            deposits = depositDAO.getAllDepositsWithNames();
        }

        // Gửi dữ liệu sang JSP
        request.setAttribute("deposits", deposits);
        request.setAttribute("cars", carDAO.getAllCars());
        request.setAttribute("users", userDAO.getAllUsers());
        request.setAttribute("showrooms", showroomDAO.getAllShowrooms());

        request.setAttribute("phone", phone);
        request.setAttribute("status", status);
        request.setAttribute("day", day);
        request.setAttribute("month", month);
        request.setAttribute("year", year);

        request.getRequestDispatcher("deposit_management.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Lỗi khi tải danh sách đặt cọc: " + e.getMessage());
        request.getRequestDispatcher("deposit_management.jsp").forward(request, response);
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

        HttpSession session = request.getSession();

        try {
            String userIdStr = request.getParameter("userId");
            Integer userId = (userIdStr != null && !userIdStr.isEmpty()) ? Integer.parseInt(userIdStr) : null;

            int carId = Integer.parseInt(request.getParameter("carId"));
            String exterior = request.getParameter("colorExterior");
            String interior = request.getParameter("colorInterior");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phoneNumber");
            String cccd = request.getParameter("cccd");
            String province = request.getParameter("province");
            int showroomId = Integer.parseInt(request.getParameter("showroomId"));
            String paymentMethod = request.getParameter("paymentMethod");
            String status = request.getParameter("status");
            Timestamp depositDate = new Timestamp(System.currentTimeMillis());

            // Phân biệt thêm hay sửa bằng cách kiểm tra có tồn tại depositId không
            String depositIdStr = request.getParameter("depositId");
            if (depositIdStr == null || depositIdStr.isEmpty()) {
                // Thêm mới
                Deposit dp = new Deposit(0, userId, carId, exterior, interior, fullName, phone, cccd,
                        province, showroomId, paymentMethod, depositDate, status);
                depositDAO.insertDeposit(dp);
                session.setAttribute("success", "Đặt cọc thành công!");
            } else {
                // Cập nhật
                int id = Integer.parseInt(depositIdStr);
                Deposit dp = new Deposit(id, userId, carId, exterior, interior, fullName, phone, cccd,
                        province, showroomId, paymentMethod, depositDate, status);
                depositDAO.updateDeposit(dp);
                session.setAttribute("success", "Cập nhật thành công!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
        }

        response.sendRedirect("dashboard-deposits");
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
