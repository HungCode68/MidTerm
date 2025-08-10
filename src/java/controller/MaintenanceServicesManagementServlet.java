/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import context.DBContext;
import dao.MaintenanceServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.MaintenanceService;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "MaintenanceServicesManagementServlet",  urlPatterns = { "/dashboard-maintenance-services", "/add-maintenance-service", "/edit-maintenance-service",  "/delete-maintenance-service"})
public class MaintenanceServicesManagementServlet extends HttpServlet {
 private MaintenanceServiceDAO maintenanceServiceDAO;
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
            out.println("<title>Servlet MaintenanceServicesManagementServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MaintenanceServicesManagementServlet at " + request.getContextPath() + "</h1>");
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
            // Giả sử bạn có class MyDatabase chứa method static getConnection()
            // hoặc bạn tự inject Connection ở đây
            maintenanceServiceDAO = new MaintenanceServiceDAO(DBContext.getConnection()); // <-- THAY bằng class của bạn
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo DAO", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String action = request.getServletPath();
        HttpSession session = request.getSession();

        try {
            switch (action) {
                case "/dashboard-maintenance-services": {
                    String keyword = request.getParameter("keyword");
                    List<MaintenanceService> services;

                    if (keyword != null && !keyword.trim().isEmpty()) {
                        services = maintenanceServiceDAO.searchByName(keyword);
                        request.setAttribute("keyword", keyword);
                    } else {
                        services = maintenanceServiceDAO.getAllServices();
                    }

                    // Gửi thêm thông báo nếu có trong session
                    if (session.getAttribute("message") != null) {
                        request.setAttribute("message", session.getAttribute("message"));
                        session.removeAttribute("message");
                    }

                    if (session.getAttribute("error") != null) {
                        request.setAttribute("error", session.getAttribute("error"));
                        session.removeAttribute("error");
                    }

                    request.setAttribute("services", services);
                    request.getRequestDispatcher("maintenance_services_management.jsp").forward(request, response);
                    break;
                }

                case "/delete-maintenance-service": {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    maintenanceServiceDAO.deleteService(deleteId);
                    session.setAttribute("message", "Xoá dịch vụ thành công!");
                    response.sendRedirect("dashboard-maintenance-services");
                    break;
                }

                case "/edit-maintenance-service": {
                    int editId = Integer.parseInt(request.getParameter("id"));
                    MaintenanceService editService = maintenanceServiceDAO.getServiceById(editId);
                    request.setAttribute("editService", editService);

                    List<MaintenanceService> allServices = maintenanceServiceDAO.getAllServices();
                    request.setAttribute("services", allServices);
                    request.getRequestDispatcher("maintenance_services_management.jsp").forward(request, response);
                    break;
                }

                default:
                    response.sendRedirect("dashboard-maintenance-services");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            response.sendRedirect("dashboard-maintenance-services");
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
            if ("/add-maintenance-service".equals(action)) {
                String serviceName = request.getParameter("serviceName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));

                MaintenanceService service = new MaintenanceService();
                service.setServiceName(serviceName);
                service.setDescription(description);
                service.setPrice(price);

                maintenanceServiceDAO.addService(service);
                session.setAttribute("message", "Thêm dịch vụ thành công!");

            } else if ("/edit-maintenance-service".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                String serviceName = request.getParameter("serviceName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));

                MaintenanceService service = new MaintenanceService();
                service.setServiceId(serviceId);
                service.setServiceName(serviceName);
                service.setDescription(description);
                service.setPrice(price);

                maintenanceServiceDAO.updateService(service);
                session.setAttribute("message", "Cập nhật dịch vụ thành công!");
            }

            response.sendRedirect("dashboard-maintenance-services");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi xử lý dữ liệu: " + e.getMessage());
            response.sendRedirect("dashboard-maintenance-services");
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
