<%-- 
    Document   : login
    Created on : Jun 9, 2025, 9:43:37 PM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập tài khoản</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
        }
        .login-container {
            width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            box-shadow: 0px 0px 10px #ccc;
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        label, input {
            display: block;
            width: 100%;
            margin-bottom: 10px;
        }
        input[type="email"],
        input[type="password"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background: #0056b3;
            color: white;
            padding: 10px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .error {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
        .link-register {
            text-align: center;
            margin-top: 10px;
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
                        <a href="#">Thông tin dịch vụ</a>
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
    
<div class="login-container">
    <h2>Đăng nhập</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="login" method="post">
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required>

        <label for="password">Mật khẩu:</label>
        <input type="password" name="password" id="password" required>

        <input type="submit" value="Đăng nhập">
    </form>

    <div class="link-register">
        Chưa có tài khoản? <a href="register.jsp">Đăng ký</a>
    </div>
</div>
</body>
</html>

