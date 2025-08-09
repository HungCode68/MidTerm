<%-- 
    Document   : car_dashboard
    Created on : Jun 24, 2025, 11:11:07 AM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Car" %>
<%@ page import="model.User" %>
<%
    List<Car> carList = (List<Car>) request.getAttribute("carList");
    User currentUser = (User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý xe</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


</head>
<body>
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

    
<div >
    <h2 class="text-center mb-4">Quản lý danh sách xe</h2>
    
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

    <!-- Nút thêm -->
    <button class="btn btn-primary mb-3" data-toggle="modal" data-target="#addModal">+ Thêm xe</button>

    <!-- Bảng xe -->
    <table class="table table-bordered table-striped">
        <thead class="bg-white text-dark text-center">
        <tr>
            <th>STT</th>
            <th>Tên xe</th>
            <th>Giá</th>
            <th>Hình ảnh</th>
            <th>Mô tả</th>
            <th>Thông số kỹ thuật</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <%
            int index = 1;
            for (Car car : carList) {
        %>
        <tr>
            <td class="text-center"><%= index++ %></td>
            <td><%= car.getModelName() %></td>
            <td><%= car.getPrice() %></td>
            <td><img src="<%= car.getImageUrl() %>" alt="Car Image" width="100"/></td>
            <td><%= car.getDescription() %></td>
            <td><%= car.getSpecifications() %></td>
            <td class="text-center">
                <button class="btn btn-info btn-sm text-white"
                        data-toggle="modal"
                        data-target="#editModal"
                        onclick="fillEditForm('<%= car.getCarId() %>', '<%= car.getModelName() %>', '<%= car.getPrice() %>', '<%= car.getImageUrl() %>', '<%= car.getDescription() %>', '<%= car.getSpecifications() %>')">
                    Sửa
                </button>
                <a href="delete-car?id=<%= car.getCarId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa xe này?')">Xóa</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Modal Thêm -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form action="add-car" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm xe mới</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="modelName">Tên xe</label>
                    <input name="modelName" id="modelName" class="form-control" placeholder="Nhập tên xe" required>
                </div>
                <div class="form-group">
                    <label for="price">Giá</label>
                    <input name="price" id="price" type="number" step="0.01" class="form-control" placeholder="Nhập giá" required>
                </div>
                <div class="form-group">
                    <label for="imageUrl">URL Hình ảnh</label>
                    <input name="imageUrl" id="imageUrl" class="form-control" placeholder="Nhập URL hình ảnh" required>
                </div>
                <div class="form-group">
                    <label for="description">Mô tả</label>
                    <textarea name="description" id="description" class="form-control" placeholder="Nhập mô tả" required></textarea>
                </div>
                <div class="form-group">
                    <label for="specifications">Thông số kỹ thuật</label>
                    <textarea name="specifications" id="specifications" class="form-control" placeholder="Nhập thông số kỹ thuật" required></textarea>
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
<div class="modal fade" id="editModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form action="edit-car" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Sửa thông tin xe</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="carId" id="editCarId">
                <div class="form-group">
                    <label for="editModelName">Tên xe</label>
                    <input name="modelName" id="editModelName" class="form-control" placeholder="Nhập tên xe" required>
                </div>
                <div class="form-group">
                    <label for="editPrice">Giá</label>
                    <input name="price" type="number" step="0.01" id="editPrice" class="form-control" placeholder="Nhập giá" required>
                </div>
                <div class="form-group">
                    <label for="editImageUrl">URL Hình ảnh</label>
                    <input name="imageUrl" id="editImageUrl" class="form-control" placeholder="Nhập URL hình ảnh" required>
                </div>
                <div class="form-group">
                    <label for="editDescription">Mô tả</label>
                    <textarea name="description" id="editDescription" class="form-control" placeholder="Nhập mô tả" required></textarea>
                </div>
                <div class="form-group">
                    <label for="editSpecifications">Thông số kỹ thuật</label>
                    <textarea name="specifications" id="editSpecifications" class="form-control" placeholder="Nhập thông số kỹ thuật" required></textarea>
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
    function fillEditForm(id, model, price, imgUrl, desc, spec) {
        document.getElementById('editCarId').value = id;
        document.getElementById('editModelName').value = model;
        document.getElementById('editPrice').value = price;
        document.getElementById('editImageUrl').value = imgUrl;
        document.getElementById('editDescription').value = desc;
        document.getElementById('editSpecifications').value = spec;
    }
    
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
