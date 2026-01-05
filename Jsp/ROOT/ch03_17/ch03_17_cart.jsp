<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    List<String> cart = (List<String>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
        session.setAttribute("cart", cart);
    } else {
        Object firstItem = cart.isEmpty() ? null : cart.get(0);
        if (firstItem instanceof Map) {
            List<String> newCart = new ArrayList<>();
            for (Object item : cart) {
                if (item instanceof Map) {
                    Map<String, Object> map = (Map<String, Object>) item;
                    newCart.add((String) map.get("name"));
                }
            }
            cart = newCart;
            session.setAttribute("cart", cart);
        }
    }

    // 清空购物车
    String action = request.getParameter("action");
    if ("clear".equals(action)) {
        cart.clear();
        session.setAttribute("cart", cart);
    }
%>
<html>
<head><title>购物车</title></head>
<body>
    <h2>你选择的结果是</h2>
    <hr>
    <% if (cart.isEmpty()) { %>
        <p>购物车为空！</p>
    <% } else { %>
        <ol>
            <% for (String item : cart) { %>
                <li><%= item %></li>
            <% } %>
        </ol>
        <p style="color: red; margin-top: 10px;">
            <a href="?action=clear" onclick="return confirm('确定要清空购物车吗？')">清空购物车</a>
        </p>
    <% } %>
    <hr>
    <p>
        <a href="ch03_17_meat.jsp">前往肉类商品页面</a> |
        <a href="ch03_17_ball.jsp">前往球类商品页面</a>
    </p>
</body>
</html>
