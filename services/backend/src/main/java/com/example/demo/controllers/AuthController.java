package com.example.demo.controllers;

import com.example.demo.payload.AuthRequest;
import com.example.demo.services.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody AuthRequest req) {
        return ResponseEntity.ok(
                authService.register(req.getEmail(), req.getUsername(), req.getPassword())
        );
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody AuthRequest req) {
        return ResponseEntity.ok(
                authService.login(req.getEmail(), req.getPassword())
        );
    }

    @PostMapping("/verify-cin")
    public ResponseEntity<Map<String, Object>> verifyCin(
            @RequestParam Long userId,
            @RequestParam String cin
    ) {
        return ResponseEntity.ok(
                authService.verifyCin(userId, cin)
        );
    }
}
