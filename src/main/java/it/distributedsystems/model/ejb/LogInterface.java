package it.distributedsystems.model.ejb;

import javax.ejb.Local;

@Local
public interface LogInterface {

    void sendMessage(String text);

    void dispose();
}
