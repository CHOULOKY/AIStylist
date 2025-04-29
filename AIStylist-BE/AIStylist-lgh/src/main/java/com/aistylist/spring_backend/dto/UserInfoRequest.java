package com.aistylist.spring_backend.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserInfoRequest {
    private String name;
    private Integer height;
    private String bodyType;
}