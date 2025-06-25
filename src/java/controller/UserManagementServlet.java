/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "UserManagementServlet", urlPatterns = {"/dashboard", "/add-user", "/edit-user", "/delete-user"})
public class UserManagementServlet extends HttpServlet {

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
            out.println("<title>Servlet UserManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserManagementServlet at " + request.getContextPath() + "</h1>");
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
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/dashboard":
                List<User> userList = userDAO.getAllUsers();
                request.setAttribute("userList", userList);
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);

                break;

            case "/delete-user":
                try {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    boolean deleted = userDAO.deleteUser(deleteId);
                    if (deleted) {
                        request.getSession().setAttribute("success", "Xoá tài khoản thành công.");
                    } else {
                        request.getSession().setAttribute("error", "Không thể xoá tài khoản.");
                    }
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                }
                response.sendRedirect("dashboard");
                break;
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

        switch (action) {
            case "/add-user":
                try {
                    String fullName = request.getParameter("fullName");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phoneNumber");
                    String cccd = request.getParameter("cccd");
                    String password = request.getParameter("password");
                    String role = request.getParameter("role");

                    String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
                    User newUser = new User(0, fullName, phone, email, hashed, role, cccd, null);
                    boolean added = userDAO.registerUser(newUser);
                    if (added) {
                        request.getSession().setAttribute("success", "Thêm tài khoản thành công.");
                    } else {
                        request.getSession().setAttribute("error", "Không thể thêm tài khoản.");
                    }
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                }
                response.sendRedirect("dashboard");
                break;

            case "/edit-user":
                try {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String editedName = request.getParameter("fullName");
                    String editedEmail = request.getParameter("email");
                    String editedPhone = request.getParameter("phoneNumber");
                    String editedCccd = request.getParameter("cccd");
                    String editedRole = request.getParameter("role");

                    User editedUser = new User();
                    editedUser.setUserId(userId);
                    editedUser.setFullName(editedName);
                    editedUser.setEmail(editedEmail);
                    editedUser.setPhoneNumber(editedPhone);
                    editedUser.setCccd(editedCccd);
                    editedUser.setRole(editedRole);
                    boolean updated = userDAO.updateUser(editedUser);
                    if (updated) {
                        request.getSession().setAttribute("success", "Cập nhật tài khoản thành công.");
                    } else {
                        request.getSession().setAttribute("error", "Không thể cập nhật tài khoản.");
                    }
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                }

                response.sendRedirect("dashboard");
                break;
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
