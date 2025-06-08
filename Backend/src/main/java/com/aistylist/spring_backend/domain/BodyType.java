package com.aistylist.spring_backend.domain;

public enum BodyType {
    SLIM("마른"),
    ATHLETIC("운동"),
    AVERAGE("보통"),
    CHUBBY("통통"),
    OVERWEIGHT("비만");

    private final String displayName;

    BodyType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static BodyType fromDisplayName(String displayName) {
        for (BodyType type : values()) {
            if (type.displayName.equals(displayName)) {
                return type;
            }
        }
        return null;
    }
}
