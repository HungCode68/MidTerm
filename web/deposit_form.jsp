<%-- 
    Document   : deposit_form
    Created on : Jun 16, 2025, 11:04:17 AM
    Author     : Nguyễn Hùng
--%>

<%@ page import="dao.CarDAO, model.Car, java.sql.Connection, context.DBContext" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%@ page import="model.User" %>
<%@ page import="model.MaintenanceService" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String contextPath = request.getContextPath();

    String errorMessage = (String) request.getAttribute("errorMessage");
    String success = request.getParameter("success");

    Car car = (Car) request.getAttribute("car");
    if (car == null) {
        String carIdParam = request.getParameter("carId");
        if (carIdParam != null) {
            int carId = Integer.parseInt(carIdParam);

            Connection conn = null;
            try {
                conn = DBContext.getConnection(); // ← Lấy connection từ DBContext
                CarDAO carDAO = new CarDAO(conn); // ← Truyền vào constructor đúng
                car = carDAO.getCarById(carId);
            } catch (Exception e) {
                e.printStackTrace(); // Có thể log ra file/log server
            } finally {
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt cọc xe</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            background: #ffffff;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border-radius: 12px;
            display: flex;
            overflow: hidden;
        }

        .left-panel {
            flex: 1;
            background-color: #f0f4f8;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            border-right: 1px solid #ddd;
        }

        .left-panel img {
            max-width: 100%;
            max-height: 300px;
            border-radius: 12px;
            object-fit: cover;
        }

        .left-panel h3 {
            margin-top: 15px;
            color: #333;
        }

        .right-panel {
            flex: 1;
            padding: 30px;
        }

        .right-panel h2 {
            margin-top: 0;
            color: #0066cc;
        }

        form label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }

        form input, form select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        button[type="submit"] {
            background-color: #28a745;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
        }

        button[type="submit"]:hover {
            background-color: #218838;
        }

        .success-msg, .error-msg {
            text-align: center;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .success-msg {
            color: green;
        }

        .error-msg {
            color: red;
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
             /* Footer */
            .footer {
                background-color: #f5f5f5;
                padding: 40px 60px;
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                font-size: 14px;
                color: #333;
            }

            .footer-left {
                max-width: 50%;
            }

            .footer-left img {
                height: 36px;
                margin-bottom: 12px;
            }

            .footer-middle, .footer-right {
                min-width: 200px;
                margin-top: 20px;
            }

            .footer-section-title {
                font-weight: bold;
                margin-bottom: 10px;
            }

            .footer a {
                text-decoration: none;
                color: #333;
                display: block;
                margin: 4px 0;
            }

            .ecosystem button {
                margin: 6px 6px 0 0;
                padding: 4px 12px;
                border: 1px solid #ccc;
                background-color: white;
                border-radius: 4px;
                cursor: pointer;
            }

            .certification {
                margin-top: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .certification img {
                height: 40px;
            }

            .footer-bottom {
                text-align: left;
                margin-top: 16px;
            }

            .social-icons {
                margin-top: 8px;
            }

            .social-icons img {
                height: 24px;
                margin-right: 8px;
            }

            @media (max-width: 768px) {
                .footer {
                    flex-direction: column;
                    gap: 20px;
                }

                .footer-left, .footer-middle, .footer-right {
                    max-width: 100%;
                }
            }
    </style>
</head>
<body>

<!-- Navbar -->
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

<%-- ✅ Thông báo SweetAlert2 --%>
<script>
    <% if (success != null) { %>
    Swal.fire({
        icon: 'success',
        title: 'Thành công!',
        text: 'Bạn đã đặt cọc thành công cho xe <%= car.getModelName() %>',
        confirmButtonText: 'OK'
    });
    <% } else if (errorMessage != null) { %>
    Swal.fire({
        icon: 'error',
        title: 'Lỗi',
        text: '<%= errorMessage.replaceAll("'", "\\\\'") %>',
        confirmButtonText: 'Thử lại'
    });
    <% } %>
</script>

<div class="container">
    <!-- LEFT: Hình ảnh và thông tin -->
    <div class="left-panel">
    <% if (car.getImageUrl() != null) { %>
        <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwf086e122/images/VF8/ND32V/171V.webp" alt="Hình xe">
    <% } %>

    <h3><%= car.getModelName() %></h3>
    <p><strong>Giá:</strong> <%= String.format("%,.0f", car.getPrice()) %> VNĐ</p>

    <h4>Thông số kỹ thuật:</h4>
    <ul style="padding-left: 20px;">
        <%
            String[] specs = car.getSpecifications().split(",");
            for (String spec : specs) {
        %>
            <li><%= spec.trim() %></li>
        <%
            }
        %>
    </ul>
</div>


    <!-- RIGHT: Form -->
    <div class="right-panel">
        <h2>Đặt cọc xe</h2>

        <% if (success != null) { %>
            <div class="success-msg">✅ Đặt cọc thành công!</div>
        <% } %>

        <% if (errorMessage != null) { %>
            <div class="error-msg">⚠️ <%= errorMessage %></div>
        <% } %>

        <form method="post" action="deposit">
            <input type="hidden" name="carId" value="<%= car.getCarId() %>" />

            <label for="colorExterior">Màu ngoại thất:</label>
            <select name="colorExterior" required>
                <option>Đỏ</option>
                <option>Trắng</option>
                <option>Đen</option>
                <option>Xám</option>
            </select>

            <label for="colorInterior">Màu nội thất:</label>
            <select name="colorInterior" required>
                <option>Be</option>
                <option>Đen</option>
                <option>Nâu</option>
            </select>

            <label>Họ tên:</label>
            <input type="text" name="fullName" required />

            <label>Số điện thoại:</label>
            <input type="text" name="phoneNumber" required />

            <label>CCCD:</label>
            <input type="text" name="cccd" required />

            <label>Tỉnh/Thành phố:</label>
            <input type="text" name="province" required />

            <label>Showroom:</label>
            <select name="showroomId" required>
                <option value="1">VinFast Hà Nội</option>
                <option value="2">VinFast TP.HCM</option>
                <option value="3">VinFast Đà Nẵng</option>
            </select>

            <label>Phương thức thanh toán:</label>
            <select name="paymentMethod" required>
                <option>Chuyển khoản</option>
                <option>Thẻ Visa</option>
                <option>Banking</option>
            </select>

            <button type="submit">✅ Xác nhận đặt cọc</button>
        </form>
    </div>
</div>
 <!-- Footer -->
        <div class="footer">
            <div class="footer-left">
                <img src="https://vinfastauto.com/themes/porto/img/homepage-v2/logo-footer-v2.svg" alt="VinFast Logo">
                <p><strong>Công ty TNHH Kinh doanh Thương mại và Dịch vụ VinFast</strong></p>
                <p>MST/MSDN: 0108926276 do Sở KHĐT TP Hà Nội cấp lần đầu ngày 01/10/2019 và các lần thay đổi tiếp theo.</p>
                <p><strong>Địa chỉ trụ sở chính:</strong> Số 7, đường Bằng Lăng 1, Khu đô thị Vinhomes Riverside, Phường Việt Hưng, Quận Long Biên, Thành phố Hà Nội, Việt Nam</p>
                <div class="ecosystem">
                    <strong>Hệ sinh thái</strong><br>
                    <button onclick="window.open('https://vinhomes.vn', '_blank')">Vinhomes</button>
                    <button onclick="window.open('https://vinmec.com', '_blank')">Vinmec</button>
                    <button onclick="window.open('https://vinpearl.com', '_blank')">Vinpearl</button>
                </div>
                <div class="certification">
                    <img src="https://vinfastauto.com/themes/porto/img/bct.svg" alt="Bộ công thương">
                    <span>VinFast. All rights reserved.<br>© Copyright <%=java.time.Year.now().getValue()%></span>
                </div>
            </div>

            <div class="footer-middle">
                <div class="footer-section-title">VỀ VINFAST</div>
                <a href="<%=contextPath%>/about-vingroup">VỀ VINGROUP</a>
                <a href="<%=contextPath%>/news">TIN TỨC</a>
                <a href="<%=contextPath%>/showroom">SHOWROOM & ĐẠI LÝ</a>
                <a href="<%=contextPath%>/terms">ĐIỀU KHOẢN CHÍNH SÁCH</a>
            </div>

            <div class="footer-right">
                <div class="footer-section-title">DỊCH VỤ KHÁCH HÀNG</div>
                <p>📞 1900 23 23 89</p>
                <p>📧 support.vn@vinfastauto.com</p>
                <div class="footer-section-title">SPEAK-UP HOTLINE</div>
                <p>📞 +84 24 4458 2193</p>
                <p>📧 v.speakup@vinfast.vn</p>
                <div class="footer-section-title">Kết nối với VinFast</div>
                <div class="social-icons">
                    <img src="https://cdn-icons-png.flaticon.com/512/124/124010.png" alt="Facebook" onclick="window.open('https://facebook.com/vinfastvn', '_blank')" style="cursor: pointer;">
                    <img src="https://cdn-icons-png.flaticon.com/512/1384/1384060.png" alt="YouTube" onclick="window.open('https://youtube.com/vinfastvn', '_blank')" style="cursor: pointer;">
                </div>
            </div>
        </div>
</body>
</html>

