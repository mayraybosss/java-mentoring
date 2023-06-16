package org.example;

public class SessionManager {
    private AccessChecker access;

    public SessionManager(AccessChecker accessChecker) {
        this.access = accessChecker;
    }

    public Session createSession(User user, String accessedPath) {
        if (access.mayAccess(user, accessedPath)) {
            return new Session(user);
        } else {
            throw new InsufficientRightsException(user, accessedPath);
        }
    }
}
