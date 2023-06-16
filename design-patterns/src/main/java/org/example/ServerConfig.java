package org.example;

public class ServerConfig {
    private static ServerConfig instance;
    private static String configFilePath = "...";

    public static ServerConfig getInstance() {
        if (instance == null) {
            instance = new ServerConfig();
        }
        return instance;
    }

    public ServerConfig() {
        // load configuration from file
        // validate
    }

    public String getAccessLevel(User u) {
        return "somerole";
    }
}
