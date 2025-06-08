package com.aistylist.spring_backend.domain;

/**
 * 옷 계절을 정의하는 enum
 */
public enum ClothesSeason {
    ALL("모두"),
    SPRING("봄"),
    SUMMER("여름"),
    FALL("가을"),
    WINTER("겨울");
    
    private final String displayName;
    
    ClothesSeason(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    /**
     * 표시 이름으로부터 enum 값을 찾습니다.
     * @param displayName 표시 이름
     * @return 해당하는 enum 값, 없으면 null
     */
    public static ClothesSeason fromDisplayName(String displayName) {
        for (ClothesSeason season : values()) {
            if (season.displayName.equals(displayName)) {
                return season;
            }
        }
        return null;
    }
} 