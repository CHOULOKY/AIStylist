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

    /**
     * 이미지 URL을 실제 파일 시스템 경로로 변환
     * @param imageUrl DB에 저장된 이미지 URL
     * @return 실제 파일 시스템 경로
     */
    public String getFilePath(String imageUrl) {
        if (imageUrl == null || imageUrl.isEmpty()) {
            throw new RuntimeException("이미지 URL이 비어있습니다.");
        }

        // URL에서 파일명 추출
        String fileName = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
        
        // 실제 파일 경로 생성
        Path filePath = this.fileStorageLocation.resolve(fileName);
        
        // 파일이 존재하는지 확인
        if (!Files.exists(filePath)) {
            throw new RuntimeException("파일을 찾을 수 없습니다: " + fileName);
        }

        return filePath.toString();
    }
} 