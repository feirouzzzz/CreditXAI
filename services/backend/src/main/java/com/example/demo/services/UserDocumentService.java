package com.example.demo.services;

import com.example.demo.entities.*;
import com.example.demo.entities.UserDocument.DocumentStatus;
import com.example.demo.entities.UserDocument.DocumentType;
import com.example.demo.repositories.UserDocumentRepository;
import com.example.demo.repositories.UserRepository;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserDocumentService {

    private final UserRepository userRepository;
    private final UserDocumentRepository documentRepository;
    private final MinioClient minioClient;

    public Map<String, Object> uploadDocument(
            Long userId,
            MultipartFile file,
            DocumentType type
    ) {

        User user = userRepository.findById(userId).orElse(null);
        if (user == null)
            return Map.of("success", false, "message", "User not found");

        if (file == null || file.isEmpty())
            return Map.of("success", false, "message", "File is required");

        try {
            String objectPath =
                    "documents/" + userId + "/" +
                    type.name().toLowerCase() + "_" +
                    System.currentTimeMillis();

            minioClient.putObject(
                    PutObjectArgs.builder()
                            .bucket("user-files")
                            .object(objectPath)
                            .stream(file.getInputStream(), file.getSize(), -1)
                            .contentType(file.getContentType())
                            .build()
            );

            UserDocument doc = new UserDocument();
            doc.setUser(user);
            doc.setType(type);
            doc.setFilePath(objectPath);
            doc.setStatus(DocumentStatus.PENDING);
            doc.setUploadedAt(LocalDateTime.now());

            documentRepository.save(doc);

            return Map.of(
                    "success", true,
                    "message", "Document uploaded successfully",
                    "type", type.name(),
                    "status", "PENDING"
            );

        } catch (Exception e) {
            return Map.of("success", false, "message", "Upload failed");
        }
    }


    public List<Map<String, Object>> getAllDocumentsByUser(Long userId) {
    List<UserDocument> documents = documentRepository.findByUserId(userId);

    return documents.stream()
            .map(doc -> {
                Map<String, Object> map = new HashMap<>();
                map.put("id", doc.getId());
                map.put("type", doc.getType());
                map.put("filePath", doc.getFilePath());
                map.put("uploadedAt", doc.getUploadedAt());
                return map;
            })
            .collect(Collectors.toList());
    }
}
