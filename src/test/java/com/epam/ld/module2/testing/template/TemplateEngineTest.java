package com.epam.ld.module2.testing.template;

import com.epam.ld.module2.testing.Client;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class TemplateEngineTest {

    @Test
    public void testGenerateMessagePlaceholderReplacement() throws Exception {
        System.setProperty("value", "#{tag}");
        System.setProperty("tag", "ThisIsTag");
        TemplateEngine templateEngine = new TemplateEngine();
        Template template = new Template();
        template.setMessage("text: #{value}");
        Client client = new Client();
        client.setAddresses("test@test.com");
        String result = templateEngine.generateMessage(template, client);

        assertEquals("text: #{tag}", result);
    }

    @Test

    public void testGenerateMessageThrowErrorWhenPlaceholderNotProvidedAtRuntime() {
        TemplateEngine templateEngine = new TemplateEngine();
        Template template = new Template();
        template.setMessage("text: #{valuess}");
        Client client = new Client();
        client.setAddresses("test@test.com");
        assertThrows(Exception.class, () -> templateEngine.generateMessage(template, client));
    }

    @Test
    public void testGenerateMessageIgnoresPlaceholdersNotInTemplate() throws Exception {
        TemplateEngine templateEngine = new TemplateEngine();
        Template template = new Template();
        template.setMessage("text");
        Client client = new Client();
        client.setAddresses("test@test.com");
        String result = templateEngine.generateMessage(template, client);

        assertEquals("text", result);
    }
}
