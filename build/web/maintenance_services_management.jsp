<%-- 
    Document   : maintenance_services_management
    Created on : Jul 12, 2025, 1:26:26 PM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.MaintenanceService" %>
<%@ page import="model.User" %>
<% String message = (String) request.getAttribute("message");
   String error = (String) request.getAttribute("error");
   if (session.getAttribute("message") != null) {
       message = (String) session.getAttribute("message");
       session.removeAttribute("message");
   }
     User currentUser = (User) session.getAttribute("currentUser");
%>
<html>
    <head>
        <title>Quản lý dịch vụ bảo dưỡng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
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


        <h2>Danh sách dịch vụ bảo dưỡng</h2>

        <form method="get" action="dashboard-maintenance-services" class="mb-3 d-flex">
            <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm theo tên dịch vụ" value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
            <button class="btn btn-primary" type="submit">Lọc</button>
        </form>


        <!-- Nút Thêm -->
        <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addModal">
            + Thêm dịch vụ
        </button>

        <!-- Bảng -->
        <table class="table table-bordered table-striped">
            <thead class="bg-white text-dark text-center">
                <tr>
                    <th>ID</th>
                    <th>Tên dịch vụ</th>
                    <th>Mô tả</th>
                    <th>Giá</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<MaintenanceService> services = (List<MaintenanceService>) request.getAttribute("services");
                    if (services != null) {
                        for (MaintenanceService service : services) {
                %>
                <tr>
                    <td><%= service.getServiceId() %></td>
                    <td><%= service.getServiceName() %></td>
                    <td><%= service.getDescription() %></td>
                    <td><%= service.getPrice() %></td>
                    <td>
                        <a href="edit-maintenance-service?id=<%= service.getServiceId() %>" class="btn btn-info btn-sm text-white">Sửa</a>
                        <a href="delete-maintenance-service?id=<%= service.getServiceId() %>" class="btn btn-danger btn-sm"
                           onclick="return confirm('Bạn có chắc muốn xoá?')">Xoá</a>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>

       <!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="add-maintenance-service" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addModalLabel">Add Service</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Service Name:</label>
                        <input type="text" name="serviceName" class="form-control" placeholder="Enter service name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description:</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Enter description"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price:</label>
                        <input type="number" name="price" class="form-control" step="1000" placeholder="Enter price" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Save</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </form>
    </div>
</div>


        <!-- Modal Sửa -->
        <%
     MaintenanceService editService = (MaintenanceService) request.getAttribute("editService");
     boolean showEditModal = editService != null;
     if (showEditModal) {
        %>
        <!-- Modal Sửa -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form action="edit-maintenance-service" method="post">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel">Sửa dịch vụ</h5>
                            <a href="dashboard-maintenance-services" class="btn-close" aria-label="Close"></a>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="serviceId" value="<%= editService.getServiceId() %>">
                            <div class="mb-3">
                                <label class="form-label">Tên dịch vụ:</label>
                                <input type="text" name="serviceName" value="<%= editService.getServiceName() %>" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả:</label>
                                <textarea name="description" class="form-control" rows="3"><%= editService.getDescription() %></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá:</label>
                                <input type="number" name="price" value="<%= editService.getPrice() %>" class="form-control" step="1000" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                            <a href="dashboard-maintenance-services" class="btn btn-secondary">Huỷ</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <%
            }
        %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            <% if (showEditModal) { %>
                               const editModal = new bootstrap.Modal(document.getElementById('editModal'));
                               window.onload = function () {
                                   editModal.show();
                               };
            <% } %>

            <%
     if (message != null) {
         // Thay thế các ký tự đặc biệt để tránh lỗi JavaScript
         String escapedMessage = message.replace("'", "\\'");
            %>
                               Swal.fire({
                                   icon: 'success',
                                   title: 'Thành công!',
                                   text: '<%= escapedMessage %>',
                                   timer: 2500,
                                   showConfirmButton: false
                               });
            <% } else if (error != null) {
                // Thay thế các ký tự đặc biệt cho thông báo lỗi
                String escapedError = error.replace("'", "\\'");
            %>
                               Swal.fire({
                                   icon: 'error',
                                   title: 'Lỗi!',
                                   text: '<%= escapedError %>',
                                   confirmButtonText: 'OK'
                               });
            <% } %>
        </script>


    </body>
</html>
