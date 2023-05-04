package com.epam.ld.module2.testing;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 * Mail server class.
 */
public class MailServer {

    /**
     * Send notification.
     *
     * @param addresses  the addresses
     * @param messageContent the message content
     */
    public void send(String addresses, String messageContent, boolean consoleMode) {
        String output = "The message was sent to " + addresses + ". With the text: " + messageContent;
        if (consoleMode) {
            System.out.println(output);
        } else {
            FileWriter writer = null;
            try {
                writer = new FileWriter(new File("output.txt"));
                writer.write(output);
                writer.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        // should be sent to address; print log like 'the message was sent to the user' (console/file) based on input
    }
}
