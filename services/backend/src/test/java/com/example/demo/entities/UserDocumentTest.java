package com.example.demo.entities;

import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

class UserDocumentTest {

    @Test
    void testUserDocumentSettersAndGetters() {
        User user = new User(1L, "test@example.com", "testuser", "password123", false, "CIN123", "/path/to/cin.jpg");

        UserDocument document = new UserDocument();
        document.setId(100L);
        document.setUser(user);
        document.setType(UserDocument.DocumentType.PAYSLIP);
        document.setFilePath("/uploads/payslip.pdf");
        document.setStatus(UserDocument.DocumentStatus.PENDING);
        document.setUploadedAt(LocalDateTime.now());

        assertEquals(100L, document.getId());
        assertEquals(user, document.getUser());
        assertEquals(UserDocument.DocumentType.PAYSLIP, document.getType());
        assertEquals("/uploads/payslip.pdf", document.getFilePath());
        assertEquals(UserDocument.DocumentStatus.PENDING, document.getStatus());
        assertNotNull(document.getUploadedAt());
    }

    @Test
    void testAllArgsConstructor() {
        User user = new User(2L, "abc@example.com", "abcuser", "pass123", true, "CIN456", "/path/cin2.jpg");
        LocalDateTime now = LocalDateTime.now();

        UserDocument document = new UserDocument(
                1L,
                user,
                UserDocument.DocumentType.TAX_DECLARATION,
                "/uploads/tax.pdf",
                UserDocument.DocumentStatus.APPROVED,
                now
        );

        assertEquals(1L, document.getId());
        assertEquals(user, document.getUser());
        assertEquals(UserDocument.DocumentType.TAX_DECLARATION, document.getType());
        assertEquals("/uploads/tax.pdf", document.getFilePath());
        assertEquals(UserDocument.DocumentStatus.APPROVED, document.getStatus());
        assertEquals(now, document.getUploadedAt());
    }

    @Test
    void testEnumValues() {
        assertEquals("PAYSLIP", UserDocument.DocumentType.PAYSLIP.name());
        assertEquals("APPROVED", UserDocument.DocumentStatus.APPROVED.name());
    }
}
