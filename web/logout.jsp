<%-- 
    Document   : logout
    Created on : Jun 9, 2025, 10:10:56 PM
    Author     : Nguyễn Hùng
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // Huỷ session đăng nhập
    response.sendRedirect("index.jsp"); // Chuyển về trang chủ
%>
