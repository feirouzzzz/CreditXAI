package com.example.demo.repositories;

import com.example.demo.entities.User;
import com.example.demo.entities.UserDocument;
import com.example.demo.entities.UserDocument.DocumentType;
import com.example.demo.entities.UserDocument.DocumentStatus;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
class UserDocumentRepositoryTest {

    @Autowired
    private UserDocumentRepository documentRepository;

    @Autowired
    private UserRepository userRepository;

    @Test
    void testSaveAndFindByUserId() {
        // Create a user
        User user = new User();
        user.setEmail("user@example.com");
        user.setUsername("user1");
        user.setPassword("pass");
        userRepository.save(user);

        // Create documents
        UserDocument doc1 = new UserDocument();
        doc1.setUser(user);
        doc1.setType(DocumentType.PAYSLIP);
        doc1.setStatus(DocumentStatus.PENDING);
        doc1.setFilePath("/files/pay1.pdf");
        doc1.setUploadedAt(LocalDateTime.now());

        UserDocument doc2 = new UserDocument();
        doc2.setUser(user);
        doc2.setType(DocumentType.TAX_DECLARATION);
        doc2.setStatus(DocumentStatus.PENDING);
        doc2.setFilePath("/files/tax1.pdf");
        doc2.setUploadedAt(LocalDateTime.now());

        documentRepository.save(doc1);
        documentRepository.save(doc2);

        // Fetch by user ID
        List<UserDocument> docs = documentRepository.findByUserId(user.getId());
        assertEquals(2, docs.size());
        assertTrue(docs.stream().anyMatch(d -> d.getType() == DocumentType.PAYSLIP));
        assertTrue(docs.stream().anyMatch(d -> d.getType() == DocumentType.TAX_DECLARATION));
    }

    @Test
    void testFindByUserIdNoDocuments() {
        List<UserDocument> docs = documentRepository.findByUserId(999L);
        assertTrue(docs.isEmpty());
    }
}
