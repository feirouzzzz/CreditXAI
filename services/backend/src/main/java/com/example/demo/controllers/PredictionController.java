package com.example.demo.controllers;

import com.example.demo.payload.MlPredictionRequest;
import com.example.demo.payload.MlPredictionResponse;
import com.example.demo.services.MlPredictionService;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/predictions")
@RequiredArgsConstructor
public class PredictionController {

    private final MlPredictionService mlPredictionService;

    @PostMapping
    public MlPredictionResponse predict(@RequestBody MlPredictionRequest request) {
        return mlPredictionService.predict(request);
    }
}