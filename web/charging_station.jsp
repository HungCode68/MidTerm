<%-- 
    Document   : charging_station
    Created on : Aug 9, 2025, 11:20:18 AM
    Author     : Nguyễn Hùng
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background: #f5f5f5;
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
                    <a href="<%=contextPath%>/charging_station.jsp">Pin và trạm sạc</a>
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


        <!-- Main content -->
        <div style="padding: 40px; background-color: white; max-width: 1200px; margin: auto;">
            <!-- Title -->
            <h2 style="text-align: center; font-size: 28px; margin-bottom: 8px;">VinFast Charging Station Planning</h2>
            <p style="text-align: center; max-width: 800px; margin: auto; color: #555;">
                VinFast charging stations for electric cars and motorbikes can be installed in existing parking areas without changing their primary function.
                The charging equipment is manufactured by VinFast, featuring a modern, attractive design, meeting European standards, and ensuring electrical safety.
            </p>

            <!-- Location list -->
            <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 12px; margin-top: 24px;">
                <div style="background: #f5f5f5; padding: 12px 20px; border-radius: 4px; display: flex; align-items: center; gap: 8px;">
                    <span>🚗</span> Parking lot / Bus station
                </div>
                <div style="background: #f5f5f5; padding: 12px 20px; border-radius: 4px; display: flex; align-items: center; gap: 8px;">
                    <span>⛽</span> Rest stop / Gas station
                </div>
                <div style="background: #f5f5f5; padding: 12px 20px; border-radius: 4px; display: flex; align-items: center; gap: 8px;">
                    <span>🏢</span> Shopping mall
                </div>
                <div style="background: #f5f5f5; padding: 12px 20px; border-radius: 4px; display: flex; align-items: center; gap: 8px;">
                    <span>🏬</span> Apartment building / Office tower
                </div>
                <div style="background: #f5f5f5; padding: 12px 20px; border-radius: 4px; display: flex; align-items: center; gap: 8px;">
                    <span>🛣</span> Expressway / National highway
                </div>
                <div style="background: #f5f5f5; padding: 12px 20px; border-radius: 4px; display: flex; align-items: center; gap: 8px;">
                    <span>📍</span> Other suitable locations
                </div>
            </div>

            <!-- Image + Policy -->
            <div style="display: flex; flex-wrap: wrap; gap: 32px; margin-top: 40px; align-items: flex-start;">
                <!-- Image -->
                <div style="flex: 1; min-width: 300px;">
                    <img src="https://storage.googleapis.com/vinfast-data-01/pin-tramsac-6_1660273722.png" alt="VinFast Charging Station" style="width: 100%; border-radius: 6px;">
                </div>

                <!-- Policy -->
                <div style="flex: 1; min-width: 300px;">
                    <h3 style="margin-top: 0;">Battery Charging Policy</h3>
                    <p>VinFast provides electric car and motorbike charging rates and payment methods applicable at public charging stations as follows:</p>
                    <ul>
                        <li>Charging rate: <strong>3,858 VND/kWh</strong> effective from March 19, 2024.</li>
                        <li>Overtime charging penalty: <strong>1,000 VND/minute</strong> starting from the 31st minute after the battery is fully charged.</li>
                    </ul>
                    <p><strong>Payment method:</strong> Payment must be made before the 15th of the following month for all charging fees and overtime penalties incurred in the previous month.</p>
                    <p><strong>Notes:</strong></p>
                    <ul>
                        <li>The above charging rate includes VAT.</li>
                        <li>The rate applies from the effective date until further notice.</li>
                    </ul>
                </div>
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
