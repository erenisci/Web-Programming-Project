<%-- 
    Document   : cart
    Created on : 14 Ara 2023, 15:41:23
    Author     : iscie
--%>

<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.mycompany.web.programming.project.DBConnection"%>
<%@page import="com.mycompany.web.programming.project.DBOperations"%>
<%@page import="com.mycompany.web.programming.project.UserBean"%>
<%@page import="com.mycompany.web.programming.project.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    UserBean userBean = (UserBean) session.getAttribute("userBean");
    String sessionIdFromCookie = "";

    if(userBean == null) {
        UserBean userBeanTemp = new UserBean();
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("userSessId".equals(cookie.getName())) {
                    sessionIdFromCookie = cookie.getValue();

                    userBeanTemp.setUserId(DBOperations.getUserIdFromSess(sessionIdFromCookie));
                    userBeanTemp.setUserNick(DBOperations.getUserNickFromSess(sessionIdFromCookie));

                    session.setAttribute("userBean", userBeanTemp);
                    break;
                }
            }
        }
    }

    userBean = (UserBean) session.getAttribute("userBean");
    boolean isLoggedIn = (userBean != null && userBean.getUserId() != 0) || !sessionIdFromCookie.equals("");
    
    if (isLoggedIn) {
        double toplamTutar = 0;
        if(request.getParameter("deleted") != null && request.getParameter("deleted").equals("true")) {
            %><script>alert("Ürün sepetten başarıyla kaldırıldı!");</script><%
        }
            
    %>
        <!DOCTYPE html>
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
                <p class="logo-p"><a class="logo" href="index.jsp">LOGO</a></p>
                <div class='allflex'>
                    <div class="turnback">
                        <a class="turn" href="index.jsp">
                            Ana Sayfaya Dön
                        </a>
                    </div>
                    <div class='rowflex'>
                        <div class="profile-cont">
                            <div class="left-col">
                            <%
                                List<int[]> cart = (List<int[]>) session.getAttribute("cart");

                                if (cart != null && !cart.isEmpty()) {
                                    List<Product> products = new ArrayList<>();

                                    for (int[] product : cart) {
                                        int productId = product[0];

                                        try (Connection connection = DBConnection.getConnection();
                                            Statement statement = connection.createStatement();) {
                                            String query = "SELECT * FROM urunler WHERE id = " + productId;

                                            try (ResultSet resultSet = statement.executeQuery(query)) {
                                                while (resultSet.next()) {
                                                    Product urun = new Product();
                                                    String newIsim = resultSet.getString("urunIsim").substring(0, 1).toUpperCase() + resultSet.getString("urunIsim").substring(1);
                                                    if(newIsim.length() > 12) newIsim = newIsim.substring(0,12) + "...";
                                                    urun.setUrunIsim(newIsim);
                                                    urun.setUrunId(resultSet.getInt("id"));
                                                    urun.setUrunUrl(resultSet.getString("urunUrl"));
                                                    urun.setUrunFiyat(resultSet.getFloat("urunFiyat"));
                                                    urun.setUrunStok(resultSet.getInt("urunStok"));
                                                    urun.setUrunKullaniciId(resultSet.getInt("urunKullanici_id"));
                                                    urun.setUrunAciklama(resultSet.getString("urunAciklama"));
                                                    urun.setUrunNewPageUrl();
                                                    toplamTutar += urun.getUrunFiyat();
                                                    products.add(urun);
                                                }
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }

                                    for (Product product : products) {
                                        %>
                                        <%@include file="components/cartBox.jsp"%>
                                        <%
                                    }
                                } else {
                            %>
                                    <p class="empty">< Sepetiniz boş ></p>
                            <%
                                }
                            %>
                            </div>
                        </div>
                        <div class="right-col">
                            <div style="align-self: center">
                                <p class="detay">Sepet Detay</p>
                            </div>
                            <div>
                                <p class="tutar">Ödenecek tutar: <span id="totalAmount" class="fiyatSepet"><%out.print(toplamTutar);%></span><span class="tl"> TL</span></p>
                            </div>
                            <div>
                                <button class="satinAl">Satın Al</button>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    <%
    } else {
%>
<%@include file="goToLogin.jsp"%>
<%
    }
%>