<%-- 
    Document   : testdrive_form
    Created on : Jun 14, 2025, 10:31:17 AM
    Author     : Nguyễn Hùng
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Car" %>
<%@ page import="model.User" %>
<%@ page import="model.MaintenanceService" %>

<%
    List<MaintenanceService> services = (List<MaintenanceService>) request.getAttribute("services");
     User currentUser = (User) session.getAttribute("currentUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký lái thử</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; }
        .form-container {
            max-width: 600px; margin: auto; background: #fff;
            padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        input, select, textarea {
            width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px;
        }
        button {
            padding: 10px 20px; background: #146EF5; color: white; border: none; border-radius: 5px;
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
                       
                    </div>
                </div>
                <div class="dropdown">
                    <a href="<%=contextPath%>/charging">Pin và trạm sạc</a>
                    <div class="dropdown-content">
                        <a href="<%=contextPath%>/charging_station.jsp">Trạm sạc ô tô điện</a>
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

<%
    List<Car> carList = (List<Car>) request.getAttribute("carList");
    Integer userId = null;
    if (session.getAttribute("user") != null) {
        userId = (Integer) session.getAttribute("user");
    }
%>

<div class="form-container">
   <%
    // Hiển thị thông báo từ redirect (thành công)
    String successParam = request.getParameter("success");
    if ("true".equals(successParam)) {
%>
    <div style="padding: 10px; background: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 5px;">
        ✅ Đăng ký lái thử thành công!
    </div>
<%
    }

    // Hiển thị thông báo lỗi chi tiết từ request attribute (forward)
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null) {
%>
    <div style="padding: 10px; background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 5px;">
        ❌ <%= errorMessage %>
    </div>
<%
    }
%>


    <h2>Đăng ký lái thử</h2>
    
    <form action="testdrives" method="post">
        <!-- THÔNG TIN KHÁCH HÀNG -->
      <% if (userId != null) { %>
    <input type="hidden" name="userId" value="<%= userId %>" />
<% } %>


        <label>Họ và tên *</label>
        <input type="text" name="fullName" required maxlength="100">

        <label>Số điện thoại *</label>
        <input type="text" name="phoneNumber" required maxlength="20">

        <!-- LỰA CHỌN XE -->
        <label>Chọn mẫu xe *</label>
        <select name="carId" required>
            <% if (carList != null && !carList.isEmpty()) {
                   for (Car car : carList) { %>
                <option value="<%= car.getCarId() %>"><%= car.getModelName() %></option>
            <% }
               } else { %>
                <option disabled>Không có xe nào</option>
            <% } %>
        </select>

        <!-- THỜI GIAN -->
        <label>Chọn ngày và giờ *</label>
        <input type="datetime-local" name="scheduledTime" required>

        <!-- ĐỊA ĐIỂM -->
        <label>Tỉnh thành *</label>
        <input type="text" name="province" required maxlength="100">

        <label>Địa chỉ cụ thể *</label>
        <input type="text" name="address" required maxlength="255">

        <!-- GHI CHÚ -->
        <label>Yêu cầu khác (tuỳ chọn)</label>
        <textarea name="note" maxlength="200" placeholder="Ghi yêu cầu tại đây..."></textarea>

        <!-- GỬI -->
        <button type="submit">Đăng ký lái thử</button>
    </form>
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
