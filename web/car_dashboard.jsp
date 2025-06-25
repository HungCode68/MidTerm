<%-- 
    Document   : car_dashboard
    Created on : Jun 24, 2025, 11:11:07 AM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Car" %>
<%
    List<Car> carList = (List<Car>) request.getAttribute("carList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý xe</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center mb-4">Quản lý danh sách xe</h2>
    
    <% String successMessage = (String) request.getAttribute("successMessage");
   String errorMessage = (String) request.getAttribute("errorMessage");
%>

<% if (successMessage != null) { %>
    <div class="alert alert-success"><%= successMessage %></div>
<% } %>

<% if (errorMessage != null) { %>
    <div class="alert alert-danger"><%= errorMessage %></div>
<% } %>


    <!-- Nút thêm -->
    <button class="btn btn-primary mb-3" data-toggle="modal" data-target="#addModal">+ Thêm xe</button>

    <!-- Bảng xe -->
    <table class="table table-bordered table-striped">
        <thead class="thead-dark text-center">
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
                <button class="btn btn-success btn-sm"
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
                <input name="modelName" class="form-control mb-2" placeholder="Tên xe" required>
                <input name="price" type="number" step="0.01" class="form-control mb-2" placeholder="Giá" required>
                <input name="imageUrl" class="form-control mb-2" placeholder="URL Hình ảnh" required>
                <textarea name="description" class="form-control mb-2" placeholder="Mô tả" required></textarea>
                <textarea name="specifications" class="form-control" placeholder="Thông số kỹ thuật" required></textarea>
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
                <input name="modelName" id="editModelName" class="form-control mb-2" placeholder="Tên xe" required>
                <input name="price" type="number" step="0.01" id="editPrice" class="form-control mb-2" placeholder="Giá" required>
                <input name="imageUrl" id="editImageUrl" class="form-control mb-2" placeholder="URL Hình ảnh" required>
                <textarea name="description" id="editDescription" class="form-control mb-2" placeholder="Mô tả" required></textarea>
                <textarea name="specifications" id="editSpecifications" class="form-control" placeholder="Thông số kỹ thuật" required></textarea>
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
