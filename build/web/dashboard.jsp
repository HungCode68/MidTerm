<%-- 
    Document   : dashboard
    Created on : Jun 21, 2025, 9:43:25 PM
    Author     : Nguyễn Hùng
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<User> userList = (List<User>) request.getAttribute("userList");
     User currentUser = (User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý tài khoản</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
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


    
  <%
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    if (success != null || error != null) {
%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        Swal.fire({
            icon: '<%= success != null ? "success" : "error" %>',
            title: '<%= success != null ? "Thành công!" : "Lỗi!" %>',
            text: '<%= success != null ? success : error %>',
            confirmButtonText: 'Đóng'
        });
    });
</script>
<%
        session.removeAttribute("success");
        session.removeAttribute("error");
    }
%>


    
<div >
    <h2 class="text-center mb-4">Quản lý tài khoản người dùng</h2>

    <!-- Nút thêm -->
    <button class="btn btn-primary mb-3" data-toggle="modal" data-target="#addModal">+ Thêm tài khoản</button>

    <!-- Bảng tài khoản -->
    <table class="table table-bordered table-striped">
        <thead class="thead-dark text-center">
            <tr>
                <th>STT</th>
                <th>Họ tên</th>
                <th>Email</th>
                <th>SĐT</th>
                <th>CCCD</th>
                <th>Vai trò</th>
                <th>Ngày tạo</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
        <%
            int index = 1;
            for (User user : userList) {
        %>
            <tr>
                <td class="text-center"><%= index++ %></td>
                <td><%= user.getFullName() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getPhoneNumber() %></td>
                <td><%= user.getCccd() %></td>
                <td><%= user.getRole() %></td>
                <td><%= user.getCreatedAt() %></td>
                <td class="text-center">
                    <button class="btn btn-success btn-sm"
                            data-toggle="modal"
                            data-target="#editModal"
                            onclick="fillEditForm('<%= user.getUserId() %>', '<%= user.getFullName() %>', '<%= user.getEmail() %>', '<%= user.getPhoneNumber() %>', '<%= user.getCccd() %>', '<%= user.getRole() %>')">
                        Sửa
                    </button>
                    <a href="delete-user?id=<%= user.getUserId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa?')">Xóa</a>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Modal Thêm -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <form action="add-user" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm tài khoản</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="fullName">Họ tên</label>
                    <input name="fullName" id="fullName" class="form-control" placeholder="Nhập họ tên" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input name="email" id="email" class="form-control" placeholder="Nhập email" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Số điện thoại</label>
                    <input name="phoneNumber" id="phoneNumber" class="form-control" placeholder="Nhập SĐT" required>
                </div>
                <div class="form-group">
                    <label for="cccd">CCCD</label>
                    <input name="cccd" id="cccd" class="form-control" placeholder="Nhập CCCD" required>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input name="password" id="password" type="password" class="form-control" placeholder="Nhập mật khẩu" required>
                </div>
                <div class="form-group">
                    <label for="role">Quyền</label>
                    <select name="role" id="role" class="form-control" required>
                        <option value="User">User</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Thêm</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
            </div>
        </form>
    </div>
</div>


<!-- Modal Sửa -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <form action="edit-user" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Sửa tài khoản</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="userId" id="editUserId">

                <div class="form-group">
                    <label for="editFullName">Họ tên</label>
                    <input name="fullName" id="editFullName" class="form-control" placeholder="Nhập họ tên" required>
                </div>

                <div class="form-group">
                    <label for="editEmail">Email</label>
                    <input name="email" id="editEmail" class="form-control" placeholder="Nhập email" required>
                </div>

                <div class="form-group">
                    <label for="editPhoneNumber">Số điện thoại</label>
                    <input name="phoneNumber" id="editPhoneNumber" class="form-control" placeholder="Nhập SĐT" required>
                </div>

                <div class="form-group">
                    <label for="editCCCD">CCCD</label>
                    <input name="cccd" id="editCCCD" class="form-control" placeholder="Nhập CCCD" required>
                </div>

                <div class="form-group">
                    <label for="editRole">Vai trò</label>
                    <select name="role" id="editRole" class="form-control" required>
                        <option value="User">User</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
            </div>

            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
            </div>
        </form>
    </div>
</div>


<script>
    function fillEditForm(id, name, email, phone, cccd, role) {
        document.getElementById('editUserId').value = id;
        document.getElementById('editFullName').value = name;
        document.getElementById('editEmail').value = email;
        document.getElementById('editPhoneNumber').value = phone;
        document.getElementById('editCCCD').value = cccd;
        document.getElementById('editRole').value = role;
    }
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</body>
</html>

