package it.distributedsystems.model.ejb;


import it.distributedsystems.model.dao.Customer;
import it.distributedsystems.model.dao.Product;

import javax.ejb.Stateful;
import java.util.HashSet;
import java.util.List;
import java.util.Set;



@Stateful(name="CartBean")
public class CartBean implements Cart{

    private Customer customer;
    private Set<Product> products;


    public CartBean(){
        this.products = new HashSet<>();
    }

    public Customer getCustomer(){
        return this.customer;
    }
    public void setCustomer(Customer customer){
        this.customer = customer;
    }

    public Set<Product> getProducts(){
        return this.products;
    }
    public void setProducts(Set<Product> products){
        this.products = products;
    }

    public void addProduct(Product p){
        products.add(p);
    }

}
