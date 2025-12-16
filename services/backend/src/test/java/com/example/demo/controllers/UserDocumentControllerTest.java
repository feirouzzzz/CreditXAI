package com.example.demo.controllers;

import com.example.demo.entities.UserDocument.DocumentType;
import com.example.demo.services.UserDocumentService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;
import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(UserDocumentController.class)
@AutoConfigureMockMvc(addFilters = false)
class UserDocumentControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserDocumentService documentService;

    @Test
    void testUploadDocument() throws Exception {
        MockMultipartFile file = new MockMultipartFile(
                "file", "test.pdf", "application/pdf", "dummy content".getBytes()
        );

        when(documentService.uploadDocument(1L, file, DocumentType.PAYSLIP))
                .thenReturn(Map.of("success", true, "message", "Document uploaded successfully"));

        mockMvc.perform(multipart("/documents/upload")
                        .file(file)
                        .param("userId", "1")
                        .param("type", "PAYSLIP"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value("Document uploaded successfully"));
    }

    @Test
    void testGetUserDocuments() throws Exception {
        List<Map<String, Object>> mockDocs = List.of(
                Map.of("id", 1, "type", "PAYSLIP", "filePath", "/path/to/file", "uploadedAt", "2025-12-16T11:00:00")
        );

        when(documentService.getAllDocumentsByUser(1L)).thenReturn(mockDocs);

        mockMvc.perform(get("/documents/user/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].type").value("PAYSLIP"));
    }
}
