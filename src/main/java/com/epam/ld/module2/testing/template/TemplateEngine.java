package com.epam.ld.module2.testing.template;

import com.epam.ld.module2.testing.Client;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * The type Template engine.
 */
public class TemplateEngine {
    /**
     * Generate message string.
     *
     * @param template the template
     * @param client   the client
     * @return the string
     */
    public String generateMessage(Template template, Client client) throws Exception {
        String message = template.getMessage();
        Pattern pattern = Pattern.compile("#\\{(.+?)\\}");
        Matcher matcher = pattern.matcher(message);
        while (matcher.find()) {
            String variableName = matcher.group(1);
            String variableValue = client.getVariable(variableName);
            if (variableValue == null) {
                throw new Exception("Variable not provided: " + variableName);
            }
            message = message.replace("#{" + variableName + "}", variableValue);
        }
        return message;
    }
}
