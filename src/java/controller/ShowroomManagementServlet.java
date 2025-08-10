/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import context.DBContext;
import dao.ShowroomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.List;
import model.Showroom;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "ShowroomManagementServlet", urlPatterns = { "/dashboard-showrooms", "/add-showroom", "/edit-showroom", "/delete-showroom"})
public class ShowroomManagementServlet extends HttpServlet {
private ShowroomDAO showroomDAO;
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
            out.println("<title>Servlet ShowroomManagementServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShowroomManagementServlet at " + request.getContextPath() + "</h1>");
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
        showroomDAO = new ShowroomDAO();
    }
    
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

    try {
        if ("/delete-showroom".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            showroomDAO.deleteShowroom(id);
            request.getSession().setAttribute("success", "Xoá showroom thành công!");
            response.sendRedirect("dashboard-showrooms");
        } else {
            // Gộp luôn logic listShowrooms vào đây
            List<Showroom> showroomList = showroomDAO.getAllShowrooms();
            request.setAttribute("showroomList", showroomList);
            request.getRequestDispatcher("showroom_management.jsp").forward(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Lỗi: " + e.getMessage());
        request.getRequestDispatcher("showroom_management.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String province = request.getParameter("province");
        String district = request.getParameter("district");

        ShowroomDAO showroomDAO = new ShowroomDAO();

        if ("/add-showroom".equals(action)) {
            // === THÊM showroom mới ===
            Showroom showroom = new Showroom();
            showroom.setName(name);
            showroom.setAddress(address);
            showroom.setProvince(province);
            showroom.setDistrict(district);

            showroomDAO.insertShowroom(showroom);
            session.setAttribute("message", "Thêm showroom thành công!");

        } else if ("/edit-showroom".equals(action)) {
            // === CẬP NHẬT showroom ===
            int showroomId = Integer.parseInt(request.getParameter("showroomId"));

            Showroom showroom = new Showroom();
            showroom.setShowroomId(showroomId);
            showroom.setName(name);
            showroom.setAddress(address);
            showroom.setProvince(province);
            showroom.setDistrict(district);

            showroomDAO.updateShowroom(showroom);
            session.setAttribute("message", "Cập nhật showroom thành công!");
        }

        response.sendRedirect("dashboard-showrooms");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Lỗi khi xử lý dữ liệu: " + e.getMessage());
        response.sendRedirect("dashboard-showrooms");
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
