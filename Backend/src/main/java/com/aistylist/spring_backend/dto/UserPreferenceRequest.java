package com.aistylist.spring_backend.dto;

public class UserPreferenceRequest {
    private String preferredStyle;
    private String preferredColor;
    private String avoidStyle;

    // Getter & Setter
    public String getPreferredStyle() {
        return preferredStyle;
    }

    public void setPreferredStyle(String preferredStyle) {
        this.preferredStyle = preferredStyle;
    }

    public String getPreferredColor() {
        return preferredColor;
    }

    public void setPreferredColor(String preferredColor) {
        this.preferredColor = preferredColor;
    }

    public String getAvoidStyle() {
        return avoidStyle;
    }

    public void setAvoidStyle(String avoidStyle) {
        this.avoidStyle = avoidStyle;
    }

}
