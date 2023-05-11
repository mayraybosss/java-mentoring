package com.epam.ld.module2.testing;

import com.epam.ld.module2.testing.template.Template;
import com.epam.ld.module2.testing.template.TemplateEngine;

public class Main {
    public static void main(String[] args) throws Exception {
        System.setProperty("value", "#{tag}");
        System.setProperty("tag", "ThisIsTag");
        // 1 - create template
        Template template = new Template();
        template.readExpFromFile("input.txt");

        Client client = new Client();
        client.setAddresses("epam@epam.com");

        MailServer mailServer = new MailServer();
        TemplateEngine templateEngine = new TemplateEngine();
        Messenger messenger = new Messenger(mailServer, templateEngine);

        // 2 - send message
        messenger.sendMessage(client, template);
    }
}
