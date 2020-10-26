<%@ page session ="true"%>

<%@ page import="java.util.*" %>
<%@ page import="it.distributedsystems.model.dao.*" %>


<!-- metodi richiamati nel seguito -->
<%!
%>

<!-- codice html restituito al client -->
<html>
	<head>
		<meta name="Author" content="paolopiano1997">
		<title>Catalogue</title>
		<link rel="stylesheet" href="<%= request.getContextPath() %>/styles/default.css" type="text/css"/>
	</head>

	<body>
		<%

			DAOFactory daoFactory = DAOFactory.getDAOFactory( application.getInitParameter("dao") );
			ProductDAO productDAO = daoFactory.getProductDAO();
			CustomerDAO customerDAO = daoFactory.getCustomerDAO();
			List<Product> products = productDAO.getAllProducts();


		%>

		<%@ include file="menu.jsp" %>

		<div id="main" class="clear">

				<p>Current catalogue:</p>
				<table class="formdata">
					<tr>
						<th style="width: 31%">Name</th>
						<th style="width: 31%">Price</th>
						<th style="width: 31%">Producer</th>
					</tr>
					<%

					for( Product p : products ){
					%>
						<tr>
							<td><%= p.getName() %></td>
							<td><%= p.getPrice() %> </td>
							<td><%= p.getProducer() == null ? "n.d" : p.getProducer().getName() %></td>
						</tr>
					<% } %>
				</table>
			</div>

			<div class="clear">

			</div>

		</div>

	</body>
</html>

