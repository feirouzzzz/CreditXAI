package com.example.demo.payload;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class AuthRequest {

    @Schema(example = "test@gmail.com")
    private String email;

    @Schema(example = "Test")
    private String username;

    @Schema(example = "1234")
    private String password;
}
