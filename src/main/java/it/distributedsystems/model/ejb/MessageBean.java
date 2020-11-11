package it.distributedsystems.model.ejb;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.annotation.Resource;
import javax.ejb.ActivationConfigProperty;
import javax.ejb.MessageDriven;
import javax.jms.*;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.logging.Logger;

@MessageDriven(
        activationConfig = {
                @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "javax.jms.Queue"),
                @ActivationConfigProperty(propertyName = "destination", propertyValue = "jms/LogQueue")
        })
public class MessageBean implements MessageListener {
    private static final Logger logger = Logger.getLogger(MessageBean.class.toString());

    private static final File logFile = new File("C:\\logejb\\log.txt");

    private FileWriter log;

    @PostConstruct
    public void init() {
        logger.info("Init Message Bean Listener...");
        System.out.println("Init Message Bean Listener...");
        try {
            logFile.createNewFile();
            log = new FileWriter(logFile,true);
        } catch (IOException e) {
            e.printStackTrace();
            logger.warning(e.getMessage());
        }
    }

    @Override
    public void onMessage(Message message) {
        try {
            String msg = ((TextMessage) message).getText();
            log.append(msg + "\n");
            log.flush();
            System.out.println(msg);
        } catch (JMSException | IOException e) {
            e.printStackTrace();
            logger.warning(e.getMessage());
        }
    }

    @PreDestroy
    public void preDispose() {
        logger.info("Closing Message Bean listener...");
        try {
            log.close();
        } catch (IOException e) {
            e.printStackTrace();
            logger.warning(e.getMessage());
        }
    }
}
