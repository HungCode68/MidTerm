<%-- 
    Document   : register
    Created on : Jun 9, 2025, 9:38:45 PM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            padding: 40px;
        }
        .register-form {
            background: #ffffff;
            width: 400px;
            margin: auto;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .register-form h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .register-form input[type="text"],
        .register-form input[type="email"],
        .register-form input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 8px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .register-form input[type="submit"] {
            width: 100%;
            background-color: #007bff;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .register-form input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            margin-bottom: 15px;
            text-align: center;
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
                <a href="index.html">Giới thiệu</a>
                <div class="dropdown">
                    <a href="#">Ô tô</a>
                    <div class="dropdown-content">
                        <a href="#">VF 5</a>
                        <a href="#">VF 6</a>
                        <a href="#">VF 7</a>
                        <a href="#">VF 8</a>
                        <a href="#">VF 9</a>
                    </div>
                </div>
                <div class="dropdown">
                    <a href="#">Dịch vụ hậu mãi</a>
                    <div class="dropdown-content">
                        <a href="#">Thông tin bảo hành</a>
                        <a href="#">Thông tin bảo dưỡng định kỳ</a>
                        
                    </div>
                </div>
                <div class="dropdown">
                    <a href="#">Pin và trạm sạc</a>
                    <div class="dropdown-content">
                        <a href="#">Trạm sạc ô tô điện</a>
                    </div>
                </div>
            </div>
            <div class="navbar-right">
                <a href="login.jsp" style="color: blue">Đăng Nhập /</a>
                <a href="register.jsp" style="color: blue">Đăng Ký</a>

                <a href="register.html" class="btn-primary">ĐĂNG KÝ LÁI THỬ</a>
            </div>
        </div>

<div class="register-form">
    <h2>Đăng ký tài khoản</h2>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <form action="register" method="post">
        <label for="fullName">Họ và tên:</label>
        <input type="text" id="fullName" name="fullName" required>

        <label for="phoneNumber">Số điện thoại:</label>
        <input type="text" id="phoneNumber" name="phoneNumber" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>

        <label for="password">Mật khẩu:</label>
        <input type="password" id="password" name="password" required>

        <label for="cccd">CCCD:</label>
        <input type="text" id="cccd" name="cccd" required>

        <input type="submit" value="Đăng ký">
    </form>
</div>

</body>
</html>

