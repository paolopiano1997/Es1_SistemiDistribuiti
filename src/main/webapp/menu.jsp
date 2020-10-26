<div id="menu">
	<ul id="tabs">
		<li <%= request.getRequestURI().contains("home") ? "style=\"background-color: #aaa;\"" : ""%>>
			<a href="<%= request.getContextPath() %>/index.jsp">Manager View</a>
		</li>
		<li <%= request.getRequestURI().contains("home") ? "style=\"background-color: #aaa;\"" : ""%>>
			<a href="<%= request.getContextPath() %>/home.jsp">Home</a>
		</li>
		<li <%= request.getRequestURI().contains("catalogue") ? "style=\"background-color: #aaa;\"" : ""%>>
			<a href="<%= request.getContextPath() %>/catalogue.jsp">View Catalogue</a>
		</li>
		<li <%= request.getRequestURI().contains("cart") ? "style=\"background-color: #aaa;\"" : ""%>>
			<a href="<%= request.getContextPath() %>/cart.jsp">Manage cart</a>
		</li>
		<li <%= request.getRequestURI().contains("checkout") ? "style=\"background-color: #aaa;\"" : ""%>>
			<a href="<%= request.getContextPath() %>/checkout.jsp">Checkout</a>
		</li>
	</ul>
</div>