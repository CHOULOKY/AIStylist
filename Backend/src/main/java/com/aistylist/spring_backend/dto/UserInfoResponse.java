package com.aistylist.spring_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import com.aistylist.spring_backend.domain.BodyType;

@Getter
@AllArgsConstructor
public class UserInfoResponse {
    private String name;
    private Integer height;
    private BodyType bodyType;
}