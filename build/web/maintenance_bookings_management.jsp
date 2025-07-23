<%-- 
    Document   : maintenance_bookings_management
    Created on : Jul 12, 2025, 10:30:05 PM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, model.MaintenanceBooking" %>
<%@ page import="model.Car" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%
    
      List<Car> carList = (List<Car>) request.getAttribute("carList");
    User currentUser = (User) session.getAttribute("currentUser");
%>
<html>
    <head>
        <title>Quản lý lịch bảo dưỡng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    </head>
    <body >
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

        
        <h2 class="mb-4">Quản lý lịch bảo dưỡng</h2>

        <!-- Bộ lọc -->
        <form class="row g-3 mb-3" method="get" action="dashboard-bookings">
            <div class="col-auto">
                <input type="text" class="form-control" name="phone" placeholder="Số điện thoại" value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
            </div>
            <div class="col-auto">
                <input type="date" class="form-control" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">Lọc</button>
            </div>
            <div class="col-auto">
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModal">+ Thêm mới</button>
            </div>
        </form>

        <!-- Bảng danh sách -->
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Điện thoại</th>
                    <th>Xe</th>
                    <th>Biển số</th>
                    <th>Km</th>
                    <th>Dịch vụ</th>
                    <th>Tỉnh</th>
                    <th>Huyện</th>
                    <th>Thời gian hẹn</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<MaintenanceBooking> bookings = (List<MaintenanceBooking>) request.getAttribute("bookings");
                    if (bookings != null) {
                        for (MaintenanceBooking b : bookings) {
                %>
                <tr>
                    <td><%= b.getBookingId() %></td>
                    <td><%= b.getFullName() %></td>
                    <td><%= b.getPhoneNumber() %></td>
                    <td><%= b.getCarModel() %></td>
                    <td><%= b.getLicensePlate() %></td>
                    <td><%= b.getKilometer() %></td>
                    <td><%= b.getServiceName() %></td>
                    <td><%= b.getProvince() %></td>
                    <td><%= b.getDistrict() %></td>
                    <td><%= b.getScheduledTime() %></td>
                    <td><%= b.getStatus() %></td>
                    <td>
                        <button class="btn btn-primary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#editModal"
                                onclick="openEditModal(this)"
                                data-booking-id="<%= b.getBookingId() %>"
                                data-user-id="<%= b.getUserId() %>"
                                data-full-name="<%= b.getFullName() %>"
                                data-phone-number="<%= b.getPhoneNumber() %>"
                                data-car-model="<%= b.getCarModel() %>"
                                data-license-plate="<%= b.getLicensePlate() %>"
                                data-kilometer="<%= b.getKilometer() %>"
                                data-service-id="<%= b.getServiceId() %>"
                                data-province="<%= b.getProvince() %>"
                                data-district="<%= b.getDistrict() %>"
                                data-status="<%= b.getStatus() %>"
                                data-scheduled-time="<%= b.getScheduledTime() %>">
                            Sửa
                        </button>

                        <button class="btn btn-danger btn-sm" onclick="confirmDelete(<%= b.getBookingId() %>)">Xoá</button>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>

        <!-- Modal Thêm -->
        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <form action="add-booking" method="post">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm lịch bảo dưỡng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body row g-3">

                            <!-- Chọn tài khoản -->
                            <div class="col-md-12">
                                <label>Tài khoản người dùng:</label>
                                <select class="form-select" name="userId" id="userSelect" onchange="toggleUserFields()">
                                    <option value="">-- Không có tài khoản --</option>
                                    <%
                                        List<model.User> users = (List<model.User>) request.getAttribute("userAccounts");
                                        if (users != null) {
                                            for (model.User u : users) {
                                    %>
                                    <option value="<%= u.getUserId() %>"><%= u.getFullName() %> - <%= u.getEmail() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <!-- Họ tên & SĐT -->
                            <div class="col-md-6 user-field">
                                <label>Họ tên:</label>
                                <input type="text" name="fullName" class="form-control">
                            </div>

                            <div class="col-md-6 user-field">
                                <label>Điện thoại:</label>
                                <input type="text" name="phoneNumber" class="form-control">
                            </div>

                            <!-- Car model -->
                            <div class="col-md-6">
                                <label>Xe:</label>
                                <select name="carModel" class="form-control mb-2" required>
                                    <option value="">-- Chọn mẫu xe --</option>
                                    <% if (carList != null) {
                                for (Car car : carList) { %>
                                    <option value="<%= car.getModelName() %>">
                                        <%= car.getModelName() %> - <%= car.getDescription() %>
                                    </option>
                                    <% }} else { %>
                                    <option disabled>Không có xe nào</option>
                                    <% } %>
                                </select>
                            </div>

                            <!-- License Plate -->
                            <div class="col-md-6">
                                <label>Biển số:</label>
                                <input type="text" name="licensePlate" class="form-control" required>
                            </div>

                            <div class="col-md-6">
                                <label>Số km:</label>
                                <input type="number" name="kilometer" class="form-control" required>
                            </div>

                            <!-- Dịch vụ -->
                            <div class="col-md-6">
                                <label>Dịch vụ:</label>
                                <select name="serviceId" class="form-select" required>
                                    <option value="">-- Chọn dịch vụ --</option>
                                    <%
                                        List<model.MaintenanceService> services = (List<model.MaintenanceService>) request.getAttribute("services");
                                        if (services != null) {
                                            for (model.MaintenanceService s : services) {
                                    %>
                                    <option value="<%= s.getServiceId() %>"><%= s.getServiceName() %> - <%= s.getPrice() %>đ</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label>Tỉnh:</label>
                                <input type="text" name="province" class="form-control" required>
                            </div>

                            <div class="col-md-6">
                                <label>Huyện:</label>
                                <input type="text" name="district" class="form-control" required>
                            </div>

                            <div class="col-md-12">
                                <label>Thời gian hẹn:</label>
                                <input type="datetime-local" name="scheduledTime" class="form-control" required>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-success" type="submit">Lưu</button>
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Sửa -->
        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <form action="edit-booking" method="post">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Cập nhật lịch bảo dưỡng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body row g-3">
                            <input type="hidden" name="bookingId" id="editBookingId">

                            <div class="col-md-6">
                                <label>Họ tên:</label>
                                <input type="text" name="fullName" id="editFullName" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label>Điện thoại:</label>
                                <input type="text" name="phoneNumber" id="editPhoneNumber" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label>Mẫu xe:</label>
                                <input type="text" name="carModel" id="editCarModel" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label>Biển số:</label>
                                <input type="text" name="licensePlate" id="editLicensePlate" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label>Số km:</label>
                                <input type="number" name="kilometer" id="editKilometer" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label>Dịch vụ:</label>
                                <select name="serviceId" id="editServiceId" class="form-select">
                                    <%
                                        if (services != null) {
                                            for (model.MaintenanceService s : services) {
                                    %>
                                    <option value="<%= s.getServiceId() %>"><%= s.getServiceName() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label>Tỉnh:</label>
                                <input type="text" name="province" id="editProvince" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label>Huyện:</label>
                                <input type="text" name="district" id="editDistrict" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label>Trạng thái:</label>
                                <input type="text" name="status" id="editStatus" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label>Thời gian hẹn:</label>
                                <input type="datetime-local" name="scheduledTime" id="editScheduledTime" class="form-control">
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-success" type="submit">Cập nhật</button>
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>



        <!-- JS xử lý -->
        <script>
            function confirmDelete(id) {
                Swal.fire({
                    title: 'Xác nhận xoá?',
                    text: 'Bạn sẽ không thể hoàn tác!',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Xoá',
                    cancelButtonText: 'Huỷ'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = 'delete-booking?id=' + id;
                    }
                });
            }

            function openEditModal(button) {
                document.getElementById('editBookingId').value = button.dataset.bookingId;
                document.getElementById('editFullName').value = button.dataset.fullName;
                document.getElementById('editPhoneNumber').value = button.dataset.phoneNumber;
                document.getElementById('editCarModel').value = button.dataset.carModel;
                document.getElementById('editLicensePlate').value = button.dataset.licensePlate;
                document.getElementById('editKilometer').value = button.dataset.kilometer;
                document.getElementById('editServiceId').value = button.dataset.serviceId;
                document.getElementById('editProvince').value = button.dataset.province;
                document.getElementById('editDistrict').value = button.dataset.district;
                document.getElementById('editStatus').value = button.dataset.status;

                const datetime = button.dataset.scheduledTime.replace(' ', 'T').substring(0, 16);
                document.getElementById('editScheduledTime').value = datetime;
            }

            function toggleUserFields() {
                var userSelect = document.getElementById("userSelect");
                var userFields = document.querySelectorAll(".user-field");
                var hasAccount = userSelect.value !== "";

                userFields.forEach(field => {
                    field.style.display = hasAccount ? "none" : "block";
                });
            }

            // Khi trang tải xong lần đầu
            document.addEventListener("DOMContentLoaded", function () {
                toggleUserFields(); // áp dụng ẩn/hiện ban đầu
            });

            function editBooking(id) {
                window.location.href = 'edit-booking?id=' + id;
            }

            <% String success = (String) session.getAttribute("success");
               if (success != null) {
                   session.removeAttribute("success");
            %>
            Swal.fire('Thành công', '<%= success %>', 'success');
            <% } %>

            <% String error = (String) request.getAttribute("error");
               if (error != null) {
            %>
            Swal.fire('Lỗi', '<%= error %>', 'error');
            <% } %>
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
