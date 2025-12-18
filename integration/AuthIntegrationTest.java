package com.example.demo.integration;

import com.example.demo.DemoApplication;
import com.example.demo.payload.AuthRequest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.*;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(
        classes = DemoApplication.class,
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = "spring.profiles.active=integration"
)
public class AuthIntegrationTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void testRegisterAndLogin() {
        // ===== Register =====
        AuthRequest registerReq = new AuthRequest();
        registerReq.setEmail("inttest@example.com");
        registerReq.setUsername("intuser");
        registerReq.setPassword("password123");

        ResponseEntity<?> registerResp = restTemplate.postForEntity(
                "/auth/register",
                registerReq,
                Object.class
        );

        assertEquals(HttpStatus.OK, registerResp.getStatusCode());
        assertNotNull(registerResp.getBody());

        // ===== Login =====
        AuthRequest loginReq = new AuthRequest();
        loginReq.setEmail("inttest@example.com");
        loginReq.setPassword("password123");

        ResponseEntity<?> loginResp = restTemplate.postForEntity(
                "/auth/login",
                loginReq,
                Object.class
        );

        assertEquals(HttpStatus.OK, loginResp.getStatusCode());
        assertNotNull(loginResp.getBody());
    }
}
