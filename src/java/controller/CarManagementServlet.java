/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import context.DBContext;
import dao.CarDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;
import model.Car;

/**
 *
 * @author Nguyễn Hùng
 */
@WebServlet(name = "CarManagementServlet", urlPatterns = {"/dashboard-cars", "/add-car", "/edit-car", "/delete-car"})
public class CarManagementServlet extends HttpServlet {

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
            out.println("<title>Servlet CarManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CarManagementServlet at " + request.getContextPath() + "</h1>");
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
           
            // hoặc bạn tự inject Connection ở đây
            carDAO = new CarDAO(DBContext.getConnection()); // <-- THAY bằng class của bạn
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo DAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/dashboard-cars":

                try {
                    List<Car> carList = carDAO.getAllCars();
                    request.setAttribute("carList", carList);
                    RequestDispatcher rd = request.getRequestDispatcher("car_dashboard.jsp");
                    rd.forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("car_dashboard.jsp?error=load");
                }
                break;

            case "/delete-car":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    carDAO.deleteCar(id);
                    response.sendRedirect("cars?success=delete");
                } catch (Exception e) {
                    response.sendRedirect("cars?error=delete");
                }
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
        case "/add-car":
            try {
                String modelName = request.getParameter("modelName");
                String priceStr = request.getParameter("price");
                String imageUrl = request.getParameter("imageUrl");
                String description = request.getParameter("description");
                String specifications = request.getParameter("specifications");

                Car car = new Car();
                car.setModelName(modelName);
                car.setPrice(new BigDecimal(priceStr).doubleValue()); // dùng BigDecimal cho DECIMAL
                car.setImageUrl(imageUrl);
                car.setDescription(description);
                car.setSpecifications(specifications);

                carDAO.addCar(car);
                  request.setAttribute("successMessage", "Thêm xe mới thành công!");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi thêm xe: " + e.getMessage());
            }
            break;

        case "/edit-car":
            try {
                int carId = Integer.parseInt(request.getParameter("carId"));
                String modelName = request.getParameter("modelName");
                String priceStr = request.getParameter("price");
                String imageUrl = request.getParameter("imageUrl");
                String description = request.getParameter("description");
                String specifications = request.getParameter("specifications");

                Car car = new Car();
                car.setCarId(carId);
                car.setModelName(modelName);
                car.setPrice(new BigDecimal(priceStr).doubleValue());
                car.setImageUrl(imageUrl);
                car.setDescription(description);
                car.setSpecifications(specifications);

                carDAO.updateCar(car);
               request.setAttribute("successMessage", "Cập nhật xe thành công!");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi cập nhật xe: " + e.getMessage());
            }
            break;
    }
    try {
        List<Car> carList = carDAO.getAllCars();
        request.setAttribute("carList", carList);
    } catch (Exception e) {
        request.setAttribute("errorMessage", "Lỗi khi tải danh sách xe: " + e.getMessage());
    }

    request.getRequestDispatcher("car_dashboard.jsp").forward(request, response);
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
