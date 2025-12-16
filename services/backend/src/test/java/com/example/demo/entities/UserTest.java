package com.example.demo.entities;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class UserTest {

    @Test
    void testUserSettersAndGetters() {
        User user = new User();

        user.setId(1L);
        user.setEmail("test@example.com");
        user.setUsername("testuser");
        user.setPassword("password123");
        user.setIdentityVerified(true);
        user.setCin("CIN123456");
        user.setCinPhoto("/path/to/photo.jpg");

        assertEquals(1L, user.getId());
        assertEquals("test@example.com", user.getEmail());
        assertEquals("testuser", user.getUsername());
        assertEquals("password123", user.getPassword());
        assertTrue(user.isIdentityVerified());
        assertEquals("CIN123456", user.getCin());
        assertEquals("/path/to/photo.jpg", user.getCinPhoto());
    }

    @Test
    void testDefaultIdentityVerified() {
        User user = new User();
        assertFalse(user.isIdentityVerified(), "identityVerified should be false by default");
    }

    @Test
    void testAllArgsConstructor() {
        User user = new User(
                1L,
                "test@example.com",
                "testuser",
                "password123",
                true,
                "CIN123456",
                "/path/to/photo.jpg"
        );

        assertEquals(1L, user.getId());
        assertEquals("test@example.com", user.getEmail());
        assertEquals("testuser", user.getUsername());
        assertEquals("password123", user.getPassword());
        assertTrue(user.isIdentityVerified());
        assertEquals("CIN123456", user.getCin());
        assertEquals("/path/to/photo.jpg", user.getCinPhoto());
    }
}
