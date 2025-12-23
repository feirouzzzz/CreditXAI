package com.example.demo.user;

import com.example.demo.entities.User;
import com.example.demo.entities.UserDocument;
import com.example.demo.entities.UserDocument.DocumentType;
import com.example.demo.integration.AbstractIntegrationTest;
import com.example.demo.repositories.UserDocumentRepository;
import com.example.demo.repositories.UserRepository;
import com.example.demo.services.UserDocumentService;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class UserDocumentFlowIT extends AbstractIntegrationTest {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserDocumentRepository documentRepository;

    @Autowired
    private UserDocumentService documentService;

    @Test
    void full_document_flow_should_work() throws Exception {

        // ======================
        // CREATE USER
        // ======================
        User user = new User();
        user.setEmail("doc" + System.currentTimeMillis() + "@mail.com");
        user.setUsername("doc_user");
        user.setPassword("pwd");
        user.setIdentityVerified(true);

        user = userRepository.save(user);

        // ======================
        // UPLOAD DOCUMENT
        // ======================
        MockMultipartFile file =
                new MockMultipartFile(
                        "file",
                        "salary.pdf",
                        "application/pdf",
                        "fake-pdf-content".getBytes()
                );

        Map<String, Object> upload =
                documentService.uploadDocument(
                        user.getId(),
                        file,
                        DocumentType.PAYSLIP
                );

        assertThat(upload.get("success")).isEqualTo(true);
        assertThat(upload.get("status")).isEqualTo("PENDING");
        assertThat(upload.get("type")).isEqualTo("PAYSLIP");

        // // ======================
        // // DB ASSERTIONS
        // // ======================
        List<UserDocument> documents =
                documentRepository.findByUserId(user.getId());

        assertThat(documents).hasSize(1);

        UserDocument doc = documents.get(0);
        assertThat(doc.getUser().getId()).isEqualTo(user.getId());
        assertThat(doc.getType()).isEqualTo(DocumentType.PAYSLIP);
        assertThat(doc.getStatus()).isEqualTo(UserDocument.DocumentStatus.PENDING);
        assertThat(doc.getFilePath()).contains("documents/" + user.getId());

        // // ======================
        // // FETCH DOCUMENTS
        // // ======================
        List<Map<String, Object>> fetched =
                documentService.getAllDocumentsByUser(user.getId());

        assertThat(fetched).hasSize(1);
        assertThat(fetched.get(0).get("filePath"))
                .isEqualTo(doc.getFilePath());
    }
}
