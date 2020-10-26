<%@ page import="it.distributedsystems.model.ejb.Cart" %>
<%@ page import="it.distributedsystems.model.dao.Product" %>
<%@ page import="java.util.Set" %>
<%@ page import="it.distributedsystems.model.dao.DAOFactory" %>
<%@ page import="it.distributedsystems.model.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<!-- accesso alla sessione -->
<%@ page session="true"%>

<!-- import di classi Java -->

<!-- metodi richiamati nel seguito -->
<%!

    void add(Cart cart, Product product) {

        boolean alreadyInCart = false;

        for ( Product itemInCart : cart.getProducts() ) {
            if ( itemInCart.getId() == product.getId() ) {
                alreadyInCart = true;
                break;
            }
        }

        if ( ! alreadyInCart ) {
            cart.addProduct(product);
        }

    }

    int total(Cart cart) {
        int total = 0;
        for ( Product item : cart.getProducts() ) {
            total += item.getPrice();
        }
        return total;
    }

%>

<!-- codice html restituito al client -->
<html>
<head>
    <meta name="Author" content="pisi79">
    <title>Cart JSP</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/default.css" type="text/css"/>
</head>

<body>

<%@ include file="menu.jsp" %>

<div id="main" class="clear">

    <jsp:useBean id="cart" class="it.distributedsystems.model.ejb.CartBean" scope="session" />

    <%
        DAOFactory daoFactory = DAOFactory.getDAOFactory( application.getInitParameter("dao") );
        ProductDAO productDAO = daoFactory.getProductDAO();
        List<Product> products = productDAO.getAllProducts();

        if ( request.getParameter("empty") != null && request.getParameter("empty").equals("ok") ) {
            cart.getProducts().clear();
        }

        if ( request.getParameter("add") != null && request.getParameter("add").equals("add to cart") ) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.findProductById(id);
            add(cart,product);
        }

    %>

    <div id="left" style="float: left; width: 48%; border-right: 1px solid grey">

        <p>Select an item from the catalogue:</p>
        <table class="formdata">
            <tr>
                <th style="width: 25%">Name</th>
                <th style="width: 25%">Price</th>
                <th style="width: 25%">Producer</th>
                <th style="width: 25%"></th>
            </tr>
            <%

                for( Product aCatalogueItem : products ){
            %>
            <form>
                <tr>
                    <td><%= aCatalogueItem.getName() %></td>
                    <td><%= aCatalogueItem.getPrice() %> &#8364;</td>
                    <td><%= aCatalogueItem.getProducer() == null ? "n.d" : aCatalogueItem.getProducer().getName() %></td>
                    <td>
                        <input type="hidden" name="id" value="<%= aCatalogueItem.getId() %>"/>
                        <input type="submit" name="add" value="add to cart"/>
                    </td>
                </tr>
            </form>
            <% } %>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>

    <div id="right" style="float: right; width: 48%">
        <p>Cart content:</p>
        <table class="formdata">
            <tr>
                <th style="width: 33%">Name</th>
                <th style="width: 33%">Price</th>
                <th style="width: 25%">Producer</th>
            </tr>
            <%
                Set<Product> cartItems = cart.getProducts();
                for( Product aCartItem : cartItems ){
            %>
            <tr>
                <td><%= aCartItem.getName() %></td>
                <td><%= aCartItem.getPrice() %> &#8364;</td>
                <td><%= aCartItem.getProducer() == null ?  "n.d" : aCartItem.getProducer().getName()%></td>
            </tr>
            <%
                }
            %>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
        <br/>
        <p>
            Total: <span style="font-size: x-large; color: red;"><%= total(cart) %> &#8364;</span>
        </p>

        <%
            if ( cart.getProducts().size() > 0 ) {
        %>
        <br/>
        <a href="?empty=ok">Remove all items from the cart</a>
        <%
            }
        %>
    </div>

    <div class="clear">
        <p>&nbsp;</p>
    </div>

</div>


</body>
</html>
