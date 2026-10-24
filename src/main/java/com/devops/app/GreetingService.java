package com.devops.app;

public class GreetingService {

    static final String DEFAULT_GREETING = "Hello, DevOps World!";
    private static final int MAX_NAME_LENGTH = 30;

    public String greet(String name) {
        if (name == null || name.isBlank()) {
            return DEFAULT_GREETING;
        }
        String safe = name.replaceAll("[^A-Za-z0-9 ]", "").trim();
        if (safe.length() > MAX_NAME_LENGTH) {
            safe = safe.substring(0, MAX_NAME_LENGTH);
        }
        return safe.isEmpty() ? DEFAULT_GREETING : "Hello, " + safe + "!";
    }
}
