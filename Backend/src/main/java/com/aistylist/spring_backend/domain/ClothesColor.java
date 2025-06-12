package com.aistylist.spring_backend.domain;

/**
 * 옷 색상을 정의하는 enum
 */
public enum ClothesColor {
    WHITE("흰색"),
    IVORY("아이보리"),
    BEIGE("베이지"),
    LIGHT_GRAY("연회색"),
    GRAY("진회색"),
    BLACK("검정"),
    LIGHT_YELLOW("연노랑"),
    YELLOW("노랑"),
    ORANGE("주황"),
    CORAL("코랄"),
    RED("빨강"),
    PINK("분홍"),
    DARK_PINK("진분홍"),
    MINT("연두"),
    GREEN("초록"),
    OLIVE("올리브"),
    DARK_OLIVE("다크올리브"),
    TEAL("청록"),
    KHAKI("카키"),
    CYAN("시안"),
    SKY_BLUE("하늘색"),
    BLUE("파랑"),
    NAVY("네이비"),
    LAVENDER("라벤더"),
    PURPLE("보라"),
    BURGUNDY("버건디"),
    CAMEL("카멜"),
    BROWN("갈색"),
    DARK_BROWN("다크브라운"),
    MAGENTA("마젠타"),
    GOLD("골드"),
    SILVER("실버"),
    MULTI("다채색");
    
    private final String displayName;
    
    ClothesColor(String displayName) {
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
    public static ClothesColor fromDisplayName(String displayName) {
        for (ClothesColor color : values()) {
            if (color.displayName.equals(displayName)) {
                return color;
            }
        }
        return null;
    }
} 