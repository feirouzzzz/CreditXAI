package com.example.demo.payload;

import com.fasterxml.jackson.annotation.JsonProperty;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class MlPredictionRequest {

    @JsonProperty("Age")
    @Schema(example = "35")
    private Integer age;
    
    @JsonProperty("Checking account")
    @Schema(example = "little")
    private String checkingAccount;
    
    @JsonProperty("Credit_amount")
    @Schema(example = "5000")
    private Integer creditAmount;
    
    @JsonProperty("Duration")
    @Schema(example = "24")
    private Integer duration;
    
    @JsonProperty("Housing")
    @Schema(example = "own")
    private String housing;
    
    @JsonProperty("Job")
    @Schema(example = "2")
    private Integer job;
    
    @JsonProperty("Purpose")
    @Schema(example = "car")
    private String purpose;
    
    @JsonProperty("Saving accounts")
    @Schema(example = "moderate")
    private String savingAccounts;
    
    @JsonProperty("Sex")
    @Schema(example = "male")
    private String sex;
}