<%-- 
    Document   : consultation_management
    Created on : Jul 1, 2025, 10:32:31 PM
    Author     : Nguyễn Hùng
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.Consultation" %>
<%@ page import="model.Car" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
    List<Car> cars = (List<Car>) request.getAttribute("cars");
    List<User> users = (List<User>) request.getAttribute("users");
     User currentUser = (User) session.getAttribute("currentUser");
     String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý tư vấn</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    </head>
    
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand font-weight-bold" href="#">
            <i class="fas fa-tools mr-1"></i> Trang quản lý
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item <%= request.getServletPath().equals("/dashboard") ? "active" : "" %>">
                    <a class="nav-link" href="dashboard"><i class="fas fa-user-cog mr-1"></i> Quản lý tài khoản</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-cars"><i class="fas fa-car mr-1"></i> Quản lý xe</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-consultations"><i class="fas fa-comments mr-1"></i> Quản lý tư vấn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-testdrives"><i class="fas fa-road mr-1"></i> Đăng ký lái thử</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-deposits"><i class="fas fa-file-invoice-dollar mr-1"></i> Đặt cọc</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-maintenance-services"><i class="fas fa-tools mr-1"></i> Dịch vụ bảo dưỡng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-bookings"><i class="fas fa-calendar-check mr-1"></i> Đặt lịch bảo dưỡng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-showrooms"><i class="fas fa-store mr-1"></i> Quản lý cửa hàng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/dashboard-invoices"><i class="fas fa-receipt mr-1"></i> Hóa đơn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/VinfastSystem/StatisticsManagementServlet"><i class="fas fa-chart-line mr-1"></i> Thống kê</a>
                </li>
            </ul>

            <span class="navbar-text ml-auto text-light">
                <i class="fas fa-user-circle mr-1"></i>
                Xin chào, <strong><%= currentUser.getFullName() %></strong>
            </span>
        </div>
    </div>
</nav>
        <div >
            <h2 class="text-center mb-4">Quản lý yêu cầu tư vấn</h2>

            <!-- Form tìm kiếm -->
            <form method="get" action="dashboard-consultations" class="form-inline mb-4">
                <input type="text" name="phone" class="form-control mr-2" placeholder="Số điện thoại"
                       value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                <input type="date" name="date" class="form-control mr-2"
                       value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                <a href="dashboard-consultations" class="btn btn-secondary ml-2">Xoá bộ lọc</a>
            </form>

            <!-- Nút thêm -->
            <button class="btn btn-primary mb-3" data-toggle="modal" data-target="#addModal">+ Thêm tư vấn</button>

            <!-- Bảng danh sách -->
            <table class="table table-bordered table-striped">
                <thead class="thead-dark text-center">
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>UserId</th>
                        <th>SĐT</th>
                        <th>Tên xe</th>
                        <th>Ngày yêu cầu</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Consultation c : consultations) { %>
                    <tr>
                        <td class="text-center"><%= c.getConsultationId() %></td>
                        <td><%= c.getUserName() != null ? c.getUserName() : c.getFullName() %></td>
                        <td><%= c.getUserId() != null ? c.getUserId() : "--" %></td>
                        <td><%= c.getPhoneNumber() %></td>
                        <td><%= c.getCarModelName() != null ? c.getCarModelName() : "--" %></td>
                        <td><%= c.getRequestDate() %></td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-success"
                                    data-toggle="modal"
                                    data-target="#editModal"
                                    onclick="fillEditForm(
                                                    '<%= c.getConsultationId() %>',
                                                    '<%= c.getUserId() != null ? c.getUserId() : "" %>',
                                                    '<%= c.getCarId() %>',
                                                    '<%= c.getFullName() != null ? c.getFullName().replace("'", "\\'") : "" %>',
                                                    '<%= c.getPhoneNumber() != null ? c.getPhoneNumber().replace("'", "\\'") : "" %>'
                                                    )"
                                    >Sửa</button>
                            <a href="delete-consultation?id=<%= c.getConsultationId() %>"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa tư vấn này?')">Xóa</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Modal Thêm -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <form method="post" action="add-consultation" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm tư vấn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-3">

                <!-- Chọn tài khoản -->
                <div class="mb-3">
                    <label for="userId" class="form-label">Chọn tài khoản người dùng:</label>
                    <select name="userId" id="userId" class="form-control mb-2" onchange="togglePhoneField()">
                        <option value="">-- Không có tài khoản --</option>
                        <% if (users != null) {
                            for (User user : users) { %>
                                <option value="<%= user.getUserId() %>"><%= user.getFullName() %></option>
                        <%  }} %>
                    </select>
                </div>

                <!-- Nhập họ tên -->
                <div id="nameInputGroup" class="mb-3" style="display:none;">
                    <label for="fullName" class="form-label">Họ và tên:</label>
                    <input type="text" name="fullName" id="fullName" placeholder="Nhập họ tên" class="form-control">
                </div>

                <!-- Nhập số điện thoại -->
                <div id="phoneInputGroup" class="mb-3" style="display:none;">
                    <label for="phoneNumber" class="form-label">Số điện thoại:</label>
                    <input type="text" name="phoneNumber" id="phoneNumber" placeholder="Nhập số điện thoại" class="form-control">
                </div>

                <!-- Chọn xe -->
                <div class="mb-3">
                    <label for="carId" class="form-label">Chọn xe cần tư vấn:</label>
                    <select name="carId" class="form-control mb-2" required>
                        <option value="">-- Chọn xe --</option>
                        <% for (Car c : cars) { %>
                            <option value="<%= c.getCarId() %>"><%= c.getModelName() %></option>
                        <% } %>
                    </select>
                </div>

            </div>

            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Đăng ký</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            </div>
        </form>
    </div>
</div>


        <!-- Modal Sửa -->
        <div class="modal fade" id="editModal" tabindex="-1" role="dialog">
            <div class="modal-dialog">
                <form method="post" action="edit-consultation" class="modal-content">
                    <div class="modal-header"><h5 class="modal-title">Sửa tư vấn</h5></div>
                    <div class="modal-body">
                        <input type="hidden" name="consultationId" id="editConsultationId"/>

                        <label for="editUserId">Chọn tài khoản người dùng:</label>
                        <select name="userId" id="editUserId" class="form-control mb-2" onchange="toggleEditPhoneField()">
                            <option value="">-- Không có tài khoản --</option>
                            <% for (User u : users) { %>
                            <option value="<%= u.getUserId() %>"><%= u.getFullName() %></option>
                            <% } %>
                        </select>

                        <div id="editNameInputGroup" style="display:none;">
                            <label for="editFullName">Họ và tên:</label>
                            <input type="text" name="fullName" id="editFullName" class="form-control mb-2" placeholder="Nhập họ tên">
                        </div>

                        <div id="editPhoneInputGroup" style="display:none;">
                            <label for="editPhoneNumber">Số điện thoại:</label>
                            <input type="text" name="phoneNumber" id="editPhoneNumber" class="form-control mb-2" placeholder="Nhập số điện thoại">
                        </div>

                        <label for="editCarId">Chọn xe:</label>
                        <select name="carId" id="editCarId" class="form-control mb-2" required>
                            <option value="">-- Chọn xe --</option>
                            <% for (Car c : cars) { %>
                            <option value="<%= c.getCarId() %>"><%= c.getModelName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Cập nhật</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>



        <script>
            function fillEditForm(id, userId, carId, fullName, phoneNumber) {
                document.getElementById('editConsultationId').value = id;
                document.getElementById('editUserId').value = userId || "";

                document.getElementById('editCarId').value = carId;
                document.getElementById('editFullName').value = fullName || "";
                document.getElementById('editPhoneNumber').value = phoneNumber || "";

                toggleEditPhoneField(); // Bật/tắt input tên + SĐT nếu không có tài khoản
            }


            function togglePhoneField() {
                var userSelect = document.getElementById("userId");
                var phoneGroup = document.getElementById("phoneInputGroup");
                var nameGroup = document.getElementById("nameInputGroup");

                if (userSelect.value === "") {
                    phoneGroup.style.display = "block";
                    nameGroup.style.display = "block";
                } else {
                    phoneGroup.style.display = "none";
                    nameGroup.style.display = "none";
                }
            }

            window.onload = togglePhoneField;

            <% if (success != null) { %>
            Swal.fire({
                icon: 'success',
                title: 'Thành công',
                text: '<%= success %>',
                confirmButtonText: 'OK'
            });
            <% } %>

            <% if (error != null) { %>
            Swal.fire({
                icon: 'error',
                title: 'Lỗi',
                text: '<%= error %>',
                confirmButtonText: 'OK'
            });
            <% } %>

        </script>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>


