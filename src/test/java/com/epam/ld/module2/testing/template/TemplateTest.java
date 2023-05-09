package com.epam.ld.module2.testing.template;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import org.mockito.Mockito;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.when;

public class TemplateTest {
    @Test
    public void testReadExpFromFile() throws Exception {
        File mockFile = Mockito.mock(File.class);
        when(mockFile.exists()).thenReturn(true);
        when(mockFile.isFile()).thenReturn(true);
        when(mockFile.canRead()).thenReturn(true);
        when(mockFile.getPath()).thenReturn("test.txt");
        FileWriter writer = new FileWriter(mockFile);
        writer.write("Some text");
        writer.close();
        Template template = new Template();
        template.readExpFromFile(mockFile.getPath());
        assertEquals("Some text", template.getMessage());
        assertFalse(template.isConsoleMode());
    }

    @Test
    public void testReadExpFromConsole() {
        ByteArrayInputStream in = new ByteArrayInputStream("Some text".getBytes());
        System.setIn(in);
        Template template = new Template();
        template.readExpFromConsole();
        assertEquals("Some text", template.getMessage());
        assertTrue(template.isConsoleMode());
    }

    @Test
    public void testReadExpFromFileWithPartialMock() {
        Template template = Mockito.spy(new Template());
        doReturn("Some text").when(template).readExpFromFile(anyString());
        String message = template.readExpFromFile("test");
        assertEquals("Some text", message);
        assertFalse(template.isConsoleMode());
    }

    @Test
    @EnabledIfSystemProperty(named = "env", matches = ".*dev.*")
    public void testReadExpFromFileDisablingOnCondition() {
        Template template = new Template();
        template.readExpFromFile("input.txt");
        assertNull(template.getMessage());
        assertFalse(template.isConsoleMode());
    }
}
