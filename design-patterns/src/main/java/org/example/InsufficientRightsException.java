package org.example;

public class InsufficientRightsException extends RuntimeException {
    public InsufficientRightsException(User user, String accessedPath) {
        super("Insufficient rights for user: " + user.getUsername() + " to access path: " + accessedPath);
    }
}
