/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import context.DBContext;
import dao.CarDAO;
import dao.DepositDAO;
import dao.MaintenanceBookingDAO;
import dao.MaintenanceServiceDAO;
import dao.ServiceInvoiceDAO;
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
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import model.MaintenanceBooking;
import model.MaintenanceService;
import model.ServiceInvoice;
import model.User;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "ServiceInvoiceManagementServlet", urlPatterns = { "/dashboard-invoices", "/add-invoice", "/edit-invoice",  "/delete-invoice",  "/filter-invoice"})
public class ServiceInvoiceManagementServlet extends HttpServlet {

    private  ServiceInvoiceDAO invoiceDAO = new ServiceInvoiceDAO();
    private UserDAO userDAO = new UserDAO();
    private MaintenanceServiceDAO serviceDAO;
    private MaintenanceBookingDAO bookingDAO;

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
            out.println("<title>Servlet ServiceInvoiceManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServiceInvoiceManagementServlet at " + request.getContextPath() + "</h1>");
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
            userDAO = new UserDAO();
            bookingDAO = new MaintenanceBookingDAO(conn);
            serviceDAO = new MaintenanceServiceDAO(conn);
            
        } catch (Exception e) {
            throw new ServletException("Không thể kết nối CSDL", e);
        }
    }

 @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String action = request.getServletPath();
    HttpSession session = request.getSession();

    try {
        // Lấy tất cả dữ liệu cần thiết và truyền sang JSP
        List<ServiceInvoice> invoiceList = invoiceDAO.getAllInvoices();
        List<User> users = userDAO.getAllUsers();
        List<MaintenanceBooking> allBookings = bookingDAO.getAllBookings(); // Lấy tất cả booking
        List<MaintenanceService> services = serviceDAO.getAllServices(); // Lấy tất cả dịch vụ
        
        request.setAttribute("users", users);
        request.setAttribute("services", services); // Truyền danh sách dịch vụ đã lấy
        request.setAttribute("allBookings", allBookings);
        
        // Bổ sung: Lấy thông tin user và serviceName (nếu có) để hiển thị trong bảng
        for (ServiceInvoice invoice : invoiceList) {
            // Lấy thông tin user
            if (invoice.getUserId() != null) {
                for (User user : users) {
                    if (user.getUserId() == invoice.getUserId()) {
                        invoice.setFullName(user.getFullName());
                        invoice.setPhoneNumber(user.getPhoneNumber());
                        break;
                    }
                }
            }
            
            // Lấy tên dịch vụ từ bookingId hoặc serviceId
            if (invoice.getBookingId() != null) {
                for (MaintenanceBooking booking : allBookings) {
                    if (booking.getBookingId() == invoice.getBookingId()) {
                        invoice.setServiceName(booking.getServiceName());
                        break;
                    }
                }
            } else if (invoice.getServiceId() != null) { // Trường hợp hóa đơn không có bookingId (khách)
                for (MaintenanceService service : services) {
                    if (service.getServiceId() == invoice.getServiceId()) {
                        invoice.setServiceName(service.getServiceName());
                        break;
                    }
                }
            }
        }
        request.setAttribute("invoiceList", invoiceList);

        switch (action) {
            case "/delete-invoice":
                int id = Integer.parseInt(request.getParameter("id"));
                invoiceDAO.deleteInvoice(id);
                session.setAttribute("success", "Xóa hóa đơn thành công!");
                response.sendRedirect("dashboard-invoices");
                break;

            case "/filter-invoice":
                String phone = request.getParameter("phone");
                String dateStr = request.getParameter("date");
                Date date = null;
                if (dateStr != null && !dateStr.isEmpty()) {
                    date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
                }
                List<ServiceInvoice> filteredList = invoiceDAO.filterInvoices(phone, date);

                // Bổ sung: Lấy thông tin user và serviceName cho danh sách đã lọc
                for (ServiceInvoice invoice : filteredList) {
                    // Lấy thông tin user
                    if (invoice.getUserId() != null) {
                        for (User user : users) {
                            if (user.getUserId() == invoice.getUserId()) {
                                invoice.setFullName(user.getFullName());
                                invoice.setPhoneNumber(user.getPhoneNumber());
                                break;
                            }
                        }
                    }
                    // Lấy tên dịch vụ từ bookingId hoặc serviceId
                    if (invoice.getBookingId() != null) {
                        for (MaintenanceBooking booking : allBookings) {
                            if (booking.getBookingId() == invoice.getBookingId()) {
                                invoice.setServiceName(booking.getServiceName());
                                break;
                            }
                        }
                    } else if (invoice.getServiceId() != null) {
                        for (MaintenanceService service : services) {
                            if (service.getServiceId() == invoice.getServiceId()) {
                                invoice.setServiceName(service.getServiceName());
                                break;
                            }
                        }
                    }
                }
                request.setAttribute("invoiceList", filteredList);
                request.setAttribute("filterPhone", phone);
                request.setAttribute("filterDate", dateStr);
                request.getRequestDispatcher("invoice_management.jsp").forward(request, response);
                break;
            default: // "/dashboard-invoices"
                request.getRequestDispatcher("invoice_management.jsp").forward(request, response);
                break;
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Lỗi: " + e.getMessage());
        response.sendRedirect("dashboard-invoices");
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // Đọc dữ liệu từ form
            String invoiceIdStr = request.getParameter("invoiceId"); // null nếu là thêm mới
            String userIdStr = request.getParameter("userId");
            Integer userId = (userIdStr == null || userIdStr.isEmpty()) ? null : Integer.parseInt(userIdStr);
            String fullName = request.getParameter("fullName");
            String phoneNumber = request.getParameter("phoneNumber");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String status = request.getParameter("status");
            Date paymentDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("paymentDate"));

            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                // ============ THÊM MỚI ============
                if (userId == null) {
                    // Trường hợp không có tài khoản (khách lẻ)
                    String[] serviceIds = request.getParameterValues("serviceIds");
                    if (serviceIds != null && serviceIds.length > 0) {
                        for (String serviceIdStr : serviceIds) {
                            int serviceId = Integer.parseInt(serviceIdStr);

                            ServiceInvoice invoice = new ServiceInvoice();
                            invoice.setUserId(null);
                            invoice.setBookingId(null);
                            invoice.setFullName(fullName);
                            invoice.setPhoneNumber(phoneNumber);
                            invoice.setServiceId(serviceId);
                            invoice.setTotalAmount(totalAmount);
                            invoice.setStatus(status);
                            invoice.setPaymentDate(paymentDate);

                            invoiceDAO.insertInvoice(invoice);
                        }
                    }
                } else {
                    // Có tài khoản => phải có bookingId
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));

                    ServiceInvoice invoice = new ServiceInvoice();
                    invoice.setUserId(userId);
                    invoice.setBookingId(bookingId);
                    invoice.setFullName(null);
                    invoice.setPhoneNumber(null);
                    invoice.setServiceId(null);
                    invoice.setTotalAmount(totalAmount);
                    invoice.setStatus(status);
                    invoice.setPaymentDate(paymentDate);

                    invoiceDAO.insertInvoice(invoice);
                }

                session.setAttribute("message", "Thêm hóa đơn thành công!");
            } else {
                // ============ CHỈNH SỬA ============
                int invoiceId = Integer.parseInt(invoiceIdStr);

                ServiceInvoice invoice = new ServiceInvoice();
                invoice.setInvoiceId(invoiceId);
                invoice.setUserId(userId);
                invoice.setTotalAmount(totalAmount);
                invoice.setStatus(status);
                invoice.setPaymentDate(paymentDate);

                if (userId == null) {
                    // Không có tài khoản: cập nhật thông tin khách + service
                    invoice.setFullName(fullName);
                    invoice.setPhoneNumber(phoneNumber);
                    int serviceId = Integer.parseInt(request.getParameter("serviceId")); // hidden input trong modal sửa
                    invoice.setServiceId(serviceId);
                    invoice.setBookingId(null);
                } else {
                    // Có tài khoản => cập nhật bookingId
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    invoice.setBookingId(bookingId);
                    invoice.setFullName(null);
                    invoice.setPhoneNumber(null);
                    invoice.setServiceId(null);
                }

                invoiceDAO.updateInvoice(invoice);
                session.setAttribute("message", "Cập nhật hóa đơn thành công!");
            }

            response.sendRedirect("dashboard-invoices");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi xử lý hóa đơn: " + e.getMessage());
            response.sendRedirect("dashboard-invoices");
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
