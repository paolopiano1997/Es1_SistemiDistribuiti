package it.distributedsystems.model.ejb;

//import it.distributedsystems.model.logging.OperationLogger;
import it.distributedsystems.model.dao.Customer;
import it.distributedsystems.model.dao.CustomerDAO;
import it.distributedsystems.model.dao.Producer;
import it.distributedsystems.model.dao.ProducerDAO;

import javax.ejb.*;
import javax.interceptor.Interceptors;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Stateless
@Local(ProducerDAO.class)
//@Remote(CustomerDAO.class) //-> TODO: serve nella versione clustering???
public class EJB3ProducerDAO implements ProducerDAO {

    @PersistenceContext(unitName = "distributed-systems-demo")
    EntityManager em;

   // @EJB LoggingBean logger;

    @Override
//    @Interceptors(OperationLogger.class)
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int insertProducer(Producer producer) {
        em.persist(producer);
        //logger.sendMessage("Producer inserted into DB, id=" + producer.getId() + ", name=" + producer.getName());
        return producer.getId();
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int removeProducerByName(String name) {

        Producer producer;
        if(name != null && !name.equals("")) {
            producer = (Producer) em.createQuery("FROM Producer p WHERE p.name = :producerName")
                    .setParameter("producerName", name)
                    .getSingleResult();
            em.remove(producer);
           // logger.sendMessage("Producer with name " + name + " removed from DB");
            return producer.getId();
        } else
            return 0;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int removeProducerById(int id) {
        Producer producer = em.find(Producer.class, id);
        if (producer!=null){
            em.remove(producer);
            //logger.sendMessage("Producer with id " + id + " removed from DB");
            return id;
        }
        else
            return 0;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public Producer findProducerByName(String name) {
        if(name != null && !name.equals("")) {
            Producer p = (Producer) em.createQuery("FROM Producer p where p.name = :producerName").
                    setParameter("producerName", name).getSingleResult();
            return p;
        } else
            return null;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public Producer findProducerById(int id) {
        Producer p = em.find(Producer.class, id);
        return p;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public List<Producer> getAllProducers() {
        return em.createQuery("FROM Producer").getResultList();
    }
}