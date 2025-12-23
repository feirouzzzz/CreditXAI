package com.example.demo.user;

import com.example.demo.entities.User;
import com.example.demo.repositories.UserRepository;
import com.example.demo.services.AuthService;
import com.example.demo.integration.AbstractIntegrationTest;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class UserFlowIT extends AbstractIntegrationTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Test
    void full_user_flow_should_work() throws Exception {

        // ======================
        // REGISTER
        // ======================
        String email = "test" + System.currentTimeMillis() + "@mail.com";

        Map<String, Object> register =
                authService.register(
                        email,
                        "test",
                        "password123"
                );

        assertThat(register.get("success")).isEqualTo(true);
        Long userId = ((Number) register.get("id")).longValue();

        User user = userRepository.findById(userId).orElseThrow();
        assertThat(user.isIdentityVerified()).isFalse();

        // ======================
        // LOGIN (before CIN)
        // ======================
        Map<String, Object> loginBefore =
                authService.login(email, "password123");

        assertThat(loginBefore.get("success")).isEqualTo(true);
        assertThat(loginBefore.get("token")).isNull();

        // ======================
        // VERIFY CIN (MinIO)
        // ======================
        MockMultipartFile cinPhoto =
                new MockMultipartFile(
                        "photo",
                        "cin.jpg",
                        "image/jpeg",
                        "fake-image-content".getBytes()
                );

        Map<String, Object> verify =
                authService.verifyCin(userId, cinPhoto);

        assertThat(verify.get("success")).isEqualTo(true);
        assertThat(verify.get("cinPath")).isNotNull();
        assertThat(verify.get("token")).isNotNull();

        // ======================
        // LOGIN (after CIN)
        // ======================
        Map<String, Object> loginAfter =
                authService.login(email, "password123");

        assertThat(loginAfter.get("success")).isEqualTo(true);
        assertThat(loginAfter.get("token")).isNotNull();
        assertThat(loginAfter.get("identityVerified")).isEqualTo(true);
    }
}
