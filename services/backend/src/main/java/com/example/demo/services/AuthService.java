package com.example.demo.services;

import com.example.demo.entities.User;
import com.example.demo.repositories.UserRepository;
import com.example.demo.security.JwtUtil;

import io.minio.MinioClient;
import io.minio.PutObjectArgs;

import lombok.RequiredArgsConstructor;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final MinioClient minioClient; // ✅ REQUIRED

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    // ======================
    // REGISTER
    // ======================
    public Map<String, Object> register(String email, String username, String password) {

        if (userRepository.findByEmail(email).isPresent()) {
            return Map.of(
                    "success", false,
                    "message", "Email already exists"
            );
        }

        User user = new User();
        user.setEmail(email);
        user.setUsername(username);
        user.setPassword(encoder.encode(password));
        user.setIdentityVerified(false);

        userRepository.save(user);

        return Map.of(
                "success", true,
                "message", "User registered successfully",
                "id", user.getId(),
                "identityVerified", false
        );
    }

    // ======================
    // LOGIN
    // ======================
    public Map<String, Object> login(String email, String password) {

        User user = userRepository.findByEmail(email).orElse(null);

        if (user == null) {
            return Map.of("success", false, "message", "User not found");
        }

        if (!encoder.matches(password, user.getPassword())) {
            return Map.of("success", false, "message", "Invalid password");
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("id", user.getId());
        response.put("email", user.getEmail());
        response.put("username", user.getUsername());
        response.put("identityVerified", user.isIdentityVerified());

        if (user.isIdentityVerified()) {
            response.put("message", "Login successful");
            response.put("token", jwtUtil.generateToken(user));
        } else {
            response.put("message", "Identity verification required");
        }

        return response;
    }

    // ======================
    // VERIFY CIN (PHOTO → MINIO)
    // ======================
    public Map<String, Object> verifyCin(Long userId, MultipartFile photo) {

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return Map.of("success", false, "message", "User not found");
        }

        if (photo == null || photo.isEmpty()) {
            return Map.of("success", false, "message", "CIN photo is required");
        }

        try {
            // 📁 Object path in MinIO
            String objectName =
                    "cin/" + userId + "_cin_" + System.currentTimeMillis() + ".jpg";

            // ☁️ Upload to MinIO
            minioClient.putObject(
                    PutObjectArgs.builder()
                            .bucket("users") // bucket must exist
                            .object(objectName)
                            .stream(
                                    photo.getInputStream(),
                                    photo.getSize(),
                                    -1
                            )
                            .contentType(photo.getContentType())
                            .build()
            );

            // 💾 Save info in DB
            user.setCinPhoto(objectName);
            user.setIdentityVerified(true); // auto-verified for now
            userRepository.save(user);

            return Map.of(
                    "success", true,
                    "message", "Identity verified successfully",
                    "id", user.getId(),
                    "identityVerified", true,
                    "cinPath", objectName,
                    "token", jwtUtil.generateToken(user)
            );

        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("success", false, "message", "Photo upload failed");
        }
    }
}
