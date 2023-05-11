package com.epam.ld.module2.testing;

import java.lang.management.ManagementFactory;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * The type Client.
 */
public class Client {
    private String addresses;

    private Map<String, String> variables;

    public Client() {
        variables = new HashMap<>();
        Properties props = System.getProperties();
        for (String key : props.stringPropertyNames()) {
            variables.put(key, props.getProperty(key));
        }
    }

    public String getVariable(String name) {
        return variables.get(name);
    }

    public void setVariable(String name, String value) {
        variables.put(name, value);
    }

    /**
     * Gets addresses.
     *
     * @return the addresses
     */
    public String getAddresses() {
        return addresses;
    }

    /**
     * Sets addresses.
     *
     * @param addresses the addresses
     */
    public void setAddresses(String addresses) {
        this.addresses = addresses;
    }
}