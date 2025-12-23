package com.example.demo.entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "user_documents")
public class UserDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    private DocumentType type;

    private String filePath;

    @Enumerated(EnumType.STRING)
    private DocumentStatus status;


    private LocalDateTime uploadedAt;



    public enum DocumentType {
        // Income & Employment
        PAYSLIP,
        TAX_DECLARATION,

        // Financial Activity
        INCOME_CONSISTENCY,

        // Loan History
        LOAN_PAYMENTS,

        // Business Docs
        BUSINESS_REGISTRATION,
        BUSINESS_INCOME_DECLARATION
    }

    public enum DocumentStatus {
        PENDING,
        APPROVED,
        REJECTED
    }

}


