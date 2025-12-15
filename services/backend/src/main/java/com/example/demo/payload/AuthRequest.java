package com.example.demo.payload;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class AuthRequest {

    @Schema(example = "soulaimane@example.com")
    private String email;

    @Schema(example = "Soulaimane")
    private String username;

    @Schema(example = "password123")
    private String password;
}
