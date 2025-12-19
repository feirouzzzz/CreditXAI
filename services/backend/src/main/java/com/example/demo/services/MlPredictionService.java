package com.example.demo.services;

import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.payload.MlPredictionRequest;
import com.example.demo.payload.MlPredictionResponse;

@Service
@RequiredArgsConstructor
public class MlPredictionService {

    private final WebClient webClient;

    public MlPredictionResponse predict(MlPredictionRequest request) {

        return webClient.post()
                .uri("/predict")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(request)
                .retrieve()
                .bodyToMono(MlPredictionResponse.class)
                .block(); // blocking is OK here
    }
}