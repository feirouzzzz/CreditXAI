package com.example.demo.config;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MinioConfig {

    @Value("${minio.endpoint}")
    private String endpoint;

    @Value("${minio.access-key}")
    private String accessKey;

    @Value("${minio.secret-key}")
    private String secretKey;

    @Bean
    public MinioClient minioClient() throws Exception {
        MinioClient client = MinioClient.builder()
                .endpoint(endpoint)
                .credentials(accessKey, secretKey)
                .build();

        // ✅ Ensure bucket exists (integration-test safe)
        boolean exists = client.bucketExists(
                io.minio.BucketExistsArgs.builder()
                        .bucket("user-files")
                        .build()
        );

        if (!exists) {
            client.makeBucket(
                    io.minio.MakeBucketArgs.builder()
                            .bucket("user-files")
                            .build()
            );
        }

        return client;
    }
}
