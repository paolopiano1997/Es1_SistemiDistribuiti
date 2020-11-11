package it.distributedsystems.model.ejb;

//import it.distributedsystems.model.logging.OperationLogger;
import it.distributedsystems.model.dao.Customer;
import it.distributedsystems.model.dao.CustomerDAO;

import javax.ejb.*;
import javax.interceptor.Interceptors;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Stateless
@Local(CustomerDAO.class)
//@Remote(CustomerDAO.class) //-> TODO: serve nella versione clustering???
public class EJB3CustomerDAO implements CustomerDAO {

    @PersistenceContext(unitName = "distributed-systems-demo")
    EntityManager em;

    //@EJB LoggingBean logger;

    @Override
//    @Interceptors(OperationLogger.class)
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int insertCustomer(Customer customer) {
        em.persist(customer);
        //logger.sendMessage("Customer added into DB, id=" + customer.getId() + ", name=" + customer.getName());
        return customer.getId();
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int removeCustomerByName(String name) {

        Customer customer;
        if(name != null && !name.equals("")) {
            customer = (Customer) em.createQuery("FROM Customer c WHERE c.name = :customerName").setParameter("customerName", name).getSingleResult();
            em.remove(customer);
            //logger.sendMessage("Customer with name " + name + " removed from DB");
            return customer.getId();
        } else
            return 0;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int removeCustomerById(int id) {
        Customer customer = em.find(Customer.class, id);
        if (customer!=null){
            em.remove(customer);
            //logger.sendMessage("Customer with id " + id + " removed from DB");
            return id;
        }
        else
            return 0;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public Customer findCustomerByName(String name) {
        if(name != null && !name.equals("")) {
            return (Customer) em.createQuery("FROM Customer c where c.name = :customerName").
                    setParameter("customerName", name).getSingleResult();
        } else
            return null;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public Customer findCustomerById(int id) {
        return em.find(Customer.class, id);
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public List<Customer> getAllCustomers() {
        return em.createQuery("FROM Customer").getResultList();
    }
}
