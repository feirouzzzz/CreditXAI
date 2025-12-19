package com.example.demo.client;

import com.example.demo.payload.MlPredictionRequest;
import com.example.demo.payload.MlPredictionResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

@Component
@RequiredArgsConstructor
public class MlClient {

    private final WebClient webClient;

    @Value("${ml.service.url}")
    private String mlServiceUrl;

    public MlPredictionResponse predict(MlPredictionRequest request) {
        return webClient.post()
                .uri(mlServiceUrl + "/predict")
                .bodyValue(request)
                .retrieve()
                .bodyToMono(MlPredictionResponse.class)
                .block();
    }
}