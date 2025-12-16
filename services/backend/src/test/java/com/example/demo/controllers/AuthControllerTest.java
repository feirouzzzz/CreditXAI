package com.example.demo.controllers;

import com.example.demo.payload.AuthRequest;
import com.example.demo.services.AuthService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.ObjectMapper;

@WebMvcTest(AuthController.class)
@AutoConfigureMockMvc(addFilters = false)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AuthService authService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void testRegister() throws Exception {
        AuthRequest req = new AuthRequest();
        req.setEmail("test@example.com");
        req.setUsername("testuser");
        req.setPassword("pass123");

        Map<String, Object> mockResponse = Map.of(
                "success", true,
                "message", "User registered successfully",
                "id", 1L,
                "identityVerified", false
        );

        when(authService.register(anyString(), anyString(), anyString()))
                .thenReturn(mockResponse);

        mockMvc.perform(post("/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value("User registered successfully"))
                .andExpect(jsonPath("$.id").value(1));
    }

    @Test
    void testLogin() throws Exception {
        AuthRequest req = new AuthRequest();
        req.setEmail("test@example.com");
        req.setPassword("pass123");

        Map<String, Object> mockResponse = Map.of(
                "success", true,
                "message", "Login successful",
                "id", 1L,
                "username", "testuser"
        );

        when(authService.login(anyString(), anyString())).thenReturn(mockResponse);

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value("Login successful"))
                .andExpect(jsonPath("$.username").value("testuser"));
    }
}
