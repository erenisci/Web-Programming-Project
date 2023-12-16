<%-- Document : cart Created on : 14 Ara 2023, 15:41:23 Author : iscie --%> <%@page import="java.util.List"%> <%@page
import="java.sql.ResultSet"%> <%@page import="java.sql.SQLException"%> <%@page import="java.util.ArrayList"%> <%@page
import="java.sql.ResultSet"%> <%@page import="java.sql.SQLException"%> <%@page import="java.sql.Connection"%> <%@page
import="java.sql.Statement"%> <%@page import="com.mycompany.web.programming.project.DBConnection"%> <%@page
import="com.mycompany.web.programming.project.DBOperations"%> <%@page
import="com.mycompany.web.programming.project.UserBean"%> <%@page
import="com.mycompany.web.programming.project.CartItem"%> <%@page
import="com.mycompany.web.programming.project.CartItem"%> <%@page contentType="text/html" pageEncoding="UTF-8"%> <%
UserBean userBean = (UserBean) session.getAttribute("userBean"); String sessionIdFromCookie = ""; if (userBean == null)
{ UserBean userBeanTemp = new UserBean(); Cookie[] cookies = request.getCookies(); if (cookies != null) { for (Cookie
cookie : cookies) { if ("userSessId".equals(cookie.getName())) { sessionIdFromCookie = cookie.getValue();
userBeanTemp.setUserId(DBOperations.getUserIdFromSess(sessionIdFromCookie));
userBeanTemp.setUserNick(DBOperations.getUserNickFromSess(sessionIdFromCookie)); session.setAttribute("userBean",
userBeanTemp); break; } } } } userBean = (UserBean) session.getAttribute("userBean"); boolean isLoggedIn = (userBean !=
null && userBean.getUserId() != 0) || !sessionIdFromCookie.equals(""); if (isLoggedIn) {
if(request.getParameter("deleted") != null && request.getParameter("deleted").equals("true")) { %>
<script>
  alert('Ürün sepetten başarıyla kaldırıldı!');
</script>
<% } %>
<!DOCTYPE html>
<html>
  <head>
    <meta
      http-equiv="Content-Type"
      content="text/html; charset=UTF-8"
    />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0"
    />
    <link
      rel="preconnect"
      href="https://fonts.googleapis.com"
    />
    <link
      rel="preconnect"
      href="https://fonts.gstatic.com"
      crossorigin
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="css/cart.css"
    />
    <link
      rel="stylesheet"
      href="css/general.css"
    />
    <title>Login</title>
  </head>
  <body>
    <p class="logo-p">
      <a
        class="logo"
        href="index.jsp"
        >LOGO</a
      >
    </p>
    <div class="allflex">
      <div class="turnback">
        <a
          class="turn"
          href="index.jsp"
        >
          Ana Sayfaya Dön
        </a>
      </div>
      <div class="rowflex">
        <div class="profile-cont">
          <div class="left-col">
            <% int count = DBOperations.getTotalSepet(userBean.getUserId()); if(count != 0) { List<CartItem>
              products = new ArrayList<>(); try (Connection connection = DBConnection.getConnection(); Statement
              statement = connection.createStatement();) { String query = "SELECT s.*, u.urunStok " + "FROM sepetler s "
              + "JOIN urunler u ON s.urunId = u.id " + "WHERE s.kullanici_id = " + userBean.getUserId(); try (ResultSet
              resultSet = statement.executeQuery(query)) { while (resultSet.next()) { CartItem urun = new CartItem();
              urun.setProductId(resultSet.getInt("urunId")); urun.setUserId(resultSet.getInt("kullanici_id")); String
              newIsim = resultSet.getString("urunIsim").substring(0, 1).toUpperCase() +
              resultSet.getString("urunIsim").substring(1); if(newIsim.length() > 12) newIsim = newIsim.substring(0,12)
              + "..."; urun.setProductName(newIsim); urun.setProductUrl(resultSet.getString("urunUrl"));
              urun.setProductPrice(resultSet.getFloat("urunFiyat")); urun.setProductQuantity(1);
              urun.setTotalStock(resultSet.getInt("urunStok")); %> <%@include file="goToLogin.jsp"%> <% } %></CartItem
            >
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
