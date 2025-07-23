<%-- 
    Document   : profile
    Created on : Jun 9, 2025, 10:22:54 PM
    Author     : Nguyễn Hùng
--%>

<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Deposit" %>
<%@ page import="model.MaintenanceBooking" %>
<%
    User user = (User) request.getAttribute("user");
      User currentUser = (User) session.getAttribute("currentUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông Tin Cá Nhân</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f2f2f2;
                margin: 0;

            }
            .container {
                display: flex;
                max-width: 1000px;
                margin: auto;
                background-color: white;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border-radius: 10px;
                overflow: hidden;
            }
            .left-panel {
                background-color: #f9f9f9;
                width: 30%;
                padding: 20px;
                text-align: center;
                border-right: 1px solid #ddd;
            }
            .left-panel img {
                width: 80px;
                height: 80px;
                margin-bottom: 10px;
            }
            .left-panel .name {
                font-weight: bold;
                margin-bottom: 10px;
            }
            .warning {
                background-color: #fff3cd;
                color: #856404;
                padding: 10px;
                margin: 15px 0;
                border: 1px solid #ffeeba;
                border-radius: 5px;
                font-size: 14px;
            }
            .right-panel {
                width: 70%;
                padding: 20px;
            }
            .right-panel h2 {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .info-table {
                width: 100%;
                margin-top: 20px;
                font-size: 15px;
            }
            .info-table td {
                padding: 8px 0;
            }
            .info-table td:first-child {
                font-weight: bold;
                width: 180px;
            }
            .edit-link {
                font-size: 14px;
                color: #007bff;
                text-decoration: none;
            }
            .edit-link:hover {
                text-decoration: underline;
            }
            .checkbox-label {
                margin-top: 10px;
            }
            .footer {
                margin-top: 20px;
                font-size: 14px;
            }
            .store-links img {
                height: 40px;
                margin: 10px 5px;
            }

            /* Navbar */
            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px 32px;
                background-color: white;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .navbar-left {
                display: flex;
                align-items: center;
                gap: 24px;
            }

            .navbar-left img {
                height: 28px;
            }

            .navbar-left a {
                text-decoration: none;
                color: black;
                font-weight: 500;
            }

            .navbar-right {
                display: flex;
                gap: 16px;
                align-items: center;
            }

            .navbar-right a {
                text-decoration: none;
                color: white;
                font-weight: bold;
            }

            .btn-primary {
                background-color: #0057ff;
                color: white;
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                text-decoration: none;
            }

            /* Dropdown menu */
            .dropdown {
                position: relative;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: white;
                min-width: 160px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
                z-index: 1;
                top: 100%;
                left: 0;
                padding: 10px 0;
            }

            .dropdown-content a {
                color: black;
                padding: 8px 16px;
                text-decoration: none;
                display: block;
                white-space: nowrap;
            }

            .dropdown-content a:hover {
                background-color: #f0f0f0;
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }


        </style>
    </head>
    <body>
        <div class="navbar">
            <div class="navbar-left">
                <img src="https://vinfastauto.com/themes/porto/img/new-home-page/VinFast-logo.svg" alt="VinFast Logo">
                <a href="<%=contextPath%>/index.jsp">Giới thiệu</a>
                <div class="dropdown">
                    <a href="<%=contextPath%>/cars">Ô tô</a>
                    <div class="dropdown-content">
                        <a href="<%=contextPath%>/cars?model=VF%205">VF 5</a>
                        <a href="<%=contextPath%>/cars?model=VF%206">VF 6</a>
                        <a href="<%=contextPath%>/cars?model=VF%207">VF 7</a>
                        <a href="<%=contextPath%>/cars?model=VF%208">VF 8</a>
                        <a href="<%=contextPath%>/cars?model=VF%209">VF 9</a>

                    </div>
                </div>
                <div class="dropdown">
                    <a href="<%=contextPath%>/after-sales">Dịch vụ hậu mãi</a>
                    <div class="dropdown-content">
                        <a href="<%=contextPath%>/warrantyinformation.jsp">Thông tin bảo hành</a>
                        <a href="<%=contextPath%>/maintenance">Thông tin bảo dưỡng định kỳ</a>
                        <a href="<%=contextPath%>/maintenance">Thông tin dịch vụ</a>
                    </div>
                </div>
                <div class="dropdown">
                    <a href="<%=contextPath%>/charging">Pin và trạm sạc</a>
                    <div class="dropdown-content">
                        <a href="<%=contextPath%>/charging-stations">Trạm sạc ô tô điện</a>
                    </div>
                </div>
            </div>
            <div class="navbar-right">
                <% if (currentUser != null) { %>
                <!-- Nếu đã đăng nhập, hiển thị icon người và tên người dùng -->
                <div style="display: flex; align-items: center; gap: 10px;">
                    <div class="dropdown">
                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="User Icon" style="width: 30px; height: 30px; border-radius: 50%;">
                        <span>Xin chào, <%= currentUser.getFullName() %></span>
                        <div class="dropdown-content">
                            <a href="/VinfastSystem/profile">Thông tin cá nhân</a>
                            <a href="logout.jsp"">Đăng xuất</a>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <!-- Nếu chưa đăng nhập -->
                <a href="login.jsp" style="color: blue">Đăng Nhập /</a>
                <a href="register.jsp" style="color: blue">Đăng Ký</a>
                <% } %>

                <a href="register.html" class="btn-primary">ĐĂNG KÝ LÁI THỬ</a>
            </div>
        </div>


        <% if (user == null) { %>
        <h3>Không tìm thấy thông tin tài khoản. Vui lòng đăng nhập lại.</h3>
        <a href="login.jsp">Đăng nhập</a>
        <% } else { %>
        <div class="container">
            <!-- Bên trái -->
            <div class="left-panel">
                <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="User">
                <div>Xin chào,</div>
                <div class="name"><%= user.getFullName() %></div>

                <div class="warning">
                    <strong>⚠ Bạn chưa liên kết tài khoản VinClub</strong><br>
                    Hãy tải ứng dụng VinClub và liên kết tài khoản bằng Email hoặc SĐT để nhận các ưu đãi đặc quyền.<br>
                    <a href="#" style="font-size: 13px;">Xem hướng dẫn</a>
                </div>

                <div class="store-links">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" alt="Google Play">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/Sites-app_vinfast_vn-Site/-/default/dwee841349/images/after-order/icon-appstore.jpg" alt="App Store">
                </div>
            </div>

            <!-- Bên phải -->
            <div class="right-panel">
                <h2>
                    Thông tin cá nhân
                    <a href="#" class="edit-link">Chỉnh sửa thông tin</a>
                </h2>

                <table class="info-table">
                    <tr><td>Họ và tên</td><td><%= user.getFullName() %></td></tr>
                    <tr><td>Email</td><td><%= user.getEmail() %></td></tr>
                    <tr><td>Số điện thoại</td><td><%= user.getPhoneNumber() %></td></tr>
                    <tr>
                        <td>Nhận thông báo</td>
                        <td>Thông tin dịch vụ, chương trình khuyến mãi, chính sách VinFast</td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><label><input type="checkbox" checked> Email Marketing</label></td>
                    </tr>
                </table>

                <div class="footer">
                    <strong>Mật khẩu</strong> - <a href="#" class="edit-link">Đổi mật khẩu</a>
                </div>
            </div>
        </div>
        <h2 style="margin-top: 30px; color: #333;">Lịch sử đặt cọc</h2>

        <%@ page import="java.text.SimpleDateFormat" %>
        <%
            List<model.Deposit> depositHistory = (List<model.Deposit>) request.getAttribute("depositHistory");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            if (depositHistory != null && !depositHistory.isEmpty()) {
        %>
        <table style="margin-top: 15px; width: 100%; font-size: 14px; border-collapse: collapse; box-shadow: 0 0 10px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden;">
            <thead>
                <tr style="background-color: #004b8d; color: white; text-align: center;">
                    <th style="padding: 10px;">STT</th>
                    <th style="padding: 10px;">Màu ngoại thất</th>
                    <th style="padding: 10px;">Màu nội thất</th>
                    <th style="padding: 10px;">Họ tên</th>
                    <th style="padding: 10px;">SĐT</th>
                    <th style="padding: 10px;">CCCD</th>
                    <th style="padding: 10px;">Tỉnh/TP</th>
                    <th style="padding: 10px;">Showroom</th>
                    <th style="padding: 10px;">Thanh toán</th>
                    <th style="padding: 10px;">Ngày đặt</th>
                    <th style="padding: 10px;">Trạng thái</th>

                </tr>
            </thead>
            <tbody>
                <%
                    int index = 1;
                    for (model.Deposit d : depositHistory) {
                        String bgColor = (index % 2 == 0) ? "#f9f9f9" : "#ffffff";
                %>
                <tr style="background-color: <%= bgColor %>;">
                    <td style="padding: 8px; text-align: center;"><%= index++ %></td>
                    <td style="padding: 8px;"><%= d.getColorExterior() %></td>
                    <td style="padding: 8px;"><%= d.getColorInterior() %></td>
                    <td style="padding: 8px;"><%= d.getFullName() %></td>
                    <td style="padding: 8px;"><%= d.getPhoneNumber() %></td>
                    <td style="padding: 8px;"><%= d.getCccd() %></td>
                    <td style="padding: 8px;"><%= d.getProvince() %></td>
                    <td style="padding: 8px; text-align: center;"><%= d.getShowroomId() %></td>
                    <td style="padding: 8px;"><%= d.getPaymentMethod() %></td>
                    <td style="padding: 8px;"><%= sdf.format(d.getDepositDate()) %></td>
                    <td style="padding: 8px;"><%= d.getStatus() %></td>

                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p style="margin-top: 10px; font-size: 14px; color: #777;">Chưa có lịch sử đặt cọc nào.</p>
        <% } %>

        <%
            List<MaintenanceBooking> maintenanceHistory = (List<MaintenanceBooking>) request.getAttribute("maintenanceHistory");
            if (maintenanceHistory != null && !maintenanceHistory.isEmpty()) {
        %>
        <h2 style="margin-top: 40px; color: #333;">Lịch sử đặt lịch bảo dưỡng</h2>
        <table style="margin-top: 15px; width: 100%; font-size: 14px; border-collapse: collapse; box-shadow: 0 0 10px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden;">
            <thead>
                <tr style="background-color: #2d7be5; color: white; text-align: center;">
                    <th style="padding: 10px;">STT</th>
                    <th style="padding: 10px;">Mẫu xe</th>
                    <th style="padding: 10px;">Biển số</th>
                    <th style="padding: 10px;">Số Km</th>
                    <th style="padding: 10px;">Tỉnh</th>
                    <th style="padding: 10px;">Quận/Huyện</th>
                    <th style="padding: 10px;">Thời gian hẹn</th>
                    <th style="padding: 10px;">Họ tên</th>
                    <th style="padding: 10px;">SĐT</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int idx = 1;
                    for (MaintenanceBooking b : maintenanceHistory) {
                        String bgColor = (idx % 2 == 0) ? "#f9f9f9" : "#ffffff";
                %>
                <tr style="background-color: <%= bgColor %>;">
                    <td style="padding: 8px; text-align: center;"><%= idx++ %></td>
                    <td style="padding: 8px;"><%= b.getCarModel() %></td>
                    <td style="padding: 8px;"><%= b.getLicensePlate() %></td>
                    <td style="padding: 8px; text-align: center;"><%= b.getKilometer() %></td>
                    <td style="padding: 8px;"><%= b.getProvince() %></td>
                    <td style="padding: 8px;"><%= b.getDistrict() %></td>
                    <td style="padding: 8px;"><%= sdf.format(b.getScheduledTime()) %></td>
                    <td style="padding: 8px;"><%= b.getFullName() %></td>
                    <td style="padding: 8px;"><%= b.getPhoneNumber() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p style="margin-top: 10px; font-size: 14px; color: #777;">Chưa có lịch sử đặt lịch bảo dưỡng nào.</p>
        <% } %>


        <% } %>
    </body>
</html>


