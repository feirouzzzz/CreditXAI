package com.example.demo.controllers;

import com.example.demo.entities.UserDocument.DocumentType;
import com.example.demo.services.UserDocumentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.MediaType;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/documents")
@RequiredArgsConstructor
public class UserDocumentController {

    private final UserDocumentService documentService;

    @PostMapping(
            value = "/upload",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    public Map<String, Object> upload(
            @RequestParam Long userId,
            @RequestParam DocumentType type,
            @RequestPart MultipartFile file
    ) {
        return documentService.uploadDocument(userId, file, type);
    }

    @GetMapping("/user/{userId}")
    public List<Map<String, Object>> getUserDocuments(@PathVariable Long userId) {
        return documentService.getAllDocumentsByUser(userId);
    }
}


