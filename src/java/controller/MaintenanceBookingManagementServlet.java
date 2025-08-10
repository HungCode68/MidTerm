/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import context.DBContext;
import dao.CarDAO;
import dao.MaintenanceBookingDAO;
import dao.MaintenanceServiceDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.sql.Connection;
import java.util.List;
import model.Car;
import model.MaintenanceBooking;
import model.MaintenanceService;
import model.User;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "MaintenanceBookingManagementServlet", urlPatterns = {"/dashboard-bookings","/add-booking","/edit-booking","/delete-booking"})
public class MaintenanceBookingManagementServlet extends HttpServlet {

    private MaintenanceBookingDAO bookingDAO;
    private UserDAO userDAO = new UserDAO();
    private CarDAO carDAO;
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
            out.println("<title>Servlet MaintenanceBookingManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MaintenanceBookingManagementServlet at " + request.getContextPath() + "</h1>");
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
            bookingDAO = new MaintenanceBookingDAO(conn);
            userDAO = new UserDAO();
            carDAO = new CarDAO(conn);
            maintenanceServiceDAO = new MaintenanceServiceDAO(conn);
        } catch (Exception e) {
            throw new ServletException("Không thể kết nối CSDL", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            if ("/dashboard-bookings".equals(action)) {
                // --- Gộp logic lọc ở đây ---
                String phone = request.getParameter("phone");
                String dateStr = request.getParameter("date");

                List<MaintenanceBooking> bookings;
                List<Car> carList = carDAO.getAllCars();
                List<MaintenanceService> allServices = maintenanceServiceDAO.getAllServices();
                List<User> userAccounts = userDAO.getAllUsers();
                request.setAttribute("userAccounts", userAccounts);

                if ((phone != null && !phone.trim().isEmpty()) || (dateStr != null && !dateStr.trim().isEmpty())) {
                    java.sql.Date date = (dateStr != null && !dateStr.trim().isEmpty())
                            ? java.sql.Date.valueOf(dateStr)
                            : null;
                    bookings = bookingDAO.getFilteredBookings(phone, date);
                } else {
                    bookings = bookingDAO.getAllBookings();
                }

                request.setAttribute("bookings", bookings);
                request.setAttribute("carList", carList);
                request.setAttribute("services", allServices);
                request.getRequestDispatcher("maintenance_bookings_management.jsp").forward(request, response);

            } else if ("/delete-booking".equals(action)) {
                int deleteId = Integer.parseInt(request.getParameter("id"));
                bookingDAO.deleteBooking(deleteId);
                request.getSession().setAttribute("success", "Xoá thành công!");
                response.sendRedirect("dashboard-bookings");

            } else {
                response.sendRedirect("dashboard-bookings");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("maintenance_bookings_management.jsp").forward(request, response);
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

        try {
            String carModel = request.getParameter("carModel");
            String licensePlate = request.getParameter("licensePlate");
            int kilometer = Integer.parseInt(request.getParameter("kilometer"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String phoneNumber = request.getParameter("phoneNumber");
            String fullName = request.getParameter("fullName");
            String status = request.getParameter("status");
            String rawTime = request.getParameter("scheduledTime"); // Ví dụ: 2025-07-12T14:30
            if (rawTime != null && rawTime.contains("T")) {
                rawTime = rawTime.replace("T", " ") + ":00"; // thành 2025-07-12 14:30:00
            }
            Timestamp scheduledTime = Timestamp.valueOf(rawTime);

            MaintenanceBooking booking = new MaintenanceBooking();
            booking.setCarModel(carModel);
            booking.setLicensePlate(licensePlate);
            booking.setKilometer(kilometer);
            booking.setServiceId(serviceId);
            booking.setProvince(province);
            booking.setDistrict(district);
            booking.setScheduledTime(scheduledTime);
            booking.setPhoneNumber(phoneNumber);
            booking.setFullName(fullName);
            booking.setStatus(status);

            String userIdStr = request.getParameter("userId");
            if (userIdStr != null && !userIdStr.isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                booking.setUserId(userId);

                // Lấy user từ DB
                User user = userDAO.getUserById(userId);
                if (user != null) {
                    booking.setFullName(user.getFullName());
                    booking.setPhoneNumber(user.getPhoneNumber());
                }

            } else {
                booking.setUserId(null);
                booking.setFullName(request.getParameter("fullName"));
                booking.setPhoneNumber(request.getParameter("phoneNumber"));
            }

            if ("/add-booking".equals(action)) {
                bookingDAO.insertBooking(booking);
                request.getSession().setAttribute("success", "Thêm mới thành công!");
            } else if ("/edit-booking".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                booking.setBookingId(bookingId);
                bookingDAO.updateBooking(booking);
                request.getSession().setAttribute("success", "Cập nhật thành công!");
            }

            response.sendRedirect("dashboard-bookings");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            request.getRequestDispatcher("maintenance_bookings_management.jsp").forward(request, response);
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
