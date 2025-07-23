<%-- 
    Document   : showroom_management
    Created on : Jul 15, 2025, 8:14:00 AM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Showroom" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    User currentUser = (User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Showroom</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
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
    
    <h3 class="mb-4">Quản lý Showroom</h3>
   
    <!-- Nút thêm -->
    <button class="btn btn-primary mb-3" data-toggle="modal" data-target="#addModal">+ Thêm showroom</button>

    <!-- Bảng danh sách showroom -->
    <table class="table table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Tên showroom</th>
            <th>Địa chỉ</th>
            <th>Tỉnh</th>
            <th>Quận/Huyện</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Showroom> showroomList = (List<Showroom>) request.getAttribute("showroomList");
            if (showroomList != null) {
                for (Showroom s : showroomList) {
        %>
        <tr>
            <td><%= s.getShowroomId() %></td>
            <td><%= s.getName() %></td>
            <td><%= s.getAddress() %></td>
            <td><%= s.getProvince() %></td>
            <td><%= s.getDistrict() %></td>
            <td>
                <!-- Nút sửa -->
                <button class="btn btn-sm btn-warning"
                        onclick="showEditModal('<%= s.getShowroomId() %>', '<%= s.getName() %>', '<%= s.getAddress() %>',
                            '<%= s.getProvince() %>', '<%= s.getDistrict() %>')">
                    Sửa
                </button>
                <!-- Nút xoá -->
                <a href="delete-showroom?id=<%= s.getShowroomId() %>"
                   onclick="return confirm('Xác nhận xoá showroom này?')"
                   class="btn btn-sm btn-danger">Xoá</a>
            </td>
        </tr>
        <% }} %>
        </tbody>
    </table>
</div>

<!-- Modal Thêm showroom -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <form method="post" action="add-showroom" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm Showroom</h5>
            </div>
            <div class="modal-body">
                <label>Tên showroom:</label>
                <input type="text" name="name" class="form-control mb-2" required/>
                <label>Địa chỉ:</label>
                <input type="text" name="address" class="form-control mb-2" required/>
                <label>Tỉnh:</label>
                <input type="text" name="province" class="form-control mb-2" required/>
                <label>Quận/Huyện:</label>
                <input type="text" name="district" class="form-control mb-2" required/>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" type="submit">Thêm</button>
                <button class="btn btn-secondary" data-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Sửa showroom -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <form method="post" action="edit-showroom" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Sửa Showroom</h5>
            </div>
            <div class="modal-body">
                <input type="hidden" name="showroomId" id="editId"/>
                <label>Tên showroom:</label>
                <input type="text" name="name" id="editName" class="form-control mb-2" required/>
                <label>Địa chỉ:</label>
                <input type="text" name="address" id="editAddress" class="form-control mb-2" required/>
                <label>Tỉnh:</label>
                <input type="text" name="province" id="editProvince" class="form-control mb-2" required/>
                <label>Quận/Huyện:</label>
                <input type="text" name="district" id="editDistrict" class="form-control mb-2" required/>
            </div>
            <div class="modal-footer">
                <button class="btn btn-warning" type="submit">Cập nhật</button>
                <button class="btn btn-secondary" data-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>

<!-- Script để load dữ liệu vào modal sửa -->
<script>
    function showEditModal(id, name, address, province, district) {
        $('#editId').val(id);
        $('#editName').val(name);
        $('#editAddress').val(address);
        $('#editProvince').val(province);
        $('#editDistrict').val(district);
        $('#editModal').modal('show');
    }
    
     <% if (success != null) { %>
    Swal.fire({
        icon: 'success',
        title: 'Thành công',
        text: '<%= success %>',
        confirmButtonColor: '#3085d6'
    });
    <% session.removeAttribute("success"); } %>

    <% if (error != null) { %>
    Swal.fire({
        icon: 'error',
        title: 'Lỗi',
        text: '<%= error %>',
        confirmButtonColor: '#d33'
    });
    <% session.removeAttribute("error"); } %>
</script>

</body>
</html>

