<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    List<String> cart = (List<String>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
        session.setAttribute("cart", cart);
    } else {
        // 兼容性处理：如果Session中是旧的Map格式，转换为String格式
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

    // 处理提交选中的商品
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String[] selectedItems = request.getParameterValues("items");
        if (selectedItems != null) {
            for (String item : selectedItems) {
                cart.add(item);
            }
        }
    }
%>
<html>
<head><title>肉类商品</title></head>
<body>
    <h2>各种肉大甩卖，一律十块：</h2>
    <hr>
    <form action="" method="post">
        <input type="hidden" name="action" value="add">
        <p>
            <input type="checkbox" name="items" value="牛肉"> 牛肉
            <input type="checkbox" name="items" value="猪肉"> 猪肉
            <input type="checkbox" name="items" value="羊肉"> 羊肉
            <input type="checkbox" name="items" value="鸡肉"> 鸡肉 
        </p>
        <hr>
        <p>
            <input type="submit" value="提交">
            <a href="ch03_17_ball.jsp">买点别的</a> |
            <a href="ch03_17_cart.jsp">查看购物车</a>
        </p>
    </form>
</body>
</html>
