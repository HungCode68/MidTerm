<%-- 
    Document   : vf 9
    Created on : Aug 9, 2025, 10:02:48 AM
    Author     : Nguyễn Hùng
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Car" %>
<%@ page import="model.User" %>

<%
    Car car = (Car) request.getAttribute("car");
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
                        <a href="<%=contextPath%>/maintenance">Thông tin dịch vụ</a>
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


        <!-- Hiển thị thông tin xe -->
        <div style="position: relative; text-align: center; color: white; font-family: Arial, sans-serif;">
            <!-- Ảnh nền xe -->
            <img src="<%=car.getImageUrl()%>" alt="<%=car.getModelName()%>" style="width: 100%; height: auto;">

            <!-- Tiêu đề -->
            <div style="position: absolute; top: 20%; left: 50%; transform: translateX(-50%); font-size: 60px; font-weight: bold;">
                <%=car.getDescription()%> Thượng Lưu
            </div>

            <!-- Thông tin -->
            <div style="position: absolute; bottom: 5%; width: 100%; display: flex; justify-content: space-around; font-size: 20px;">
                <div>
                    <div>Quãng đường di chuyển</div>
                    <div style="font-size: 32px; font-weight: bold;"><%=car.getSpecifications()%> km</div>
                </div>
                <div>
                    <div>Vận hành mạnh mẽ</div>
                    <div style="font-size: 32px; font-weight: bold;"><%= String.format("%,.0f", car.getPrice()) %> VND</div>
                </div>
            </div>
        </div>

        <!-- Phần bảng giá -->
        <div style="text-align: center; background-color: #fff; padding: 40px 0;">
            <!-- Ảnh xe nhìn từ trên -->
            <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw0c37f2bd/images/PDP/vf9/202406/img-vf9-top-side.webp" alt="<%=car.getModelName()%>" style="width: 400px; margin-bottom: 30px;">

            <!-- Bảng giá -->
            <div style="display: flex; justify-content: center; gap: 50px; margin-bottom: 20px;">
                <!-- VF 9 Eco -->
                <div style="background-color: #f8f8f8; padding: 20px 40px; border-radius: 10px; min-width: 300px;">
                    <div style="background-color: #e0e5e7; padding: 5px; font-size: 18px; font-weight: bold;">
                        <%= car.getModelName() %> Eco
                    </div>
                    <div style="font-size: 28px; font-weight: bold; margin-top: 10px;">
                        <%= String.format("%,.0f", car.getPrice()) %> VNĐ
                    </div>
                </div>

                <!-- VF 9 Plus -->
                <div style="background-color: #f8f8f8; padding: 20px 40px; border-radius: 10px; min-width: 300px;">
                    <div style="background-color: #e0e5e7; padding: 5px; font-size: 18px; font-weight: bold;">
                        <%= car.getModelName() %> Plus
                    </div>
                    <div style="font-size: 28px; font-weight: bold; margin-top: 10px;">
                        <%= String.format("%,.0f", car.getPrice()) %> VNĐ
                    </div>
                </div>
            </div>

            <!-- Ghi chú -->
            <div style="text-align: left; max-width: 700px; margin: 0 auto; font-size: 14px; color: #555;">
                <ul>
                    <li>Giá xe đã bao gồm VAT.</li>
                    <li>Giá xe chưa bao gồm tùy chọn ghế cơ trưởng.</li>
                </ul>
            </div>

            <!-- Nút đặt cọc -->
            <div style="margin-top: 30px;">
                <a href="cars?model=VF%209&action=deposit">
                    <button style="background-color: #0057ff; color: white; padding: 15px 40px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer;">
                        ĐẶT CỌC <br><span style="font-size: 14px;">50.000.000 VNĐ</span>
                    </button>
                </a>

                <a href="/VinfastSystem/consultations"
                   style="display: inline-block; margin-top: 25px; padding: 12px 25px; font-size: 16px; font-weight: bold;
                   background-color: #ff6600; color: white; border-radius: 5px; text-decoration: none;">
                    Đăng ký tư vấn
                </a>
            </div>
        </div>

        <!-- Phần nội thất và trải nghiệm -->
        <div style="background-color: #111; color: white; padding: 60px 0; font-family: Arial, sans-serif;">
            <div style="max-width: 1200px; margin: auto;">
                <!-- Hình nội thất chính -->
                <div style="display: flex; justify-content: center; margin-bottom: 40px;">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw5460e0c6/images/PDP/vf9/202406/interior/interior-first-sight.webp" alt="Nội thất VF9" style="width: 100%; max-width: 800px; border-radius: 8px;">
                </div>

                <!-- Nội dung & hình minh họa -->
                <div style="display: flex; flex-wrap: wrap; gap: 20px; align-items: center;">
                    <!-- Cột nội dung -->
                    <div style="flex: 1; min-width: 300px;">
                        <h2 style="font-size: 28px; font-weight: bold; margin-bottom: 10px;">
                            Bản giao hưởng <br> của <span style="color: #c9a97c;">thẩm mỹ</span> và <br> <span style="color: #c9a97c;">trải nghiệm tiện nghi</span>
                        </h2>
                        <p style="line-height: 1.6; color: #ccc; font-size: 16px;">
                            Ngôn ngữ thiết kế tối giản mang hơi hướng tương lai phối hợp cùng loạt vật liệu cao cấp, thân thiện với môi trường.
                            VF 9 đem lại trải nghiệm nội thất khoáng đạt, thư thái trên mọi hành trình.
                        </p>
                    </div>

                    <!-- Cột hình ảnh -->
                    <div style="flex: 1; min-width: 300px; display: flex; flex-direction: column; gap: 20px;">
                        <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwbd40b697/images/PDP/vf9/202406/interior/int-slide-1.webp" alt="Ghế sau VF9" style="width: 100%; border-radius: 8px;">
                        <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwa1596144/images/PDP/vf9/202406/interior/int-preview-1.webp" alt="Khoang sau VF9" style="width: 100%; border-radius: 8px;">
                    </div>
                </div>
            </div>
        </div>



    </body>
</html>
