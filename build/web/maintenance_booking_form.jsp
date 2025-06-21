<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceService" %>
<%@ page import="model.Car" %>
<%
    List<MaintenanceService> services = (List<MaintenanceService>) request.getAttribute("services");
    List<Car> carList = (List<Car>) request.getAttribute("carList");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
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
            padding: 20px;
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
    </style>
</head>
<body>
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
</body>
</html>
