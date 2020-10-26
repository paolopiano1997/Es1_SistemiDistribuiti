<%@ page session ="true"%>
<%@ page import="java.util.*" %>
<%@ page import="it.distributedsystems.model.dao.*" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="it.distributedsystems.model.ejb.CartBean" %>
<%@ page import="it.distributedsystems.model.ejb.Cart" %>
<%@ page import="javax.ejb.EJB" %>

<%!
    String printTableRow(Product product, String url) {
        StringBuffer html = new StringBuffer();
        html
                .append("<tr>")
                .append("<form>")
                .append("<td>")
                .append("<input type=\"hidden\" name=\"id\" value=\"")
                .append(product.getId())
                .append("\"/>")
                .append("<label>")
                .append(product.getName())
                .append("</label>")
                .append("</td>")

                .append("<td>")
                .append("<input type=\"hidden\" name=\"number\" value=\"")
                .append(product.getProductNumber())
                .append("\"/>")
                .append("<label>")
                .append(product.getProductNumber())
                .append("</td>")

                .append("<td>")
                .append("<input type=\"hidden\" name=\"operation\" value=\"addToCart\"/>")
                .append("<input type=\"submit\" name=\"submit\" value=\"Aggiungi\"/>")
                .append("</td>");

        html
                .append("</form>")
                .append("</tr>");

        return html.toString();
    }

    String printTableRows(List products, String url) {
        StringBuffer html = new StringBuffer();
        Iterator iterator = products.iterator();
        while ( iterator.hasNext() ) {
            html.append( printTableRow( (Product) iterator.next(), url ) );
        }
        return html.toString();
    }

    String printCartRows(Set products, String url){

        StringBuffer html = new StringBuffer();

        Iterator iterator = products.iterator();

        while ( iterator.hasNext() ) {
            html.append( printTableRow( (Product) iterator.next(), url ) );
        }
        return html.toString();



    }
%>

<html>

<head>
    <title> CUSTOMER PAGE </title>
    <meta http-equiv="Pragma" content="no-cache"/>
</head>

<body>

<%
    DAOFactory daoFactory = DAOFactory.getDAOFactory(application.getInitParameter("dao"));
    CustomerDAO customerDAO = daoFactory.getCustomerDAO();
    ProductDAO productDAO = daoFactory.getProductDAO();

    String operation = request.getParameter("operation");
    if ( operation != null && operation.equals("selectCustomer") ) {

        String customerIdString = request.getParameter("customer");
        try{
            Customer customer = customerDAO.findCustomerById(Integer.parseInt(customerIdString));
            session.setAttribute("customer", customer);

        }catch (NumberFormatException e){
            e.printStackTrace();
        }

        Customer customer = (Customer) session.getAttribute("customer");
        Cart cart = (Cart) session.getAttribute(customer.getName());

        if(cart == null){

            Cart lookedUpCart = daoFactory.getCart();
            session.setAttribute(customer.getName(), lookedUpCart);

        }
    }

    if ( operation != null && operation.equals("addToCart") ) {

        Customer customer = (Customer)session.getAttribute("customer");
        Cart cart = (Cart)session.getAttribute(customer.getName());

        String productId = request.getParameter("id");

        Product product = productDAO.findProductById(Integer.parseInt(productId));

        cart.addProduct(product);


    }
    if ( operation != null && operation.equals("finalize") ) {

        PurchaseDAO purchaseDAO = daoFactory.getPurchaseDAO();
        Customer customer = (Customer) session.getAttribute("customer");
        Cart cart = (Cart) session.getAttribute(customer.getName());
        Random rand = new Random();

        Purchase purchase = new Purchase(rand.nextInt(), customer, cart.getProducts());

        purchaseDAO.insertPurchase(purchase);

%>

    <script>
        alert("acquisto effettuato");
    </script>


<%
    }
%>


<%
    Customer customer = (Customer) session.getAttribute("customer");

    if(customer==null){


        List<Customer> customers = customerDAO.getAllCustomers();

        StringBuffer comboCustomer = new StringBuffer();

        comboCustomer.append("<form>")
                .append("<label>Seleziona un customer: </label>")
                .append("<select name=\"customer\">");

        for(Customer c : customers){
            comboCustomer.append("<option value=\"").append(c.getId()).append("\">").append(c.getName()).append("</option>");
        }

        comboCustomer.append("</form>");
        comboCustomer.append("<input type=\"hidden\" name=\"operation\" value=\"selectCustomer\"/>\n" +
                "\t\t\t<input type=\"submit\" name=\"submit\" value=\"submit\"/>");
%>
        <%=comboCustomer.toString()%>
<%
    }else{

        Cart cart = (Cart) session.getAttribute(customer.getName());


%>

            <div>
                <p>Products currently in the database:</p>
                <table>
                    <tr><th>Name</th><th>ProductNumber</th><th>Publisher</th><th></th></tr>
                    <%= printTableRows( productDAO.getAllProducts(), request.getContextPath() ) %>
                </table>
            </div>
            <br><br><br>
            <div>

                <p> Cart </p>
                <table>
                    <tr><th>Name</th><th>ProductNumber</th><th>Publisher</th><th></th></tr>
                    <%= printCartRows( cart.getProducts(), request.getContextPath() )%>
                </table>


                <form>
                    <input type="hidden" name="operation" value="finalize"/>
                    <input type="submit" name="submit" value="Finalizza"/>
                </form>
            </div>

<%
    }
%>




</body>


</html>