package com.aistylist.spring_backend.domain;

/**
 * 옷 카테고리를 정의하는 enum
 */
public enum ClothesCategory {
    TOP("상의"),
    BOTTOM("하의"),
    OUTER("아우터"),
    SHOES("신발");
    
    private final String displayName;
    
    ClothesCategory(String displayName) {
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
    public static ClothesCategory fromDisplayName(String displayName) {
        for (ClothesCategory category : values()) {
            if (category.displayName.equals(displayName)) {
                return category;
            }
        }
        return null;
    }
} 