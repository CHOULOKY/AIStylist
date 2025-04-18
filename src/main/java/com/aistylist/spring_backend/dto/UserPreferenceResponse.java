package com.aistylist.spring_backend.dto;

import lombok.Getter;

@Getter
public class UserPreferenceResponse {
    // Getter
    private final String preferredStyle;
    private final String preferredColor;
    private final String avoidStyle;
    private final String bodyType;

    public UserPreferenceResponse(String preferredStyle, String preferredColor, String avoidStyle, String bodyType) {
        this.preferredStyle = preferredStyle;
        this.preferredColor = preferredColor;
        this.avoidStyle = avoidStyle;
        this.bodyType = bodyType;
    }

}