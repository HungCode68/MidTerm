<%-- 
    Document   : deposit_management
    Created on : Jul 7, 2025, 10:36:03 AM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Deposit" %>
<%@ page import="model.User" %>
<%@ page import="model.Car" %>
<%@ page import="model.Showroom" %>


<%
    List<Deposit> deposits = (List<Deposit>) request.getAttribute("deposits");
    List<User> users = (List<User>) request.getAttribute("users");
     List<Car> cars = (List<Car>) request.getAttribute("cars");
      User currentUser = (User) session.getAttribute("currentUser");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<html>
    <head>
        <title>Quản lý đặt cọc</title>
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


        <h2 class="mb-4">Quản lý đặt cọc</h2>

       <form method="get" action="dashboard-deposits" class="form-inline mb-3">
    <input type="text" name="phone" class="form-control mr-2" placeholder="SĐT người dùng" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" />

    <select name="status" class="form-control mr-2">
        <option value="">-- Trạng thái --</option>
        <option value="pending" <%= "pending".equals(request.getAttribute("status")) ? "selected" : "" %>>Chờ xác nhận</option>
        <option value="confirm" <%= "confirm".equals(request.getAttribute("status")) ? "selected" : "" %>>Đã xác nhận</option>
        <option value="cancel" <%= "cancel".equals(request.getAttribute("status")) ? "selected" : "" %>>Đã huỷ</option>
    </select>

    <input type="date" name="depositDate" class="form-control mr-2" />

    <button type="submit" class="btn btn-primary">Lọc</button>
    <a href="dashboard-deposits" class="btn btn-secondary ml-2">Xoá bộ lọc</a>
</form>


        <!-- Nút thêm -->
        <button class="btn btn-success mb-3" data-toggle="modal" data-target="#addModal">+ Thêm đặt cọc</button>

        <!-- Bảng danh sách -->
      <table class="table table-bordered table-striped">
    <thead class="bg-white text-dark text-center">
        <tr>
            <th style="width: 5%;">ID</th>
            <th style="width: 15%;">Tên</th>
            <th style="width: 10%;">Điện thoại</th>
            <th style="width: 8%;">Xe</th>
            <th style="width: 10%;">Màu ngoại thất</th>
            <th style="width: 10%;">Màu nội thất</th>
            <th style="width: 10%;">CCCD</th>
            <th style="width: 8%;">Tỉnh</th>
            <th style="width: 10%;">Showroom</th>
            <th style="width: 8%;">Thanh toán</th>
            <th style="width: 10%;">Ngày</th>
            <th style="width: 10%;">Trạng thái</th>
            <th style="width: 10%;">Thao tác</th>
        </tr>
    </thead>
    <tbody>
        <% if (deposits != null) {
            for (Deposit d : deposits) { %>
        <tr>
            <td><%= d.getDepositId() %></td>
            <td><%= d.getFullName() %></td>
            <td><%= d.getPhoneNumber() %></td>
            <td><%= d.getCarName() %></td>
            <td><%= d.getColorExterior() %></td>
            <td><%= d.getColorInterior() %></td>
            <td><%= d.getCccd() %></td>
            <td><%= d.getProvince() %></td>
            <td><%= d.getShowroomName() %></td>
            <td><%= d.getPaymentMethod() %></td>
            <td><%= d.getDepositDate() %></td>
            <td><%= d.getStatus() %></td>
            <td class="text-center">
                <button class="btn btn-info btn-sm text-white" data-toggle="modal"
                        data-target="#editModal"
                        onclick="fillEditModal(<%= d.getDepositId() %>, '<%= d.getFullName() %>', '<%= d.getPhoneNumber() %>', '<%= d.getCccd() %>', '<%= d.getColorExterior() %>', '<%= d.getColorInterior() %>', '<%= d.getProvince() %>', <%= d.getCarId() %>, <%= d.getShowroomId() %>, '<%= d.getPaymentMethod() %>', '<%= d.getStatus() %>', '<%= d.getUserId() == null ? "null" : d.getUserId() %>')">
                    Sửa
                </button>
                <a href="delete-deposit?id=<%= d.getDepositId() %>" class="btn btn-sm btn-danger"
                   onclick="return confirmDelete(event)">Xoá</a>
            </td>
        </tr>
        <% }} %>
    </tbody>
</table>

    <div class="modal fade" id="addModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg">
        <form method="post" action="add-deposit" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm đặt cọc</h5>
             <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Tài khoản người dùng:</label>
                        <select name="userId" class="form-control mb-2" id="userSelect" onchange="toggleInputs()">
                            <option value="">-- Không có tài khoản --</option>
                            <% if (users != null) {
                                for (User u : users) { %>
                            <option value="<%= u.getUserId() %>"><%= u.getFullName() %></option>
                            <% }} %>
                        </select>

                        <div id="userInfoInputs" class="mt-3">
                            <label class="form-label">Họ tên:</label>
                            <input name="fullName" placeholder="Họ tên" class="form-control mb-2" required />

                            <label class="form-label">Số điện thoại:</label>
                            <input name="phoneNumber" placeholder="Số điện thoại" class="form-control mb-2" required />

                            <label class="form-label">Căn cước công dân:</label>
                            <input name="cccd" placeholder="Căn cước công dân" class="form-control mb-2" required />
                        </div>

                        <label class="form-label">Màu ngoại thất:</label>
                        <select name="colorExterior" class="form-control mb-2" required>
                            <option value="">-- Select exterior color --</option>
                            <option value="White">White</option>
                            <option value="Black">Black</option>
                            <option value="Grey">Grey</option>
                            <option value="Red">Red</option>
                            <option value="Blue">Blue</option>
                        </select>

                        <label class="form-label">Màu nội thất:</label>
                        <select name="colorInterior" class="form-control mb-2" required>
                            <option value="">-- Select interior color --</option>
                            <option value="Black">Black</option>
                            <option value="Beige">Beige</option>
                            <option value="Brown">Brown</option>
                            <option value="Grey">Grey</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Tỉnh:</label>
                        <input name="province" placeholder="Tỉnh" class="form-control mb-2" required />

                        <label class="form-label">Chọn xe:</label>
                        <select name="carId" class="form-control mb-2" required>
                            <option value="">-- Chọn xe --</option>
                            <% for (Car c : cars) { %>
                            <option value="<%= c.getCarId() %>"><%= c.getModelName() %></option>
                            <% } %>
                        </select>

                        <label class="form-label">Chọn showroom:</label>
                        <select name="showroomId" class="form-control mb-2" required>
                            <option value="">-- Chọn showroom --</option>
                            <%
                                List<Showroom> showrooms = (List<Showroom>) request.getAttribute("showrooms");
                                if (showrooms != null) {
                                    for (Showroom s : showrooms) {
                            %>
                            <option value="<%= s.getShowroomId() %>"><%= s.getName() %></option>
                            <% } } %>
                        </select>

                        <label class="form-label">Phương thức thanh toán:</label>
                        <select name="paymentMethod" class="form-control mb-2" required>
                            <option value="">-- Phương thức thanh toán --</option>
                            <option value="chuyển khoản">Chuyển khoản</option>
                            <option value="visa">Visa</option>
                            <option value="banking">Banking</option>
                        </select>

                        <label class="form-label">Trạng thái:</label>
                        <select name="status" class="form-control mb-2" required>
                            <option value="pending">Chờ xác nhận</option>
                            <option value="confirm">Đã xác nhận</option>
                            <option value="cancel">Đã huỷ</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary" type="submit">Lưu</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>


    <div class="modal fade" id="editModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <form method="post" action="dashboard-deposits" class="modal-content">
            <div class="modal-header">
                <h5>Cập nhật đặt cọc</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="depositId" id="editDepositId" />
                <input type="hidden" name="userId" id="editUserId" />

                <div class="form-group">
                    <label for="editFullName">Full Name</label>
                    <input name="fullName" id="editFullName" placeholder="Họ tên" class="form-control mb-2" required />
                </div>

                <div class="form-group">
                    <label for="editPhoneNumber">Phone Number</label>
                    <input name="phoneNumber" id="editPhoneNumber" placeholder="Số điện thoại" class="form-control mb-2" required />
                </div>

                <div class="form-group">
                    <label for="editCccd">Citizen ID / Passport</label>
                    <input name="cccd" id="editCccd" placeholder="Căn cước công dân" class="form-control mb-2" required />
                </div>

                <div class="form-group">
                    <label for="editProvince">Province</label>
                    <input name="province" id="editProvince" placeholder="Tỉnh" class="form-control mb-2" required />
                </div>

                <div class="form-group">
                    <label for="editColorExterior">Exterior Color</label>
                    <select name="colorExterior" id="editColorExterior" class="form-control mb-2" required>
                        <option value="">-- Select exterior color --</option>
                        <option value="White">White</option>
                        <option value="Black">Black</option>
                        <option value="Grey">Grey</option>
                        <option value="Red">Red</option>
                        <option value="Blue">Blue</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editColorInterior">Interior Color</label>
                    <select name="colorInterior" id="editColorInterior" class="form-control mb-2" required>
                        <option value="">-- Select interior color --</option>
                        <option value="Black">Black</option>
                        <option value="Beige">Beige</option>
                        <option value="Brown">Brown</option>
                        <option value="Grey">Grey</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editCarId">Car</label>
                    <select name="carId" id="editCarId" class="form-control mb-2" required>
                        <option value="">-- Chọn xe --</option>
                        <% for (Car c : cars) { %>
                        <option value="<%= c.getCarId() %>"><%= c.getModelName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editShowroomId">Showroom</label>
                    <select name="showroomId" id="editShowroomId" class="form-control mb-2" required>
                        <option value="">-- Chọn showroom --</option>
                        <% for (Showroom s : showrooms) { %>
                        <option value="<%= s.getShowroomId() %>"><%= s.getName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editPaymentMethod">Payment Method</label>
                    <select name="paymentMethod" id="editPaymentMethod" class="form-control mb-2" required>
                        <option value="chuyển khoản">Chuyển khoản</option>
                        <option value="visa">Visa</option>
                        <option value="banking">Banking</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editStatus">Status</label>
                    <select name="status" id="editStatus" class="form-control mb-2" required>
                        <option value="pending">Chờ xác nhận</option>
                        <option value="confirm">Đã xác nhận</option>
                        <option value="cancel">Đã huỷ</option>
                    </select>
                </div>

            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" type="submit">Cập nhật</button>
                <button class="btn btn-secondary" data-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>


    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
                            function toggleInputs() {
                                const userSelect = document.getElementById("userSelect");
                                const userInfo = document.getElementById("userInfoInputs");

                                if (userSelect.value === "") {
                                    userInfo.style.display = "block";
                                    [...userInfo.querySelectorAll("input")].forEach(input => input.required = true);
                                } else {
                                    userInfo.style.display = "none";
                                    [...userInfo.querySelectorAll("input")].forEach(input => input.required = false);
                                }
                            }

                            function confirmDelete(e) {
                                e.preventDefault();
                                Swal.fire({
                                    title: 'Xoá đặt cọc?',
                                    text: "Bạn có chắc muốn xoá không?",
                                    icon: 'warning',
                                    showCancelButton: true,
                                    confirmButtonText: 'Xoá',
                                    cancelButtonText: 'Huỷ'
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        window.location.href = e.target.href;
                                    }
                                });
                                return false;
                            }

                            function fillEditModal(id, fullName, phone, cccd, exterior, interior, province, carId, showroomId, payment, status, userId) {
                                document.getElementById("editDepositId").value = id;
                                document.getElementById("editUserId").value = (userId === 'null') ? "" : userId;

                                document.getElementById("editFullName").value = fullName;
                                document.getElementById("editPhoneNumber").value = phone;
                                document.getElementById("editCccd").value = cccd;
                                document.getElementById("editProvince").value = province;

                                // Sử dụng setSelectedOptionByValue cho các trường select
                                setSelectedOptionByValue("editColorExterior", exterior.trim());
                                setSelectedOptionByValue("editColorInterior", interior.trim());
                                setSelectedOptionByValue("editCarId", carId);
                                setSelectedOptionByValue("editShowroomId", showroomId);
                                setSelectedOptionByValue("editPaymentMethod", payment.trim());
                                setSelectedOptionByValue("editStatus", status.trim());
                            }


                            // Hàm chọn option nếu giá trị không match do encoding
                            function setSelectedOptionByValue(selectId, value) {
                                                            const select = document.getElementById(selectId);
                                                            if (select) {
                                                                    select.value = value;
                                                            }
                                                    }

        <% if (success != null) { %>
                            Swal.fire({icon: 'success', title: 'Thành công', text: '<%= success %>'});
        <% } %>
        <% if (error != null) { %>
                            Swal.fire({icon: 'error', title: 'Lỗi', text: '<%= error %>'});
        <% } %>

                            // Gọi toggle khi mở modal
                            $('#addModal').on('shown.bs.modal', toggleInputs);
    </script>
</body>
</html>
