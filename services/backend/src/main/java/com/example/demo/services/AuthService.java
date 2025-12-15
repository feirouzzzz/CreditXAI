package com.example.demo.services;

import com.example.demo.entities.User;
import com.example.demo.repositories.UserRepository;
import com.example.demo.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public Map<String, Object> register(String email, String username, String password) {

        Map<String, Object> response = new HashMap<>();

        if (userRepository.findByEmail(email).isPresent()) {
            response.put("success", false);
            response.put("message", "Email already exists");
            return response;
        }

        User user = new User(null, email, username, encoder.encode(password));
        userRepository.save(user);

        response.put("success", true);
        response.put("message", "User registered successfully");
        response.put("id", user.getId());
        response.put("email", user.getEmail());
        response.put("username", user.getUsername());
        response.put("token", jwtUtil.generateToken(user));

        return response;
    }

    public Map<String, Object> login(String email, String password) {

        Map<String, Object> response = new HashMap<>();
        Optional<User> optionalUser = userRepository.findByEmail(email);

        if (optionalUser.isEmpty()) {
            response.put("success", false);
            response.put("message", "User not found");
            return response;
        }

        User user = optionalUser.get();

        if (!encoder.matches(password, user.getPassword())) {
            response.put("success", false);
            response.put("message", "Invalid credentials");
            return response;
        }

        response.put("success", true);
        response.put("message", "Login successful");
        response.put("id", user.getId());
        response.put("email", user.getEmail());
        response.put("username", user.getUsername());
        response.put("token", jwtUtil.generateToken(user));

        return response;
    }
}
