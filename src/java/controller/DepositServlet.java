/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DepositDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import model.Deposit;
import model.User;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "DepositServlet", urlPatterns = {"/deposit"})
public class DepositServlet extends HttpServlet {
    private DepositDAO depositDAO;
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
            out.println("<title>Servlet DepositServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DepositServlet at " + request.getContextPath() + "</h1>");
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
        depositDAO = new DepositDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
    try {
        // Kiểm tra người dùng đã đăng nhập chưa
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp?message=login_required");
            return;
        }

        // Lấy dữ liệu từ form
        int userId = currentUser.getUserId();
        int carId = Integer.parseInt(request.getParameter("carId"));
        String colorExterior = request.getParameter("colorExterior");
        String colorInterior = request.getParameter("colorInterior");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String cccd = request.getParameter("cccd");
        String province = request.getParameter("province");
        int showroomId = Integer.parseInt(request.getParameter("showroomId"));
        String paymentMethod = request.getParameter("paymentMethod");
        String status = "pending"; // Thêm trạng thái mặc định

        // Tạo đối tượng deposit
        Deposit deposit = new Deposit(
            0, userId, carId, colorExterior, colorInterior,
            fullName, phoneNumber, cccd, province,
            showroomId, paymentMethod, new Timestamp(System.currentTimeMillis()),
            status
        );

        // Lưu vào DB
        depositDAO.insertDeposit(deposit);

        // Redirect về form với thông báo thành công
        response.sendRedirect("deposit_form.jsp?success=true&carId=" + carId);

    } catch (Exception e) {
        e.printStackTrace();
        // Forward lại form với thông báo lỗi
        request.setAttribute("errorMessage", "Đã xảy ra lỗi khi đặt cọc: " + e.getMessage());
        request.getRequestDispatcher("deposit_form.jsp").forward(request, response);
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
