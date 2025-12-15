package com.example.demo.controllers;

import com.example.demo.payload.AuthRequest;
import com.example.demo.services.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody AuthRequest request) {

        Map<String, Object> response = authService.register(
                request.getEmail(),
                request.getUsername(),
                request.getPassword()
        );

        if (!(boolean) response.get("success")) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body(response);
        }

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody AuthRequest request) {

        Map<String, Object> response = authService.login(
                request.getEmail(),
                request.getPassword()
        );

        if (!(boolean) response.get("success")) {
            HttpStatus status =
                    response.get("message").equals("User not found")
                            ? HttpStatus.NOT_FOUND
                            : HttpStatus.UNAUTHORIZED;

            return ResponseEntity.status(status).body(response);
        }

        return ResponseEntity.ok(response);
    }
}
