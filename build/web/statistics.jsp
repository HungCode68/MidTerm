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

<h2>📊 VinFast System Activity Statistics</h2>

<%
    // Using a currency formatter for Vietnamese Dong
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!-- Consultations -->
<div class="section">
    <h3>🚗 Car Consultation Statistics</h3>
    <table>
        <tr>
            <th>Car Name</th>
            <th>Number of Registrations</th>
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
<h3>Monthly Consultation Chart</h3>
<div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
    <canvas id="consultationChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>

<!-- Test Drives -->
<div class="section">
    <h3>🛣️ Car Test Drive Statistics</h3>
    <table>
        <tr>
            <th>Car Name</th>
            <th>Number of Test Drives</th>
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
    <h3>Monthly Test Drive Chart</h3>
    <canvas id="testDriveChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>

<!-- Deposits -->
<div class="section">
    <h3>💰 Car Deposit Statistics</h3>
    <table>
        <tr>
            <th>Car Name</th>
            <th>Number of Deposits</th>
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
    <h3>Monthly Deposit Chart</h3>
    <canvas id="depositChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>

<!-- Maintenance Services -->
<div class="section">
    <h3>🛠️ Maintenance Service Statistics</h3>
    <table>
        <tr>
            <th>Service Name</th>
            <th>Number of Usages</th>
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
    <h3>Monthly Maintenance Chart</h3>
    <canvas id="serviceChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>

<!-- Invoice Revenue -->
<div class="section">
    <h3>📈 Monthly Invoice Revenue</h3>
    <table>
        <tr>
            <th>Month</th>
            <th>Total Amount</th>
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
    <h3>Monthly Invoice Chart</h3>
    <canvas id="invoiceChart" width="400" height="200" style="max-width: 400px; max-height: 200px;"></canvas>
</div>
    
<div class="footer">
    &copy; 2025 VinFast | System Management Statistics
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


