package com.example.demo.services;

import com.example.demo.entities.User;
import com.example.demo.repositories.UserRepository;
import com.example.demo.security.JwtUtil;
import io.minio.MinioClient;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;
import java.util.Optional;
import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class AuthServiceTest {

    @InjectMocks
    private AuthService authService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private JwtUtil jwtUtil;

    @Mock
    private MinioClient minioClient;

    @Mock
    private MultipartFile photo;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testRegisterSuccess() {
        when(userRepository.findByEmail("test@example.com")).thenReturn(Optional.empty());

        // Mock save to set an ID
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User u = invocation.getArgument(0);
            u.setId(1L); // simulate DB auto-generated ID
            return u;
        });

        Map<String, Object> result = authService.register("test@example.com", "user", "pass");

        assertTrue((Boolean) result.get("success"));
        assertEquals("User registered successfully", result.get("message"));
        assertFalse((Boolean) result.get("identityVerified"));
        assertEquals(1L, result.get("id")); // now works
        verify(userRepository).save(any(User.class));
    }


    @Test
    void testRegisterEmailExists() {
        when(userRepository.findByEmail("test@example.com"))
                .thenReturn(java.util.Optional.of(new User()));

        Map<String, Object> result = authService.register("test@example.com", "user", "pass");

        assertFalse((Boolean) result.get("success"));
        assertEquals("Email already exists", result.get("message"));
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void testLoginSuccessVerified() {
        User user = new User();
        user.setId(1L);
        user.setEmail("test@example.com");
        user.setUsername("user");
        user.setPassword(new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder().encode("pass"));
        user.setIdentityVerified(true);

        when(userRepository.findByEmail("test@example.com")).thenReturn(java.util.Optional.of(user));
        when(jwtUtil.generateToken(user)).thenReturn("token123");

        Map<String, Object> result = authService.login("test@example.com", "pass");

        assertTrue((Boolean) result.get("success"));
        assertEquals("Login successful", result.get("message"));
        assertEquals("token123", result.get("token"));
    }

    @Test
    void testVerifyCinUserNotFound() {
        when(userRepository.findById(1L)).thenReturn(java.util.Optional.empty());
        Map<String, Object> result = authService.verifyCin(1L, photo);
        assertFalse((Boolean) result.get("success"));
        assertEquals("User not found", result.get("message"));
    }

    @Test
    void testVerifyCinSuccess() throws Exception {
        User user = new User();
        user.setId(1L);

        when(userRepository.findById(1L)).thenReturn(java.util.Optional.of(user));
        when(photo.isEmpty()).thenReturn(false);
        when(photo.getInputStream()).thenReturn(new ByteArrayInputStream(new byte[]{1,2,3}));
        when(photo.getSize()).thenReturn(3L);
        when(photo.getContentType()).thenReturn("image/jpeg");
        when(jwtUtil.generateToken(user)).thenReturn("token123");

        Map<String, Object> result = authService.verifyCin(1L, photo);

        assertTrue((Boolean) result.get("success"));
        assertEquals("Identity verified successfully", result.get("message"));
        assertEquals("token123", result.get("token"));
        assertEquals(true, user.isIdentityVerified());
        verify(userRepository).save(user);
    }
}
