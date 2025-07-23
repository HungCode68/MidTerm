<%-- 
    Document   : invoice_management
    Created on : Jul 15, 2025, 9:02:21 AM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ServiceInvoice" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="model.User" %>
<%@ page import="model.MaintenanceService" %>
<%@ page import="model.MaintenanceBooking" %>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
     List<User> users = (List<User>) request.getAttribute("users");
      User currentUser = (User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Hóa đơn Dịch vụ</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            <h3 class="mb-4">Quản lý Hóa đơn Dịch vụ</h3>

            <!-- Thông báo -->
            <%
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
                session.removeAttribute("message");
                session.removeAttribute("error");
            %>

            <!-- Nút thêm -->
            <button class="btn btn-primary mb-3" data-toggle="modal" data-target="#addModal">+ Thêm hóa đơn</button>

            <!-- Form lọc -->
            <form method="get" action="filter-invoice" class="form-inline mb-4">
                <input type="text" name="phone" class="form-control mr-2" placeholder="SĐT người dùng"
                       value="<%= request.getAttribute("filterPhone") != null ? request.getAttribute("filterPhone") : "" %>" />
                <input type="date" name="date" class="form-control mr-2"
                       value="<%= request.getAttribute("filterDate") != null ? request.getAttribute("filterDate") : "" %>" />
                <button class="btn btn-secondary" type="submit">Lọc</button>
                 <a href="dashboard-invoices" class="btn btn-secondary ml-2">Xoá bộ lọc</a>
            </form>

            <!-- Bảng hóa đơn -->
            <table class="table table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>User ID</th>
                        <th>Booking ID</th>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Tổng tiền</th>
                        <th>Ngày thanh toán</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    
                    <%
                        List<ServiceInvoice> invoiceList = (List<ServiceInvoice>) request.getAttribute("invoiceList");
                        if (invoiceList != null) {
                            for (ServiceInvoice i : invoiceList) {
                    %>
                    <tr>
                        <td><%= i.getInvoiceId() %></td>
                        <td><%= i.getUserId() != null ? i.getUserId() : "Khách" %></td>
                        <td><%= i.getBookingId() %></td>
                        <td><%= i.getFullName() != null ? i.getFullName() : "-" %></td>
                        <td><%= i.getPhoneNumber() != null ? i.getPhoneNumber() : "-" %></td>
                        <td><%= i.getTotalAmount() %></td>
                        <td><%= sdf.format(i.getPaymentDate()) %></td>
                        <td><%= i.getStatus() %></td>
                        <td>
                           <button class="btn btn-sm btn-warning"
    onclick="showEditModal(
        <%= i.getInvoiceId() %>,
       '<%= i.getUserId() != null ? i.getUserId() : "" %>',
         <%= i.getBookingId() != null ? i.getBookingId() : 0 %>,
        <%= i.getTotalAmount() %>,
        '<%= sdf.format(i.getPaymentDate()) %>',
        '<%= i.getStatus() %>',
        '<%= i.getFullName() %>',
        '<%= i.getPhoneNumber() %>',
        <%= i.getServiceId() %>
    )">
    Sửa
</button>

                            <a href="delete-invoice?id=<%= i.getInvoiceId() %>"
                               onclick="return confirm('Bạn có chắc chắn xoá?')"
                               class="btn btn-sm btn-danger">Xoá</a>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>
        </div>

        <!-- Modal Thêm -->
        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog">
                <form method="post" action="add-invoice" class="modal-content">
                    <div class="modal-header"><h5 class="modal-title">Thêm hóa đơn</h5></div>
                    <div class="modal-body">
                        <label>Người dùng:</label>
                        <select name="userId" id="userSelect" class="form-control mb-2" onchange="toggleGuestFields()">
                            <option value="">Không có tài khoản</option>
                            <% if (users != null) {
                                for (User u : users) {
                            %>
                            <option value="<%= u.getUserId() %>">
                                <%= u.getUserId() %> - <%= u.getFullName() %> - <%= u.getPhoneNumber() %>
                            </option>
                            <% }} %>
                        </select>

                        <div id="guestFields">
                            <label>Họ tên:</label>
                            <input type="text" name="fullName" class="form-control mb-2"/>
                            <label>Số điện thoại:</label>
                            <input type="text" name="phoneNumber" class="form-control mb-2"/>
                             <label>Chọn dịch vụ:</label>
    <select name="serviceIds" class="form-control mb-2" multiple>
        <%  List<MaintenanceService> services = (List<MaintenanceService>) request.getAttribute("services");
            if (services != null) {
                        for (MaintenanceService service : services) { %>
            <option value="<%= service.getServiceId() %>"><%= service.getServiceName() %></option>
        <% }} %>
    </select>
                        </div>

                        <div id="bookingField"  style="display: none;">
    <label>Booking:</label>
    <select name="bookingId"  class="form-control mb-2">
        <% List<MaintenanceBooking> bookings = (List<MaintenanceBooking>) request.getAttribute("bookings");
           if (bookings != null) {
               for (MaintenanceBooking b : bookings) { %>
            <option value="<%= b.getBookingId() %>"><%= b.getBookingId() %> - <%= b.getServiceName() %></option>
        <% }} %>
    </select>
</div>
                        <label>Tổng tiền:</label>
                        <input type="number" name="totalAmount" step="0.01" class="form-control mb-2" required/>
                        <label>Ngày thanh toán:</label>
                        <input type="date" name="paymentDate" class="form-control mb-2" required/>
                        <label>Trạng thái:</label>
                        <select name="status" class="form-control mb-2">
    <option value="completed">Đã thanh toán</option>
    <option value="unpaid">Chưa thanh toán</option>
</select>

                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Thêm</button>
                        <button class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                    </div>
                </form>
            </div>
        </div>


      <!-- Modal Sửa -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="edit-invoice" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Sửa hóa đơn</h5>
            </div>
            <div class="modal-body">
                <input type="hidden" name="invoiceId" id="editId"/>

                <!-- Select Người dùng (ẩn nếu là khách) -->
                <div id="editUserSelectWrapper">
                    <label>Người dùng:</label>
                    <select name="userId" id="editUserId" class="form-control mb-2" onchange="toggleEditFields()">
                        <option value="">Không có tài khoản</option>
                        <% if (users != null) {
                            for (User u : users) { %>
                            <option value="<%= u.getUserId() %>">
                                <%= u.getUserId() %> - <%= u.getFullName() %>
                            </option>
                        <% }} %>
                    </select>
                </div>

                <!-- Trường cho khách lẻ -->
                <div id="editGuestFields">
                    <label>Họ tên:</label>
                    <input type="text" name="fullName" id="editFullName" class="form-control mb-2"/>
                    <label>SĐT:</label>
                    <input type="text" name="phoneNumber" id="editPhoneNumber" class="form-control mb-2"/>

                 <label>Dịch vụ:</label>
<select name="serviceId" id="editServiceId" class="form-control mb-2">
    <% if (services != null) {
           for (MaintenanceService s : services) { %>
        <option value="<%= s.getServiceId() %>"><%= s.getServiceName() %></option>
    <% }} %>
</select>

                </div>

                <!-- Trường cho người dùng có tài khoản -->
                <div id="editBookingField">
                    <label>Booking ID:</label>
                    <input type="number" name="bookingId" id="editBookingId" class="form-control mb-2"/>
                </div>

                <label>Tổng tiền:</label>
                <input type="number" name="totalAmount" step="0.01" id="editTotal" class="form-control mb-2" required/>

                <label>Ngày thanh toán:</label>
                <input type="date" name="paymentDate" id="editDate" class="form-control mb-2" required/>

                <label>Trạng thái:</label>
                <select name="status" id="editStatus" class="form-control mb-2">
                    <option value="completed">Đã thanh toán</option>
                    <option value="unpaid">Chưa thanh toán</option>
                </select>
            </div>
            <div class="modal-footer">
                <button class="btn btn-warning" type="submit">Cập nhật</button>
                <button class="btn btn-secondary" data-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>




        <!-- Script Sửa -->
        <script>
            function toggleGuestFields() {
                const selectedValue = document.getElementById("userSelect").value;
                const guestFields = document.getElementById("guestFields");
                 const bookingField = document.getElementById("bookingField");
                if (selectedValue === "") {
                    guestFields.style.display = "block";
                     bookingField.style.display = "none";
                } else {
                    guestFields.style.display = "none";
                     bookingField.style.display = "block";
                }
            }

            // Khi tải lại modal
            $(document).ready(function () {
                toggleGuestFields();
            });
            
            function toggleEditFields() {
        const userId = document.getElementById("editUserId").value;
        const guestFields = document.getElementById("editGuestFields");
        const bookingField = document.getElementById("editBookingField");

        if (userId === "") {
            guestFields.style.display = "block";
            bookingField.style.display = "none";
        } else {
            guestFields.style.display = "none";
            bookingField.style.display = "block";
        }
    }

    function showEditModal(id, userId, bookingId, total, date, status, fullName, phoneNumber, serviceId) {
        $('#editId').val(id);
        $('#editUserId').val(userId || "");

        // Set giá trị userId trước khi gọi toggle
        toggleEditFields();

        $('#editBookingId').val(bookingId || "");
        $('#editTotal').val(total);
        $('#editDate').val(date);
        $('#editStatus').val(status);

        $('#editFullName').val(fullName || "");
        $('#editPhoneNumber').val(phoneNumber || "");
        $('#editServiceId').val(serviceId || "");

        $('#editModal').modal('show');
    }
        </script>

        <!-- Script SweetAlert2 -->
        <script>
            <% if (message != null) { %>
            Swal.fire({
                icon: 'success',
                title: 'Thành công',
                text: '<%= message %>'
            });
            <% } else if (error != null) { %>
            Swal.fire({
                icon: 'error',
                title: 'Lỗi',
                text: '<%= error %>'
            });
            <% } %>
        </script>

        <!-- Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

