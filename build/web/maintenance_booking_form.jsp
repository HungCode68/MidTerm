<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceService" %>
<%@ page import="model.Car" %>
<%@ page import="model.User" %>
<%
    List<MaintenanceService> services = (List<MaintenanceService>) request.getAttribute("services");
    List<Car> carList = (List<Car>) request.getAttribute("carList");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
     User currentUser = (User) session.getAttribute("currentUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lịch dịch vụ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
        }
        .form-wrapper {
            max-width: 900px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
            text-transform: uppercase;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .checkbox-group label {
            font-weight: normal;
            display: block;
            margin-bottom: 5px;
        }
        .section-title {
            font-size: 18px;
            margin: 20px 0 10px;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background-color: #0051ff;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            margin-top: 20px;
            cursor: pointer;
        }
        .btn-submit:hover {
            background-color: #003ecf;
        }
        .alert-success, .alert-error {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 6px;
            text-align: center;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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

            .hero {
                width: 100%;
                height: auto;
                overflow: hidden;
            }

            .hero img {
                width: 100%;
                max-height: 650px;
                object-fit: cover;
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
     <!-- Navbar -->
        <div class="navbar">
            <div class="navbar-left">
                <img src="https://vinfastauto.com/themes/porto/img/new-home-page/VinFast-logo.svg" alt="VinFast Logo">
                <a href="<%=contextPath%>/#">Giới thiệu</a>
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
                    <a href="<%=contextPath%>/#">Dịch vụ hậu mãi</a>
                    <div class="dropdown-content">
                        <a href="<%=contextPath%>/warrantyinformation.jsp">Thông tin bảo hành</a>
                        <a href="<%=contextPath%>/maintenance">Thông tin bảo dưỡng định kỳ</a>
                        
                    </div>
                </div>
                <div class="dropdown">
                    <a href="<%=contextPath%>/#">Pin và trạm sạc</a>
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
               
                <a href="login.jsp" style="color: blue">Đăng Nhập /</a>
                <a href="register.jsp" style="color: blue">Đăng Ký</a>
                <% } %>

                <a href="<%=contextPath%>/cars" class="btn-primary">ĐĂNG KÝ LÁI THỬ</a>
            </div>
        </div>
    
    <div class="form-wrapper">
        <h2>Đặt lịch dịch vụ</h2>

        <% if (success != null) { %>
            <div class="alert-success"><%= success %></div>
        <% } else if (error != null) { %>
            <div class="alert-error"><%= error %></div>
        <% } %>

        <form action="maintenance-booking" method="post">
            <div class="grid">
                <div>
                    <div class="section-title">1. Thông tin khách hàng</div>
                    <div class="form-group">
                        <label>Họ tên *</label>
                        <input type="text" name="fullName" required maxlength="100">
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại *</label>
                        <input type="text" name="phoneNumber" required maxlength="20">
                    </div>
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" name="email" required>
                    </div>

                    <div class="section-title">3. Dịch vụ</div>
                    <div class="form-group">
                        <label>Dịch vụ *</label>
                        <div class="checkbox-group">
                            <% if (services != null) {
                                for (MaintenanceService service : services) { %>
                                    <label>
                                        <input type="radio" name="serviceId" value="<%= service.getServiceId() %>" required>
                                        <%= service.getServiceName() %>
                                    </label>
                            <% }} %>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea name="note" rows="4" placeholder="Cụ thể yêu cầu hoặc ghi chú hỗ trợ..."></textarea>
                    </div>
                </div>

                <div>
                    <div class="section-title">2. Thông tin xe</div>
                    <div class="form-group">
                        <label>Chọn mẫu xe *</label>
                        <select name="carModel" required>
                            <option value="">-- Chọn mẫu xe --</option>
                            <% if (carList != null) {
                                for (Car car : carList) { %>
                                <option value="<%= car.getModelName() %>">
                                    <%= car.getModelName() %> - <%= car.getDescription() %>
                                </option>
                            <% }} else { %>
                                <option disabled>Không có xe nào</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Số Km</label>
                        <input type="number" name="kilometer" min="0">
                    </div>
                    <div class="form-group">
                        <label>Biển số *</label>
                        <input type="text" name="licensePlate" required>
                    </div>

                    <div class="section-title">4. Địa điểm & Thời gian</div>
                    <div class="form-group">
                        <label>Tỉnh thành *</label>
                        <input type="text" name="province" required>
                    </div>
                    <div class="form-group">
                        <label>Quận/Huyện *</label>
                        <input type="text" name="district" required>
                    </div>
                    <div class="form-group">
                        <label>Thời gian *</label>
                        <input type="datetime-local" name="scheduledTime" required>
                    </div>
                </div>
            </div>
            <button type="submit" class="btn-submit">Gửi yêu cầu</button>
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
