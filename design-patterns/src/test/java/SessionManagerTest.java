import org.example.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class SessionManagerTest {
    private SessionManager sessionManager;
    private AccessChecker accessChecker;

    @BeforeEach
    public void setup() {
        // Create a mock instance of AccessChecker
        accessChecker = mock(AccessChecker.class);
        sessionManager = new SessionManager(accessChecker);
    }

    @Test
    public void testCreateSessionWithSufficientAccess() {
        // Prepare test data
        User user = new User("username", "password");
        String accessedPath = "/some/path";

        // Configure the mock behavior
        when(accessChecker.mayAccess(user, accessedPath)).thenReturn(true);

        // Perform the test
        Session session = sessionManager.createSession(user, accessedPath);

        // Assert the result
        assertNotNull(session);
        assertEquals(user, session.getUser());
    }

    @Test
    public void testCreateSessionWithInsufficientAccess() {
        // Prepare test data
        User user = new User("username", "password");
        String accessedPath = "/some/protected/path";

        // Configure the mock behavior
        when(accessChecker.mayAccess(user, accessedPath)).thenReturn(false);

        // Perform the test and assert that it throws the expected exception
        assertThrows(InsufficientRightsException.class, () ->
                sessionManager.createSession(user, accessedPath));
    }
}
