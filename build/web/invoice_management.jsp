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
        <title>Service Invoice Management</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

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
            <h3 class="mb-4">Service Invoice Management</h3>

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
                <thead class="bg-white text-dark text-center">
                    <tr>
                        <th>ID</th>
                        <th>User ID</th>
                        <th>Booking ID</th>
                        <th>Full Name</th>
                        <th>Phone Number</th>
                        <th>Total Amount</th>
                        <th>Payment Date</th>
                        <th>Status</th>
                        <th>Actions</th>
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
                        <td><%= i.getServiceName() %></td>
                        <td><%= i.getFullName()  %></td>
                        <td><%= i.getPhoneNumber()  %></td>
                        <td><%= i.getTotalAmount() %></td>
                        <td><%= sdf.format(i.getPaymentDate()) %></td>
                        <td><%= i.getStatus() %></td>
                        <td>
                            <button class="btn btn-info btn-sm text-white"
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

        <!-- Add Invoice Modal -->
        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog">
                <form method="post" action="add-invoice" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add Invoice</h5>
                    </div>
                    <div class="modal-body">
                        <label>User:</label>
                        <select name="userId" id="userSelect" class="form-control mb-2" onchange="toggleGuestFields()">
                            <option value="">No account</option>
                            <% if (users != null) {
                                for (User u : users) {
                            %>
                            <option value="<%= u.getUserId() %>">
                                <%= u.getUserId() %> - <%= u.getFullName() %> - <%= u.getPhoneNumber() %>
                            </option>
                            <% }} %>
                        </select>

                        <div id="guestFields">
                            <label>Full Name:</label>
                            <input type="text" name="fullName" class="form-control mb-2" placeholder="Enter full name" />

                            <label>Phone Number:</label>
                            <input type="text" name="phoneNumber" class="form-control mb-2" placeholder="Enter phone number" />

                            <label>Select Services:</label>
                            <select name="serviceIds" class="form-control mb-2">
                                <option value="">-- Chọn dịch vụ --</option>
                                <% 
                                    List<MaintenanceService> services = (List<MaintenanceService>) request.getAttribute("services");
                                    if (services != null) {
                                        for (MaintenanceService service : services) { 
                                %>
                                <option value="<%= service.getServiceId() %>">
                                    <%= service.getServiceName() %>
                                </option>
                                <% 
                                        }
                                    } 
                                %>
                            </select>

                        </div>

                        <div id="bookingField" style="display: none;">
                            <label>Booking:</label>
                            <select name="bookingId" class="form-control mb-2">
                                <option value="">-- Chọn booking --</option>
                                <!-- Sẽ được điền bằng JS -->
                            </select>
                        </div>


                        <label>Total Amount:</label>
                        <input type="number" name="totalAmount" step="0.01" class="form-control mb-2" required placeholder="Enter total amount" />

                        <label>Payment Date:</label>
                        <input type="date" name="paymentDate" class="form-control mb-2" required />

                        <label>Status:</label>
                        <select name="status" class="form-control mb-2">
                            <option value="completed">Paid</option>
                            <option value="unpaid">Unpaid</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Add</button>
                        <button class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </form>
            </div>
        </div>



        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog">
                <form method="post" action="edit-invoice" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Invoice</h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="invoiceId" id="editId"/>

                        <div id="editUserSelectWrapper">
                            <label>User:</label>
                            <select name="userId" id="editUserId" class="form-control mb-2" onchange="toggleEditFields()">
                                <option value="">No Account</option>
                                <% if (users != null) {
                            for (User u : users) { %>
                                <option value="<%= u.getUserId() %>">
                                    <%= u.getUserId() %> - <%= u.getFullName() %>
                                </option>
                                <% }} %>
                            </select>
                        </div>

                        <div id="editGuestFields">
                            <label>Full Name:</label>
                            <input type="text" name="fullName" id="editFullName" class="form-control mb-2"/>
                            <label>Phone Number:</label>
                            <input type="text" name="phoneNumber" id="editPhoneNumber" class="form-control mb-2"/>

                            <label>Service:</label>
                            <select name="serviceId" id="editServiceId" class="form-control mb-2">
                                <% if (services != null) {
                           for (MaintenanceService s : services) { %>
                                <option value="<%= s.getServiceId() %>"><%= s.getServiceName() %></option>
                                <% }} %>
                            </select>
                        </div>

                        <div id="editBookingField" style="display: none;">
                            <label>Booking:</label>
                            <select name="bookingId" class="form-control mb-2">
                                <option value="">-- Select a booking --</option>
                            </select>
                        </div>

                        <label>Total Amount:</label>
                        <input type="number" name="totalAmount" step="0.01" id="editTotal" class="form-control mb-2" required/>

                        <label>Payment Date:</label>
                        <input type="date" name="paymentDate" id="editDate" class="form-control mb-2" required/>

                        <label>Status:</label>
                        <select name="status" id="editStatus" class="form-control mb-2">
                            <option value="completed">Paid</option>
                            <option value="unpaid">Unpaid</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-warning" type="submit">Update</button>
                        <button class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </form>
            </div>
        </div>


        <!-- Script Sửa -->
        <script>
            const allBookings = [
            <%
                List<model.MaintenanceBooking> allBookings = (List<model.MaintenanceBooking>) request.getAttribute("allBookings");
                if (allBookings != null && !allBookings.isEmpty()) {
                    for (int i = 0; i < allBookings.size(); i++) {
                        model.MaintenanceBooking booking = allBookings.get(i);
            %>
            {
            bookingId: <%= booking.getBookingId() %>,
                    userId: <%= booking.getUserId() %>,
                    serviceName: "<%= booking.getServiceName() %>",
                    scheduledTime: "<%= booking.getScheduledTime() %>"
            }<%= (i < allBookings.size() - 1) ? "," : "" %>
            <%
                    }
                }
            %>
            ];

            document.addEventListener('DOMContentLoaded', function () {
                // Gọi hàm khi trang web tải xong để thiết lập trạng thái ban đầu
                toggleGuestFields();
            });

            function toggleGuestFields() {
                var userSelect = document.getElementById("userSelect");
                var guestFields = document.getElementById("guestFields");
                var bookingField = document.getElementById("bookingField");

                const bookingSelect = document.querySelector("select[name='bookingId']");

                if (userSelect.value === "") {
                    // Nếu không có người dùng nào được chọn, hiển thị trường khách và ẩn trường booking
                    guestFields.style.display = "block";
                    bookingField.style.display = "none";
                    bookingSelect.innerHTML = "<option value=''>-- Chọn booking --</option>";
                } else {
                    // Nếu có người dùng, ẩn trường khách và hiển thị trường booking
                    guestFields.style.display = "none";
                    bookingField.style.display = "block";

                    // Lọc danh sách booking dựa trên userId đã chọn
                    const selectedUserId = parseInt(userSelect.value);
                    const filteredBookings = allBookings.filter(booking => booking.userId === selectedUserId);

                    // Xóa các tùy chọn cũ
                    bookingSelect.innerHTML = "<option value=''>-- Chọn booking --</option>";

                    if (filteredBookings.length === 0) {
                        const option = document.createElement("option");
                        option.text = "Không có booking nào";
                        option.disabled = true;
                        option.selected = true;
                        bookingSelect.appendChild(option);
                    } else {
                        filteredBookings.forEach(booking => {
                            const option = document.createElement("option");
                            option.value = booking.bookingId;
                            option.text = booking.bookingId + " - " + booking.serviceName + " - " + booking.scheduledTime;
                            bookingSelect.appendChild(option);
                        });
                    }
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
                const bookingSelect = document.querySelector("#editBookingField select[name='bookingId']");

                // Xóa các tùy chọn cũ trước khi xử lý
                bookingSelect.innerHTML = '<option value="">-- Chọn booking --</option>';

                if (userId === "") {
                    guestFields.style.display = "block";
                    bookingField.style.display = "none";
                } else {
                    guestFields.style.display = "none";
                    bookingField.style.display = "block";

                    const selectedUserId = parseInt(userId);

                    // Lọc danh sách booking, đảm bảo userId là một số hợp lệ
                    const userBookings = allBookings.filter(booking => {
                        return booking.userId != null && parseInt(booking.userId) === selectedUserId;
                    });

                    if (userBookings.length === 0) {
                        const option = document.createElement("option");
                        option.text = "Không có booking nào";
                        option.disabled = true;
                        option.selected = true;
                        bookingSelect.appendChild(option);
                    } else {
                        userBookings.forEach(booking => {
                            const option = document.createElement("option");
                            option.value = booking.bookingId;
                            // Đảm bảo các thuộc tính này tồn tại trước khi sử dụng
                            const serviceName = booking.serviceName || 'N/A';
                            const scheduledTime = booking.scheduledTime || 'N/A';

                            option.text = booking.bookingId + " - " + booking.serviceName + " - " + booking.scheduledTime;
                            bookingSelect.appendChild(option);
                        });
                    }
                }
            }

            function showEditModal(id, userId, bookingId, total, date, status, fullName, phoneNumber, serviceId) {
                $('#editId').val(id);
                $('#editTotal').val(total);
                $('#editDate').val(date);
                $('#editStatus').val(status);

                const editUserIdElement = document.getElementById("editUserId");
                editUserIdElement.value = userId || "";

                // Set values for guest fields if no userId exists, otherwise clear them
                if (!userId || userId === "") {
                    $('#editFullName').val(fullName || "");
                    $('#editPhoneNumber').val(phoneNumber || "");
                    // THIS IS THE NEW LINE: explicitly set the value of the service dropdown
                    $('#editServiceId').val(serviceId || "");
                } else {
                    $('#editFullName').val("");
                    $('#editPhoneNumber').val("");
                    $('#editServiceId').val("");
                }

                // Luôn luôn gọi toggleEditFields để cập nhật modal dựa trên userId đã set
                toggleEditFields();

                // Sau khi dropdown đã được populate, hãy chọn bookingId chính xác
                if (bookingId) {
                    document.querySelector("#editBookingField select[name='bookingId']").value = bookingId;
                }

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

