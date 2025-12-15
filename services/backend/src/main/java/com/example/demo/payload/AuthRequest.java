package com.example.demo.payload;

import lombok.Data;

@Data
public class AuthRequest {
    private String email;
    private String username; // only for register
    private String password;
}
