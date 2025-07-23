<%-- 
    Document   : statistics
    Created on : Jul 17, 2025, 11:00:53 AM
    Author     : Nguyễn Hùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Statistic" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.User" %>
<%
     User currentUser = (User) session.getAttribute("currentUser");
     %>
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/chart.js">
          <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    </script>
    
    <title>Thống kê hệ thống VinFast</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #0d6efd;
            margin-top: 30px;
        }

        .section {
            margin: 50px auto;
            width: 90%;
            max-width: 1000px;
        }

        h3 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 12px 18px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background-color: #0d6efd;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .footer {
            text-align: center;
            margin: 50px 0 20px;
            color: #999;
            font-size: 14px;
        }
    </style>
</head>
<body>

<h2>📊 Thống kê hoạt động hệ thống VinFast</h2>

<%
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!-- Tư vấn -->
<div class="section">
    <h3>🚗 Thống kê tư vấn xe</h3>
    <table>
        <tr>
            <th>Tên xe</th>
            <th>Số lượt đăng ký tư vấn</th>
        </tr>
        <%
            List<Statistic> consultationStats = (List<Statistic>) request.getAttribute("consultationStats");
            for (Statistic stat : consultationStats) {
        %>
        <tr>
            <td><%= stat.getName() %></td>
            <td><%= stat.getCount() %></td>
        </tr>
        <% } %>
    </table>
</div>
    <h3>Biểu đồ Tư vấn theo tháng</h3>
<div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
    <canvas id="consultationChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>


<!-- Lái thử -->
<div class="section">
    <h3>🛣️ Thống kê lái thử xe</h3>
    <table>
        <tr>
            <th>Tên xe</th>
            <th>Số lượt lái thử</th>
        </tr>
        <%
            List<Statistic> testDriveStats = (List<Statistic>) request.getAttribute("testDriveStats");
            for (Statistic stat : testDriveStats) {
        %>
        <tr>
            <td><%= stat.getName() %></td>
            <td><%= stat.getCount() %></td>
        </tr>
        <% } %>
    </table>
</div>
    <div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
    <h3>Biểu đồ Lái thử xe theo tháng</h3>
    <canvas id="testDriveChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>

<!-- Đặt cọc -->
<div class="section">
    <h3>💰 Thống kê đặt cọc xe</h3>
    <table>
        <tr>
            <th>Tên xe</th>
            <th>Số lượt đặt cọc</th>
        </tr>
        <%
            List<Statistic> depositStats = (List<Statistic>) request.getAttribute("depositStats");
            for (Statistic stat : depositStats) {
        %>
        <tr>
            <td><%= stat.getName() %></td>
            <td><%= stat.getCount() %></td>
        </tr>
        <% } %>
    </table>
</div>
    <div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
    <h3>Biểu đồ Đặt cọc theo tháng</h3>
    <canvas id="depositChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>

<!-- Dịch vụ bảo dưỡng -->
<div class="section">
    <h3>🛠️ Thống kê dịch vụ bảo dưỡng</h3>
    <table>
        <tr>
            <th>Tên dịch vụ</th>
            <th>Số lượt sử dụng</th>
        </tr>
        <%
            List<Statistic> serviceStats = (List<Statistic>) request.getAttribute("serviceStats");
            for (Statistic stat : serviceStats) {
        %>
        <tr>
            <td><%= stat.getName() %></td>
            <td><%= stat.getCount() %></td>
        </tr>
        <% } %>
    </table>
</div>
    <div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
    <h3>Biểu đồ Bảo dưỡng theo tháng</h3>
    <canvas id="serviceChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>

<!-- Doanh thu hóa đơn -->
<div class="section">
    <h3>📈 Doanh thu hóa đơn theo tháng</h3>
    <table>
        <tr>
            <th>Tháng</th>
            <th>Tổng tiền</th>
        </tr>
        <%
            List<Statistic> invoiceStats = (List<Statistic>) request.getAttribute("invoiceStats");
            for (Statistic stat : invoiceStats) {
        %>
        <tr>
            <td><%= stat.getName() %></td>
            <td><%= currencyFormat.format(stat.getTotalAmount()) %></td>
        </tr>
        <% } %>
    </table>
</div>
    <div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
    <h3>Biểu đồ Hóa đơn theo tháng</h3>
    <canvas id="invoiceChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>
    

<div class="footer">
    &copy; 2025 VinFast | Thống kê hệ thống quản lý
</div>

<script>
    // Dữ liệu từ backend
    const consultationLabels = [<% for (Statistic s : consultationStats) { %>"<%= s.getName() %>", <% } %>];
    const consultationData = [<% for (Statistic s : consultationStats) { %><%= s.getCount() %>, <% } %>];

    const testDriveLabels = [<% for (Statistic s : testDriveStats) { %>"<%= s.getName() %>", <% } %>];
    const testDriveData = [<% for (Statistic s : testDriveStats) { %><%= s.getCount() %>, <% } %>];

    const depositLabels = [<% for (Statistic s : depositStats) { %>"<%= s.getName() %>", <% } %>];
    const depositData = [<% for (Statistic s : depositStats) { %><%= s.getCount() %>, <% } %>];

    const serviceLabels = [<% for (Statistic s : serviceStats) { %>"<%= s.getName() %>", <% } %>];
    const serviceData = [<% for (Statistic s : serviceStats) { %><%= s.getCount() %>, <% } %>];

    const invoiceLabels = [<% for (Statistic s : invoiceStats) { %>"<%= s.getName() %>", <% } %>];
    const invoiceData = [<% for (Statistic s : invoiceStats) { %><%= s.getTotalAmount() %>, <% } %>];

    // Hàm tạo biểu đồ
    function renderChart(ctxId, labels, data, labelName) {
        new Chart(document.getElementById(ctxId), {
            type: 'bar', // Hoặc 'line'
            data: {
                labels: labels,
                datasets: [{
                    label: labelName,
                    data: data,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    // Gọi hàm để vẽ biểu đồ
    renderChart("consultationChart", consultationLabels, consultationData, "Số lượt tư vấn");
    renderChart("testDriveChart", testDriveLabels, testDriveData, "Số lượt lái thử");
    renderChart("depositChart", depositLabels, depositData, "Số lượt đặt cọc");
    renderChart("serviceChart", serviceLabels, serviceData, "Số lượt bảo dưỡng");
    renderChart("invoiceChart", invoiceLabels, invoiceData, "Tổng tiền hóa đơn");
</script>


</body>
</html>


