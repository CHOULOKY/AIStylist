package com.aistylist.spring_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class UserInfoResponse {
    private String name;
    private Integer height;
    private String bodyType;
}