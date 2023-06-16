package org.example;

public class AccessChecker {
    private static AccessChecker instance;

    public static AccessChecker getInstance() {
        if (instance == null) {
            instance = new AccessChecker();
        }
        return instance;
    }

    private ServerConfig config = ServerConfig.getInstance();

    public AccessChecker() {
        // initialization..
    }

    public boolean mayAccess(User user, String path) {
        String userLevel = config.getAccessLevel(user);
        // check if level suffices
        return true;
    }
}
