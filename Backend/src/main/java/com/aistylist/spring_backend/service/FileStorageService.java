package com.aistylist.spring_backend.service;

import com.aistylist.spring_backend.config.FileStorageConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageService {

    private final Path fileStorageLocation;

    @Autowired
    public FileStorageService(FileStorageConfig fileStorageConfig) {
        this.fileStorageLocation = fileStorageConfig.getUploadPath();
        try {
            Files.createDirectories(this.fileStorageLocation);
        } catch (IOException ex) {
            throw new RuntimeException("파일 업로드를 위한 디렉토리를 생성할 수 없습니다.", ex);
        }
    }

    public String storeFile(MultipartFile file) {
        // 원본 파일명에서 확장자 추출
        String originalFileName = StringUtils.cleanPath(file.getOriginalFilename());
        String fileExtension = "";
        
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex > 0) {
            fileExtension = originalFileName.substring(dotIndex);
        }
        
        // 고유한 파일명 생성 (UUID + 확장자)
        String fileName = UUID.randomUUID().toString() + fileExtension;

        try {
            // 파일명에 부적절한 문자가 있는지 확인
            if (fileName.contains("..")) {
                throw new RuntimeException("파일명에 부적절한 문자가 포함되어 있습니다: " + fileName);
            }

            // 파일 저장
            Path targetLocation = this.fileStorageLocation.resolve(fileName);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

            // 파일에 접근할 수 있는 URL 생성
            String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/uploads/")
                    .path(fileName)
                    .toUriString();

            return fileDownloadUri;
        } catch (IOException ex) {
            throw new RuntimeException("파일 " + fileName + " 저장 실패", ex);
        }
    }
} 