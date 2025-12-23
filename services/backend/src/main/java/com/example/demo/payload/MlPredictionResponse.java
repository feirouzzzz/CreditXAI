package com.example.demo.payload;

import lombok.Data;

@Data
public class MlPredictionResponse {

    private Integer prediction;
    private String prediction_label;
    private Double probability_rejected;
    private Double probability_approved;
    private Double confidence;
    private Double risk_score;
}