package it.distributedsystems.model.ejb;

import it.distributedsystems.model.dao.Customer;
import it.distributedsystems.model.dao.Producer;
import it.distributedsystems.model.dao.Product;

import java.util.Set;

public interface Cart {

    public Customer getCustomer();
    public void setCustomer(Customer customer);
    public Set<Product> getProducts();
    public void setProducts(Set<Product> products);
    public void addProduct(Product p);
}
