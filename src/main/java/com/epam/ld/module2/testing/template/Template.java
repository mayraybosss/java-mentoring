package com.epam.ld.module2.testing.template;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * The type Template.
 */
public class Template {
    private String message;
    private boolean consoleMode;

    public String readExpFromFile(String fileName) {
        try {
            BufferedReader fileReader = new BufferedReader(new FileReader(fileName));
            this.message = fileReader.readLine();
            this.consoleMode = false;
        } catch (IOException e) {
            e.printStackTrace();
        }
            return null;
    }

    public String readExpFromConsole() {
        try {
            BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in));
            this.message = consoleReader.readLine();
            this.consoleMode = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getMessage() {
        return message;
    }

    public boolean isConsoleMode() {
        return consoleMode;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setConsoleMode(boolean consoleMode) {
        this.consoleMode = consoleMode;
    }
}
