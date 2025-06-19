<%-- 
    Document   : vf8
    Created on : Jun 10, 2025, 12:13:41 PM
    Author     : Nguyễn Hùng
--%>

<%@ page import="model.Car" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Car car = (Car) request.getAttribute("car");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title><%= car.getModelName() %></title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background: #f5f5f5;
            }
            .container {
                width: 90%;
                max-width: 1200px;
                margin: auto;
                padding: 40px 0;
            }
            .section-title {
                text-align: center;
                font-size: 28px;
                font-weight: bold;
                margin-bottom: 30px;
            }
            .main-image {
                width: 100%;
                border-radius: 12px;
            }
            .car-info {
                text-align: center;
                margin-top: 20px;
            }
            .car-info h2 {
                font-size: 32px;
                color: #333;
            }
            .car-info p {
                font-size: 18px;
                color: #555;
                margin: 10px 0;
            }
            .features {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                margin-top: 50px;
                gap: 20px;
            }
            .feature-box {
                flex: 1;
                min-width: 220px;
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                text-align: center;
            }
            .feature-box img {
                width: 100%;
                max-height: 180px;
                object-fit: contain;
                border-radius: 8px;
            }
            .feature-box h4 {
                margin-top: 15px;
                font-size: 18px;
                color: #222;
            }
            .feature-box p {
                font-size: 14px;
                color: #666;
            }
            .bottom-banner {
                margin-top: 50px;
            }
            .bottom-banner img {
                width: 100%;
                border-radius: 12px;
            }

            @media (max-width: 768px) {
                .container {
                    width: 95%;
                    padding: 20px 0;
                }
                .section-title {
                    font-size: 24px;
                }
                .interior-features {
                    grid-template-columns: 1fr;
                }
                .tech-nav {
                    flex-wrap: wrap;
                    gap: 10px;
                }
                .performance-stats {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }
                .performance-content {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }
                .stat-item {
                    text-align: center;
                }
            }

            .version-list {
                display: flex;
                justify-content: center;
                gap: 30px;
                margin-top: 50px;
                flex-wrap: wrap;
            }

            .version-box {
                width: 300px;
                border: 1px solid #ccc;
                padding: 20px;
                border-radius: 12px;
                background: #fff;
                text-align: center;
                box-shadow: 0 0 10px rgba(0,0,0,0.05);
            }

            .version-box h3 {
                color: #0051ff;
                font-size: 20px;
                margin-bottom: 15px;
            }

            .version-box img {
                width: 100%;
                height: auto;
                border-radius: 8px;
                margin-bottom: 15px;
            }

            .version-box .price {
                font-size: 22px;
                font-weight: bold;
                color: #111;
                margin: 10px 0;
            }

            .version-box .btn-group {
                display: flex;
                justify-content: space-between;
                gap: 10px;
            }

            .version-box button {
                flex: 1;
                padding: 10px;
                font-size: 14px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .btn-datcoc {
                background-color: #0051ff;
                color: white;
            }

            .btn-laithu {
                background-color: white;
                color: #0051ff;
                border: 1px solid #0051ff;
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

        <div class="container">
            <img class="main-image" src="<%= car.getImageUrl() %>" alt="<%= car.getModelName() %>">

            <div class="car-info">
                <h2><%= car.getModelName() %></h2>
                <p><strong>Giá:</strong> <%= String.format("%,.0f", car.getPrice()) %> VNĐ</p>
                <p><strong>Mô tả:</strong> <%= car.getDescription() %></p>
            </div>

            <div class="features">
                <div class="feature-box">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwfc8f9d28/reserves/VF8/thietkekdh.webp" alt="Thiết kế khí động học">
                    <h4>Thiết kế khí động học</h4>
                    <p>Giảm lực cản không khí, giúp xe vận hành êm ái và tiết kiệm năng lượng hơn.</p>
                </div>
                <div class="feature-box">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwfb6021d2/reserves/VF8/guong.webp" alt="Gương chiếu hậu hiện đại">
                    <h4>Gương chiếu hậu hiện đại</h4>
                    <p>Trang bị cảnh báo điểm mù và tự động chỉnh điện giúp an toàn tối đa.</p>
                </div>
                <div class="feature-box">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw8d14f362/reserves/VF8/panorama.webp" alt="Cửa sổ toàn cảnh">
                    <h4>Cửa sổ trời toàn cảnh</h4>
                    <p>Tạo cảm giác rộng rãi, thoáng đãng khi di chuyển.</p>
                </div>
                <div class="feature-box">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw241f0305/reserves/VF8/360.webp" alt="Camera 360 độ">
                    <h4>Cảm biến và camera 360 độ</h4>
                    <p>Giúp người lái dễ dàng quan sát xung quanh khi lùi hoặc đỗ xe.</p>
                </div>
            </div>

            <!-- Interior Luxury Section -->
            <div class="bottom-banner">
                <div class="section-title" style="padding: 30px 0 0 0;">Thăng hạng đẳng cấp</div>
                <div class="section-subtitle">
                    VF 8 Eco và VF 8 Plus dành cho những người hiểu rõ giá trị sang trọng và đẳng cấp, mong<br>
                    muốn tận hưởng trọn vẹn những trải nghiệm cho bản thân và gia đình.
                </div>

                <div class="interior-main">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw3fdecc1d/reserves/VF8/interior-img1.webp" alt="Nội thất cao cấp">
                </div>

                <div class="color-options">
                    <div class="color-option color-brown active">

                    </div>
                    <div class="color-option color-cream"></div>
                    <div class="color-option color-gray"></div>
                    <div class="color-option color-black"></div>
                    <div class="color-option color-red"></div>
                </div>

                <div class="features">
                    <div class="feature-box">
                        <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw4ad4f9ae/reserves/VF8/giamsatnl.webp" alt="Thiết kế khí động học">
                        <h4>Hệ thống giảm sốt người lái</h4>
                        <p>Liên tục theo dõi và cảnh báo khi người lái mệt mỏi qua việc phân tích hành vi lái xe.</p>
                    </div>
                    <div class="feature-box">
                        <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw0c6f2f0d/reserves/VF8/gheda-vegan.webp" alt="Gương chiếu hậu hiện đại">
                        <h4>Ghế da vegan tích hợp sưởi và làm mát</h4>
                        <p>Dân bảo sự thoải mái tối đa cho hành khách với việc làm mát và sưởi động điều chỉnh theo ý muốn và thời gian lái xe.</p>
                    </div>
                    <div class="feature-box">
                        <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw7bf769e5/reserves/VF8/volang.webp" alt="Cửa sổ toàn cảnh">
                        <h4>Vô lăng tối ưu cho mọi trải nghiệm</h4>
                        <p>Không chỉ tính tích hợp mạng xúc vật, thiết kế điều khiển chỉnh phù hợp với cơ thể điều chỉnh theo cách quan lý xe.</p>
                    </div>
                    <div class="feature-box">
                        <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw31a61fc6/reserves/VF8/hud.webp" alt="Camera 360 độ">
                        <h4>HUD tích hợp sắn</h4>
                        <p>Hiển thị các thông tin quan trọng ngay tầm mắt, đa số các chỉ số đường và cảnh báo vận chuyển từ màn hình ảo, chỗ phụ tùng cần thiết.</p>
                    </div>
                </div>
            </div>



            <!-- Technology Section -->
            <div class="tech-section">
                <div class="section-title" style="padding: 30px 0 0 0;">Công nghệ tiên phong</div>
                <div class="section-subtitle">
                    VF 8 Eco và VF 8 Plus sở hữu hệ thống xe các thông nghị đầu mưa mà đi nghệ AI lần<br>
                    vụ trí tích hợp công nghệ AI bên trong, mang đến trải nghiệm lướng vô, vai điều khiển xe.
                </div>

                <div class="bottom-banner">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwb8a40fc6/reserves/VF8/ai.webp" alt="Công nghệ AI">
                </div>

                <div class="tech-nav">
                    <div class="tech-nav-item active">Truy cập VinFast</div>
                    <div class="tech-nav-item">Điện chỉ Số</div>
                    <div class="tech-nav-item">Ứng dụng VinFast</div>
                </div>
            </div>

            <!-- Performance Section -->
            <div class="performance-section">
                <div class="section-title">Sẵn sàng cho mọi hành trình</div>
                <div class="section-subtitle">
                    Với quãng đường di chuyển mới lần sạc đầy lên tới 562 km, kết hợp với hệ thống trạm<br>
                    sạc phủ sóng trên 63 tỉnh thành và nhiều ưu đãi đặc quyền dành riêng độc đáo, VinFast<br>
                    VF 8 cam kết sẵn sàng cùng bạn chinh phục mọi hành trình, cùng bạn tận hướng không<br>
                    khí trong lành và những cảnh thiên nhiên tươi đẹp trên mọi nẻo đường tại Việt Nam.
                </div>

                <div class="bottom-banner">
                    <div class="performance-image">
                        <img src="https://vinfast-binhduong.vn/wp-content/uploads/2020/06/vinfast-vf8-gia-xe-18-768x514.jpg" alt="Gia đình và xe VinFast">
                    </div>
                </div>
            </div>

            <div class="section-title" style="padding: 30px 0 0 0;">An toàn của gia đình bạn là ưu tiên trên hết của VinFast</div>
            <div class="section-subtitle">
                Tất cả các xe VinFast tuân thủ các tiêu chuẩn an toàn nghiêm ngặt nhất và được trang bị những công nghệ hiện đại theo chuẩn quốc tế, mang lại sự yên<br>
                tâm tuyệt đối cho gia đình bạn trên mọi chặng đường.
            </div>

            <div class="features">
                <div class="feature-box">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwaef6af8a/reserves/VF8/sos.webp" alt="Thiết kế khí động học">
                    <h4>Cứu hộ khẩn cấp</h4>
                    <p>Khi nguy cấp, bạn có thể dễ dàng nhấn nút SOS tích hợp sẵn để nhận được sự trợ giúp nhanh chóng.</p>
                </div>
                <div class="feature-box">
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dwbbe0227c/reserves/VF8/11-boombag.webp" alt="Gương chiếu hậu hiện đại">
                    <h4>Hệ thống 11 túi khí</h4>
                    <p>Sở hữu nhiều túi khí nhất trong phân khúc, bảo vệ bạn trong những trường hợp khẩn cấp.</p>
                </div>
            </div>
            <br>
            <div class="section-title">VF 8 series mới</div>
            <div class="version-list">
                <div class="version-box">
                    <h3>VF 8 Eco</h3>
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw2f635011/reserves/VF8/vf8eco.webp" alt="VF 8 Eco">
                    <div class="price">1.019.000.000 VNĐ</div>
                    <div class="btn-group">
                        <a href="cars?model=VF%208&action=deposit">
                            <button class="btn-datcoc">ĐẶT CỌC</button>
                        </a>

                        <button class="btn-laithu">ĐĂNG KÝ LÁI THỬ</button>
                    </div>
                </div>
                <div class="version-box">
                    <h3>VF 8 Plus</h3>
                    <img src="https://shop.vinfastauto.com/on/demandware.static/-/Sites-app_vinfast_vn-Library/default/dw1f936f89/reserves/VF8/vf8plus.webp" alt="VF 8 Plus">
                    <div class="price">1.199.000.000 VNĐ</div>
                    <div class="btn-group">
                        <button class="btn-datcoc">ĐẶT CỌC</button>
                        <button class="btn-laithu">ĐĂNG KÝ LÁI THỬ</button>
                    </div>
                </div>
            </div>

            <div class="bottom-banner" style="text-align:center; margin-top:40px;">
                <div style="font-size: 28px; font-weight: bold;">VF8</div>
                <div style="font-size: 22px; color: #0051ff; margin-bottom: 20px;">Eco</div>

                <table style="margin: auto; border-collapse: collapse; font-size: 16px; color: #333;">
                    <%
                        String[] specs = car.getSpecifications().split(",");
                        for (String spec : specs) {
                    %>
                    <tr style="border-top: 1px solid #eee;">
                        <td style="padding: 12px 20px; text-align: left;"><%= spec.trim() %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
 <br>
    <a href="/VinfastSystem/consultations"
       style="display: inline-block; margin-top: 25px; padding: 12px 25px; font-size: 16px; font-weight: bold;
              background-color: #ff6600; color: white; border-radius: 5px; text-decoration: none;">
        Đăng ký tư vấn
    </a>


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


