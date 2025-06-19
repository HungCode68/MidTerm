/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import context.DBContext;
import dao.CarDAO;
import model.Car;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "CarServlet", urlPatterns = {"/cars"})
public class CarServlet extends HttpServlet {

    private CarDAO carDAO;

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
            out.println("<title>Servlet CarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CarServlet at " + request.getContextPath() + "</h1>");
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
            carDAO = new CarDAO(DBContext.getConnection()); // <-- THAY bằng class của bạn
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo DAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String model = request.getParameter("model");
        String action = request.getParameter("action");
        try {
            if (model != null && !model.trim().isEmpty()) {
                // Nếu có tham số ?model=VF5, thì hiển thị thông tin mẫu xe cụ thể
                Car car = carDAO.getCarByModelName(model);
                if (car != null) {
                    request.setAttribute("car", car);

                    if ("deposit".equals(action)) {
                        request.getRequestDispatcher("deposit_form.jsp").forward(request, response);
                    } else if ("consultation".equals(action)) {
                        // Gửi danh sách xe để dùng trong form tư vấn
                        List<Car> carList = carDAO.getAllCars();
                        request.setAttribute("cars", carList);
                        request.getRequestDispatcher("consultation_form.jsp").forward(request, response);
                    } else {
                        // Mặc định: chuyển đến trang thông tin xe cụ thể (vd: vf8.jsp)
                        request.getRequestDispatcher(model.toLowerCase() + ".jsp").forward(request, response);
                    }

                } else {
                    response.sendError(404, "Không tìm thấy mẫu xe: " + model);
                }
            } else {
                // Nếu không có tham số model, hiển thị danh sách toàn bộ xe
                List<Car> carList = carDAO.getAllCars();
                request.setAttribute("carList", carList);
                request.getRequestDispatcher("testdrive_form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi server: " + e.getMessage());
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
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Hiển thị danh sách hoặc chi tiết xe theo model";
    }// </editor-fold>

}
