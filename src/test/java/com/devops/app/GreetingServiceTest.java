package com.devops.app;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class GreetingServiceTest {

    private final GreetingService service = new GreetingService();

    @Test
    void returnsDefaultWhenNameIsNull() {
        assertEquals(GreetingService.DEFAULT_GREETING, service.greet(null));
    }

    @Test
    void returnsDefaultWhenNameIsBlank() {
        assertEquals(GreetingService.DEFAULT_GREETING, service.greet("   "));
    }

    @Test
    void greetsByName() {
        assertEquals("Hello, Surya!", service.greet("Surya"));
    }

    @Test
    void stripsSpecialCharacters() {
        assertEquals("Hello, scriptalert1script!", service.greet("<script>alert(1)</script>"));
    }

    @Test
    void returnsDefaultWhenOnlySpecialCharacters() {
        assertEquals(GreetingService.DEFAULT_GREETING, service.greet("!!!"));
    }
}
