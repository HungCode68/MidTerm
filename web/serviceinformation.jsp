<%-- 
    Document   : serviceinformation
    Created on : Jun 13, 2025, 10:21:13 PM
    Author     : Nguyễn Hùng
--%>
<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceService" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<MaintenanceService> services = (List<MaintenanceService>) request.getAttribute("services");
     User currentUser = (User) session.getAttribute("currentUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dịch vụ sửa chữa</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }

        .service-container {
            text-align: center;
            padding: 60px 20px 30px 20px;
            background-color: #ffffff;
        }

        .service-container h1 {
            font-size: 40px;
            color: #222;
            margin-bottom: 20px;
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

        .book-button:hover {
            background-color: #0f5bd1;
        }

        .service-image {
            margin-top: 40px;
        }

        .service-image img {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
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

<div class="service-container">
    <h1>Dịch vụ sửa chữa</h1>
    <a href="booking.jsp">
        <button class="book-button">ĐẶT LỊCH DỊCH VỤ</button>
    </a>
    <div class="service-image">
        <img src="https://static-cms-prod.vinfastauto.com/suachuaimg_1656869862_1658394682.png" alt="Dịch vụ sửa chữa">
        <%-- Lưu ảnh vào thư mục images/ với tên là dichvu1.png để hiển thị đúng --%>
    </div>
    <!-- Quy trình dịch vụ -->
<div class="service-process" style="text-align: center; padding: 60px 20px;">
    <h2 style="font-size: 32px; color: #222;">Quy trình dịch vụ</h2>
    <p style="font-size: 16px; color: #666;">Chuyên nghiệp và chu đáo với 5 bước</p>

    <div style="display: flex; justify-content: center; flex-wrap: wrap; gap: 30px; margin-top: 40px;">
        <div>
            <img src="https://static-cms-prod.vinfastauto.com/b1_1656869917_1658394703.svg" alt="Bước 1" style="width: 60px;">
            <h4 style="margin: 10px 0 5px;">BƯỚC 1</h4>
            <p>Nhắc bảo dưỡng & Đặt hẹn</p>
        </div>
        <div>
            <img src="https://static-cms-prod.vinfastauto.com/b2_1656869949_1658394725.svg" alt="Bước 2" style="width: 60px;">
            <h4 style="margin: 10px 0 5px;">BƯỚC 2</h4>
            <p>Tiếp nhận và tư vấn</p>
        </div>
        <div>
            <img src="https://static-cms-prod.vinfastauto.com/b3_1656869987_1658394747.svg" alt="Bước 3" style="width: 60px;">
            <h4 style="margin: 10px 0 5px;">BƯỚC 3</h4>
            <p>Sửa chữa</p>
        </div>
        <div>
            <img src="https://static-cms-prod.vinfastauto.com/b4_1656870025_1658394770.svg" alt="Bước 4" style="width: 60px;">
            <h4 style="margin: 10px 0 5px;">BƯỚC 4</h4>
            <p>Bàn giao xe</p>
        </div>
        <div>
            <img src="https://static-cms-prod.vinfastauto.com/b5_1656870057_1658394790.svg" alt="Bước 5" style="width: 60px;">
            <h4 style="margin: 10px 0 5px;">BƯỚC 5</h4>
            <p>Chăm sóc sau sửa chữa</p>
        </div>
    </div>

    <div style="max-width: 800px; margin: 40px auto; background-color: #f8f9fa; padding: 20px; border-radius: 8px; font-size: 14px; text-align: left;">
        <ul style="list-style: none; padding: 0;">
            <li>🔧 Khách hàng mua xe mới và làm dịch vụ tại xưởng sẽ được nhắc bảo dưỡng trước 10 ngày so với ngày dự kiến đến kỳ bảo dưỡng.</li>
            <li>🔧 Các cuộc hẹn trước ít nhất 4 tiếng được tiếp nhận và xác nhận hẹn.</li>
        </ul>
    </div>

    <div style="margin-top: 20px;">
        <a href="booking.jsp">
            <button class="book-button">ĐẶT LỊCH BẢO DƯỠNG</button>
        </a>
        <a href="https://vinfastauto.com" target="_blank">
            <button class="book-button" style="background-color: white; color: #146EF5; border: 2px solid #146EF5; margin-left: 10px;">
                LIÊN HỆ VINFAST
            </button>
        </a>
    </div>
</div>
    
 <!-- Danh sách dịch vụ bảo dưỡng -->
    <div style="padding: 40px 20px;">
    <h2 style="text-align: center; color: #222;">Danh sách dịch vụ bảo dưỡng</h2>

    <% if (services == null || services.isEmpty()) { %>
        <p style="text-align:center; color:red;">Không có dữ liệu dịch vụ!</p>
    <% } else { %>
        <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
            <thead style="background-color: #146EF5; color: white;">
                <tr>
                    <th style="padding: 12px; border: 1px solid #ddd;">ID</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Tên dịch vụ</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Mô tả</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Giá (VNĐ)</th>
                </tr>
            </thead>
            <tbody>
                <% for (MaintenanceService s : services) { %>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #ddd; text-align: center;"><%= s.getServiceId() %></td>
                        <td style="padding: 12px; border: 1px solid #ddd;"><%= s.getServiceName() %></td>
                        <td style="padding: 12px; border: 1px solid #ddd;"><%= s.getDescription() %></td>
                        <td style="padding: 12px; border: 1px solid #ddd; text-align: right;">
                            <%= String.format("%,.0f ₫", s.getPrice()) %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
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
