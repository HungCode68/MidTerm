<%-- 
    Document   : warrantyinformation
    Created on : Jun 11, 2025, 10:21:17 PM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Bảo hành - sửa chữa</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #fff;
                text-align: center;
            }

            .section-title {
                font-size: 36px;
                font-weight: 500;
                margin-top: 40px;
                color: #222;
            }
            .book-button {
            background-color: #146EF5;
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

            .service-button {
                display: inline-block;
                margin-top: 20px;
                padding: 12px 28px;
                font-size: 16px;
                background-color: #0051ff;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                transition: background-color 0.3s;
            }

            .service-button:hover {
                background-color: #003edc;
            }

            .service-image {
                margin-top: 40px;
                width: 100%;
                max-height: 600px;
                object-fit: cover;
            }
            .warranty-section {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                padding: 40px;
                max-width: 1200px;
                margin: 0 auto;
            }

            .warranty-image {
                flex: 1;
                min-width: 300px;
                max-width: 500px;
            }

            .warranty-image img {
                width: 100%;
                border-radius: 8px;
            }

            .warranty-text {
                flex: 1;
                min-width: 300px;
                padding: 0 30px;
                box-sizing: border-box;
            }

            .warranty-text h2 {
                font-size: 28px;
                margin-bottom: 20px;
                color: #222;
            }

            .warranty-text p {
                font-size: 16px;
                line-height: 1.8;
                color: #333;
            }
            .warranty-text h4 {
                font-size: 20px;
                margin-top: 10px;
                color: #333;
            }

            .warranty-text ul {
                font-size: 16px;
                color: #333;
                line-height: 1.6;
            }

            .warranty-text li {
                margin-bottom: 10px;
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

        <div class="section-title">Bảo hành - sửa chữa</div>

        <a href="/VinfastSystem/maintenance-booking">
        <button class="book-button">ĐẶT LỊCH DỊCH VỤ</button>
    </a>

        <img class="service-image" src="https://static-cms-prod.vinfastauto.com/baohanh_1656867400_1658395630.png" alt="Ảnh bảo hành - sửa chữa">
        <div class="warranty-section">
            <div class="warranty-image">
                <img src="https://static-cms-prod.vinfastauto.com/pham-vi-bao-hanh_1675929408.jpg" alt="Bảo hành VinFast">
                <%-- Hoặc sử dụng: src="resources/img/warrantyinfo.png" tùy cấu trúc dự án --%>
            </div>
            <div class="warranty-text">
                <h2>Phạm vi bảo hành</h2>
                <p>Bảo hành áp dụng cho các hư hỏng do lỗi phần mềm, lỗi chất lượng của linh kiện hoặc lỗi lắp ráp của VinFast với điều kiện sản phẩm được sử dụng và bảo dưỡng đúng cách, ngoại trừ các hạng mục không thuộc phạm vi bảo hành.</p>
                <p>Phụ tùng thay thế trong bảo hành là những chi tiết, linh kiện chính hãng nhỏ nhất được VinFast cung cấp.</p>
                <p>Bảo hành có hiệu lực trên toàn lãnh thổ Việt Nam, chỉ được áp dụng và thực hiện tại các Xưởng dịch vụ và Nhà phân phối ủy quyền của VinFast.</p>
                <p>Công việc bảo hành được thực hiện miễn phí theo các điều khoản và điều kiện bảo hành.</p>
                <p>VinFast không có trách nhiệm thu hồi và thay thế sản phẩm khác cho khách hàng nếu việc sửa chữa bảo hành không thể khắc phục được lỗi chất lượng, lỗi vật liệu hay lỗi lắp ráp của nhà sản xuất.</p>
            </div>
        </div>

        <div class="warranty-section">
            <div class="warranty-text">
                <h2>Phụ tùng xe mới<br>Bảo hành giới hạn</h2>
                <h4>Pin cao áp</h4>
                <p><em>Pin cao áp mua theo xe mới, sử dụng tiêu chuẩn:</em></p>
                <ul style="padding-left: 20px;">
                    <li>🔧 Áp dụng cho VF 7, VF 8, VF 9: được bảo hành 10 năm hoặc 200.000 km tùy theo điều kiện nào đến trước.</li>
                    <li>🔧 Áp dụng cho VF 3, VF 5, VF 6, VF Minio Green, VF Herio Green, VF Limo, VF e34, VF Nerio Green, VF Limo Green: được bảo hành 8 năm hoặc 160.000 km tùy điều kiện nào đến trước.</li>
                    <li>🔧 Áp dụng cho VF EC Van: được bảo hành 7 năm hoặc 160.000 km tùy điều kiện nào đến trước.</li>
                </ul>
            </div>
            <div class="warranty-image">
                <img src="https://static-cms-prod.vinfastauto.com/HAI07048%202_2.png" alt="Bảo hành giới hạn">
            </div>
        </div>

        <div class="warranty-section">
            <div class="warranty-image">
                <img src="https://static-cms-prod.vinfastauto.com/HAI077291.png" alt="Bảo hành VinFast">
                <%-- Hoặc sử dụng: src="resources/img/warrantyinfo.png" tùy cấu trúc dự án --%>
            </div>
            <div class="warranty-text">
                <h2>Bảo hành phụ tùng
                    Thay thế chính hãng</h2>
                <p>Phụ tùng thay thế cho xe của khách hàng trong quá trình sửa chữa tại XDV/NPP của VinFast do khách hàng chịu chi phí, sẽ có thời hạn bảo hành như sau:</p>
                <p>Phụ tùng (không bao gồm Ắc Quy 12V và Pin cao áp):</p>
                <p>Ô tô xăng: bao gồm Fadil, Lux A, Lux SA, President: 12 tháng hoặc 20.000 km tùy thuộc điều kiện nào đến trước từ ngày hoàn thành sửa chữa.</p>
                <p>Ô tô điện: 2 năm hoặc 40.000 km tùy theo điều kiện nào đến trước tính từ ngày mua.</p>
                <p>Phụ tùng mua nhưng không được thay thế tại XDV/ NPP của VinFast sẽ không được bảo hành theo chính sách.</p>
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
                    <button>Vinhomes</button>
                    <button>Vinmec</button>
                    <button>Vinpearl</button>
                </div>
                <div class="certification">
                    <img src="https://vinfastauto.com/themes/porto/img/bct.svg" alt="Bộ công thương">
                    <span>VinFast. All rights reserved.<br>© Copyright 2025</span>
                </div>
            </div>

            <div class="footer-middle">
                <div class="footer-section-title">VỀ VINFAST</div>
                <a href="#">VỀ VINGROUP</a>
                <a href="#">TIN TỨC</a>
                <a href="#">SHOWROOM & ĐẠI LÝ</a>
                <a href="#">ĐIỀU KHOẢN CHÍNH SÁCH</a>
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
                    <img src="https://cdn-icons-png.flaticon.com/512/124/124010.png" alt="Facebook">
                    <img src="https://cdn-icons-png.flaticon.com/512/1384/1384060.png" alt="YouTube">
                </div>
            </div>
        </div>

    </body>
</html>

