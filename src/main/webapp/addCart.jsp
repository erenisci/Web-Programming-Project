<%-- 
    Document   : addCart
    Created on : 14 Ara 2023, 15:20:04
    Author     : iscie
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.mycompany.web.programming.project.DBOperations"%>
<%@page import="com.mycompany.web.programming.project.UserBean"%>
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
        List<int[]> cart = (List<int[]>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        String productIdString = request.getParameter("productId");
        if (productIdString != null && !productIdString.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdString);

                boolean productExists = false;
                for (int[] product : cart) {
                    if (product[0] == productId) {
                        productExists = true;
                        break;
                    }
                }
                if (!productExists) {
                    int[] productInfo = {productId};
                    cart.add(productInfo);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    } else {
%>
<%@include file="goToLogin.jsp"%>
<%
    }
%>