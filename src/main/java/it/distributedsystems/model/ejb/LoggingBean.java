package it.distributedsystems.model.ejb;


import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.annotation.Resource;
import javax.ejb.*;
import javax.jms.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.resource.cci.ConnectionFactory;
import java.util.logging.Logger;


@Stateless
public class LoggingBean implements LogInterface {

    private static final Logger logger =
            Logger.getLogger(LoggingBean.class.toString());

    //@Resource(name = "ConnectionFactory", type=javax.jms.ConnectionFactory.class)
    //private QueueConnectionFactory queueFactory;

    //@Resource(name = "jms/LogQueue", type=javax.jms.Queue.class  )
    //private Queue requestQueue;

    private QueueConnection connection;


    @Override
    public void sendMessage(String text) {
        QueueSession session = null;
        QueueSender sender = null;
        try {
            Context jndiContext = new InitialContext();
            QueueConnectionFactory factory = (QueueConnectionFactory)jndiContext.lookup("ConnectionFactory");
            Queue requestQueue = (Queue) jndiContext.lookup("jms/LogQueue");
            connection = factory.createQueueConnection();
            session = connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
            TextMessage message = session.createTextMessage();
            message.setText(text);
            sender = session.createSender(requestQueue);
            sender.send(message);
            System.out.println("Sended message " + message);
            if (connection != null){
                connection.close();
            }
            logger.info("Sended message " + message);
        } catch (JMSException | NamingException e) {
            e.printStackTrace();
        } finally {
            try {
                if (sender != null) sender.close();
                if (session != null) session.close();
            } catch (JMSException e) {
                e.printStackTrace();
            }
        }
    }


    @Remove
    @Override
    public void dispose() {
        logger.info("Chiusura EJB stateless");
    }
}

