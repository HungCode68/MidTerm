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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý tài khoản</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="#">Trang quản lý</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item <%= request.getServletPath().equals("/dashboard") ? "active" : "" %>">
                <a class="nav-link" href="dashboard">Quản lý tài khoản</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="cars">Quản lý xe</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="deposits">Quản lý đặt cọc</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="maintenance-booking">Lịch bảo dưỡng</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="test-drive-booking">Lịch lái thử</a>
            </li>
        </ul>
    </div>
</nav>

    
     <%
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    if (success != null) {
%>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= success %>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
<%
        session.removeAttribute("success");
    }
    if (error != null) {
%>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= error %>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
<%
        session.removeAttribute("error");
    }
%>

    
<div class="container mt-5">
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
                <input name="fullName" class="form-control mb-2" placeholder="Họ tên" required>
                <input name="email" class="form-control mb-2" placeholder="Email" required>
                <input name="phoneNumber" class="form-control mb-2" placeholder="SĐT" required>
                <input name="cccd" class="form-control mb-2" placeholder="CCCD" required>
                <input name="password" type="password" class="form-control mb-2" placeholder="Mật khẩu" required>
                <select name="role" class="form-control" required>
                    <option value="User">User</option>
                    <option value="Admin">Admin</option>
                </select>
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
                <input name="fullName" id="editFullName" class="form-control mb-2" placeholder="Họ tên" required>
                <input name="email" id="editEmail" class="form-control mb-2" placeholder="Email" required>
                <input name="phoneNumber" id="editPhoneNumber" class="form-control mb-2" placeholder="SĐT" required>
                <input name="cccd" id="editCCCD" class="form-control mb-2" placeholder="CCCD" required>
                <select name="role" id="editRole" class="form-control" required>
                    <option value="User">User</option>
                    <option value="Admin">Admin</option>
                </select>
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
</body>
</html>

