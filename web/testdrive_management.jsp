<%-- 
    Document   : testdrive_management
    Created on : Jul 2, 2025, 9:54:43 PM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.TestDrive" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Car" %>
<%@ page import="model.User" %>

<%
    List<Car> cars = (List<Car>) request.getAttribute("cars");
      List<User> users = (List<User>) request.getAttribute("users");
        User currentUser = (User) session.getAttribute("currentUser");
     String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<html>
    <head>
        <title>Quản lý lịch lái thử</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    </head>
    <body >
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm" >
    <div class="container-fluid">
        <a class="navbar-brand font-weight-bold text-white" href="#">
            <i class="fas fa-tools mr-1"></i> Management Page
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item <%= request.getServletPath().equals("/dashboard") ? "active" : "" %>">
                    <a class="nav-link text-white" href="dashboard"><i class="fas fa-user-cog mr-1"></i> Account Management</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-cars"><i class="fas fa-car mr-1"></i> Car Management</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-consultations"><i class="fas fa-comments mr-1"></i> Consultation</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-testdrives"><i class="fas fa-road mr-1"></i> Test Drive</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-deposits"><i class="fas fa-file-invoice-dollar mr-1"></i> Deposits</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-maintenance-services"><i class="fas fa-tools mr-1"></i> Maintenance Services</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-bookings"><i class="fas fa-calendar-check mr-1"></i> Maintenance Bookings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-showrooms"><i class="fas fa-store mr-1"></i> Showroom Management</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/dashboard-invoices"><i class="fas fa-receipt mr-1"></i> Invoices</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="/VinfastSystem/StatisticsManagementServlet"><i class="fas fa-chart-line mr-1"></i> Statistics</a>
                </li>
            </ul>

            <span class="navbar-text ml-auto text-white">
                <i class="fas fa-user-circle mr-1"></i>
                Hello, <strong><%= currentUser.getFullName() %></strong>
            </span>
        </div>
    </div>
</nav>

        
        <h2 class="mb-4">Quản lý lịch lái thử</h2>

        <!-- Form tìm kiếm -->
        <form method="get" action="dashboard-testdrives" class="form-inline mb-4">
            <input type="text" name="phone" class="form-control mr-2" placeholder="Số điện thoại"
                   value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">

            <input type="date" name="date" class="form-control mr-2"
                   value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">

            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            <a href="dashboard-testdrives" class="btn btn-secondary ml-2">Xoá bộ lọc</a>
        </form>


        <!-- Nút Thêm -->
        <button class="btn btn-success mb-3" data-toggle="modal" data-target="#addModal">+ Thêm lịch</button>

        <!-- Bảng danh sách -->
        <table class="table table-bordered table-striped">
            <thead class="bg-white text-dark text-center">
                <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>SDT</th>
                    <th>Địa chỉ</th>
                    <th>Tỉnh</th>
                    <th>Xe</th>
                    <th>Thời gian</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<TestDrive> list = (List<TestDrive>) request.getAttribute("testDrives");
                    if (list != null) {
                        for (TestDrive td : list) {
                %>
                <tr>
                    <td><%= td.getTestDriveId() %></td>
                    <td><%= td.getFullName() %></td>
                    <td><%= td.getPhoneNumber() %></td>
                    <td><%= td.getAddress() %></td>
                    <td><%= td.getProvince() %></td>
                    <td><%= td.getCarName() %></td>
                    <td><%= td.getScheduledTime() %></td>
                    <td>
                        <button class="btn btn-info btn-sm text-white" data-toggle="modal" data-target="#editModal"
                                onclick="fillEditModal(<%= td.getTestDriveId() %>, '<%= td.getFullName() %>', '<%= td.getPhoneNumber() %>', '<%= td.getProvince() %>', '<%= td.getAddress() %>', <%= td.getCarId() %>, '<%= td.getScheduledTime() %>', <%= td.getUserId() != null ? td.getUserId() : "''" %>)">Sửa</button>
                        <a href="delete-testdrives?id=<%= td.getTestDriveId() %>" class="btn btn-sm btn-danger"
                           onclick="return confirmDelete(event)">Xoá</a>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>

      <!-- Modal Thêm -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <form method="post" action="add-testdrives" class="modal-content">
            <div class="modal-header"><h5>Thêm lịch lái thử</h5></div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="userIdSelect">Tài khoản (nếu có)</label>
                    <select name="userId" class="form-control" id="userIdSelect">
                        <option value="">-- Không có tài khoản --</option>
                        <% for (User u : users) { %>
                        <option value="<%= u.getUserId() %>"><%= u.getFullName() %></option>
                        <% } %>
                    </select>
                </div>

                <div id="userInputs">
                    <div class="form-group">
                        <label for="fullNameInput">Họ tên</label>
                        <input name="fullName" id="fullNameInput" placeholder="Họ tên" class="form-control" required/>
                    </div>
                    <div class="form-group">
                        <label for="phoneInput">Số điện thoại</label>
                        <input name="phoneNumber" id="phoneInput" placeholder="Số điện thoại" class="form-control" required/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="province">Tỉnh</label>
                    <input name="province" id="province" placeholder="Tỉnh" class="form-control" required/>
                </div>

                <div class="form-group">
                    <label for="address">Địa chỉ</label>
                    <input name="address" id="address" placeholder="Địa chỉ" class="form-control" required/>
                </div>

                <div class="form-group">
                    <label for="carId">Chọn xe</label>
                    <select name="carId" id="carId" class="form-control" required>
                        <option value="">-- Chọn xe --</option>
                        <% for (Car car : cars) { %>
                        <option value="<%= car.getCarId() %>"><%= car.getModelName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="scheduledTime">Thời gian lái thử</label>
                    <input name="scheduledTime" type="datetime-local" id="scheduledTime" class="form-control" required/>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" type="submit">Lưu</button>
                <button class="btn btn-secondary" data-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>


       <!-- Modal Sửa -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <form method="post" action="edit-testdrives" class="modal-content">
            <input type="hidden" name="testDriveId" id="editId"/>
            <div class="modal-header"><h5>Sửa lịch lái thử</h5></div>
            <div class="modal-body">

                <div class="form-group">
                    <label for="editUserId">Tài khoản (nếu có)</label>
                    <select name="userId" id="editUserId" class="form-control">
                        <option value="">-- Không có tài khoản --</option>
                        <% for (User u : users) { %>
                        <option value="<%= u.getUserId() %>"><%= u.getFullName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editName">Họ tên</label>
                    <input name="fullName" id="editName" class="form-control" required/>
                </div>

                <div class="form-group">
                    <label for="editPhone">Số điện thoại</label>
                    <input name="phoneNumber" id="editPhone" class="form-control" required/>
                </div>

                <div class="form-group">
                    <label for="editProvince">Tỉnh</label>
                    <input name="province" id="editProvince" class="form-control" required/>
                </div>

                <div class="form-group">
                    <label for="editAddress">Địa chỉ</label>
                    <input name="address" id="editAddress" class="form-control" required/>
                </div>

                <div class="form-group">
                    <label for="editCarId">Chọn xe</label>
                    <select name="carId" id="editCarId" class="form-control" required>
                        <option value="">-- Chọn xe --</option>
                        <% for (Car car : cars) { %>
                        <option value="<%= car.getCarId() %>"><%= car.getModelName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editTime">Thời gian lái thử</label>
                    <input name="scheduledTime" id="editTime" type="datetime-local" class="form-control" required/>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" type="submit">Cập nhật</button>
                <button class="btn btn-secondary" data-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>


        <!-- Script xử lý -->
        <script>
            function fillEditModal(id, name, phone, province, address, carId, time, userId = '') {
                document.getElementById("editId").value = id;
                document.getElementById("editName").value = name;
                document.getElementById("editPhone").value = phone;
                document.getElementById("editProvince").value = province;
                document.getElementById("editAddress").value = address;
                document.getElementById("editCarId").value = carId;
                document.getElementById("editTime").value = time.replace(' ', 'T').substring(0, 16);
                document.getElementById("editUserId").value = userId;
            }

            function toggleUserInputs() {
                const select = document.getElementById("userIdSelect");
                const userInputs = document.getElementById("userInputs");

                if (select.value === "") {
                    userInputs.style.display = "block";
                    document.getElementById("fullNameInput").required = true;
                    document.getElementById("phoneInput").required = true;
                } else {
                    userInputs.style.display = "none";
                    document.getElementById("fullNameInput").required = false;
                    document.getElementById("phoneInput").required = false;
                }
            }

            // Khi mở modal thì cập nhật trạng thái input
            $('#addModal').on('shown.bs.modal', function () {
                toggleUserInputs();
            });

            // ✅ BẮT sự kiện onchange sau khi DOM đã tải xong
            $(document).ready(function () {
                $('#userIdSelect').on('change', function () {
                    toggleUserInputs();
                });

                // Gọi luôn toggleUserInputs nếu modal được mở bằng JS mà không trigger event
                toggleUserInputs();
            });

            function confirmDelete(e) {
                e.preventDefault();
                Swal.fire({
                    title: 'Xác nhận xóa?',
                    text: "Hành động này không thể hoàn tác!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Xóa',
                    cancelButtonText: 'Huỷ'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = e.target.href;
                    }
                });
                return false;
            }

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

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
