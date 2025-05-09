package com.aistylist.spring_backend.dto;

import lombok.Getter;
import lombok.Setter;
import com.aistylist.spring_backend.domain.BodyType;

@Getter
@Setter
public class UserInfoRequest {
    private String name;
    private Integer height;
    private BodyType bodyType;
}