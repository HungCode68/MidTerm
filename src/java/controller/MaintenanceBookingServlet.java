/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.sql.Connection;
import context.DBContext;
import dao.CarDAO;
import dao.MaintenanceBookingDAO;
import dao.MaintenanceServiceDAO;
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
import model.MaintenanceBooking;
import model.MaintenanceService;
import model.User;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "MaintenanceBookingServlet", urlPatterns = {"/maintenance-booking"})
public class MaintenanceBookingServlet extends HttpServlet {

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
            out.println("<title>Servlet MaintenanceBookingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MaintenanceBookingServlet at " + request.getContextPath() + "</h1>");
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
        } catch (Exception e) {
            throw new ServletException("Không thể kết nối CSDL", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách xe để hiện dropdown mẫu xe
            try {
                Connection conn = DBContext.getConnection(); // hoặc DBUtil.getConnection()
                CarDAO carDAO = new CarDAO(conn);
                List<Car> carList = carDAO.getAllCars();
                request.setAttribute("carList", carList);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể tải danh sách xe");
            }

            // Lấy danh sách dịch vụ bảo dưỡng
            try {
                Connection conn = DBContext.getConnection(); // hoặc DBUtil.getConnection()
                MaintenanceServiceDAO serviceDAO = new MaintenanceServiceDAO(conn);
                List<MaintenanceService> services = serviceDAO.getAllServices();
                request.setAttribute("services", services);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể tải danh sách dịch vụ");
            }

            request.getRequestDispatcher("maintenance_booking_form.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu form: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
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
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String carModel = request.getParameter("carModel");
            String licensePlate = request.getParameter("licensePlate");
            int kilometer = Integer.parseInt(request.getParameter("kilometer"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String scheduledTimeStr = request.getParameter("scheduledTime");
            String phoneNumber = request.getParameter("phoneNumber");
            String fullName = request.getParameter("fullName");

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime localDateTime = LocalDateTime.parse(scheduledTimeStr, formatter);
            Timestamp scheduledTime = Timestamp.valueOf(localDateTime);

            // Tạo đối tượng Booking
            MaintenanceBooking booking = new MaintenanceBooking();
            booking.setUserId(currentUser.getUserId());
            booking.setCarModel(carModel);
            booking.setLicensePlate(licensePlate);
            booking.setKilometer(kilometer);
            booking.setServiceId(serviceId);
            booking.setProvince(province);
            booking.setDistrict(district);
            booking.setScheduledTime(scheduledTime);
            booking.setPhoneNumber(phoneNumber);
            booking.setFullName(fullName);

            bookingDAO.insertBooking(booking);

            request.setAttribute("success", "Đăng ký bảo dưỡng thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi gửi yêu cầu: " + e.getMessage());
        }

        // Hiển thị lại form với thông báo
        request.getRequestDispatcher("maintenance_booking_form.jsp").forward(request, response);

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
