package com.aistylist.spring_backend.domain;

/**
 * 옷 스타일을 정의하는 enum
 */
public enum ClothesStyle {
    CASUAL("캐주얼"),
    COZY("코지"),
    BUSINESS_CASUAL("비즈니스 캐주얼"),
    FORMAL("포멀"),
    MODERN("모던"),
    CLASSIC("클래식"),
    MINIMAL("미니멀"),
    BOHEMIAN("보헤미안"),
    LUXURY("럭셔리"),
    SPORTY("스포티"),
    ATHLEISURE("애슬레저"),
    AFFORDABLE("저렴한"),
    TRENDY("트렌디"),
    MID_RANGE("중저가"),
    KID_CORE("키드코어"),
    BASIC("베이직"),
    ARTISTIC("아티스틱"),
    DRESS_UP("드레스업"),
    HIPSTER("힙스터"),
    FEMININE("페미닌"),
    CHIC("시크"),
    STREET("스트릿"),
    KITSCH("키치"),
    PUNKY("펑키"),
    OTHER("기타");
    
    private final String displayName;
    
    ClothesStyle(String displayName) {
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
    public static ClothesStyle fromDisplayName(String displayName) {
        for (ClothesStyle style : values()) {
            if (style.displayName.equals(displayName)) {
                return style;
            }
        }
        return null;
    }
} 