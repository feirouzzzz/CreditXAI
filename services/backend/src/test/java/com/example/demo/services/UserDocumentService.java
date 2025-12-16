package com.example.demo.services;

import com.example.demo.entities.User;
import com.example.demo.entities.UserDocument;
import com.example.demo.entities.UserDocument.DocumentType;
import com.example.demo.entities.UserDocument.DocumentStatus;
import com.example.demo.repositories.UserDocumentRepository;
import com.example.demo.repositories.UserRepository;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserDocumentServiceTest {

    @InjectMocks
    private UserDocumentService documentService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserDocumentRepository documentRepository;

    @Mock
    private MinioClient minioClient;

    @Mock
    private MultipartFile file;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testUploadDocumentSuccess() throws Exception {
        User user = new User();
        user.setId(1L);

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(file.isEmpty()).thenReturn(false);
        when(file.getInputStream()).thenReturn(new ByteArrayInputStream(new byte[]{1,2,3}));
        when(file.getSize()).thenReturn(3L);
        when(file.getContentType()).thenReturn("application/pdf");

        Map<String, Object> result = documentService.uploadDocument(1L, file, DocumentType.PAYSLIP);

        assertTrue((Boolean) result.get("success"));
        assertEquals("Document uploaded successfully", result.get("message"));
        verify(documentRepository).save(any(UserDocument.class));
        verify(minioClient).putObject(any(PutObjectArgs.class));
    }

    @Test
    void testGetAllDocumentsByUser() {
        User user = new User();
        user.setId(1L);

        UserDocument doc1 = new UserDocument();
        doc1.setId(1L);
        doc1.setUser(user);
        doc1.setType(DocumentType.PAYSLIP);
        doc1.setFilePath("/files/pay.pdf");
        doc1.setStatus(DocumentStatus.PENDING);
        doc1.setUploadedAt(LocalDateTime.now());

        when(documentRepository.findByUserId(1L)).thenReturn(List.of(doc1));

        List<Map<String, Object>> docs = documentService.getAllDocumentsByUser(1L);

        assertEquals(1, docs.size());
        assertEquals(DocumentType.PAYSLIP, docs.get(0).get("type"));
        assertEquals("/files/pay.pdf", docs.get(0).get("filePath"));
    }
}
