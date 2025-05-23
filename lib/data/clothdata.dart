class ClothItem {
  final int id;
  final String image;
  final String category;
  final String color;
  final String season;
  final String style;


  ClothItem({
    required this.id,
    required this.image,
    required this.category,
    required this.color,
    required this.season,
    required this.style,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'category': category,
    'color': color,
    'season': season,
    'style': style,
  };

  factory ClothItem.fromJson(Map<String, dynamic> json) {
    return ClothItem(
      id: json['id'] as int,
      image: json['imageUrl'] as String? ?? '',
      category: _mapCategory(json['category']) as String? ?? '', // 영문 → 한글
      color: _mapColor(json['color']) as String? ?? '',
      season: _mapSeason(json['season']) as String? ?? '',
      style: _mapStyle(json['style']) as String? ?? '',
    );
  }

  static String _mapCategory(String eng) {
    switch (eng) {
      case 'TOP': return '상의';
      case 'BOTTOM': return '하의';
      case 'OUTER': return '아우터';
      case 'SHOES': return '신발';
      default: return eng;
    }
  }

  static String _mapColor(String eng) {
    switch (eng) {
      case 'BLACK': return '블랙';
      case 'WHITE': return '화이트';
      case 'BLUE': return '블루';
      case 'RED': return '레드';
      case 'GREEN': return '그린';
      case 'IVORY': return '아이보리';
      case 'BEIGE': return '베이지';
      case 'LIGHT_GRAY': return '라이트그레이';
      case 'GRAY': return '그레이';
      case 'DARK_GRAY': return '다크그레이';
      case 'BROWN': return '브라운';
      case 'ORANGE': return '오렌지';
      case 'YELLOW': return '옐로우';
      case 'PINK': return '핑크';
      case 'PURPLE': return '퍼플';
      case 'GOLD': return '골드';
      case 'SILVER': return '실버';
      case 'MULTI': return '멀티';
      case 'LIGHT_YELLOW': return '라이트옐로우';
      case 'CORAL': return '코랄';
      case 'DARK_PINK': return '다크핑크';
      case 'MINT': return '민트';
      case 'OLIVE': return '올리브';
      case 'DARK_OLIVE': return '다크올리브';
      case 'TEAL': return '틸';
      case 'KHAKI': return '카키';
      case 'CYAN': return '시안';
      case 'SKY_BLUE': return '스카이블루';
      case 'NAVY': return '네이비';
      case 'LAVENDER': return '라벤더';
      case 'BURGUNDY': return '버건디';
      case 'CAMEL': return '카멜';
      case 'DARK_BROWN': return '다크브라운';
      case 'MAGENTA': return '마젠타';
      default: return eng;
    }
  }

  static String _mapSeason(String eng) {
    switch (eng) {
      case 'SPRING': return '봄';
      case 'SUMMER': return '여름';
      case 'FALL': return '가을';
      case 'WINTER': return '겨울';
      case 'ALL': return '모든 계절';
      default: return eng;
    }
  }

  static String _mapStyle(String eng) {
    switch (eng) {
      case 'CASUAL': return '캐주얼';
      case 'FORMAL': return '포멀';
      case 'COZY': return '코지';
      case 'BUSINESS_CASUAL': return '비즈니스 캐주얼';
      case 'MODERN': return '모던';
      case 'CLASSIC': return '클래식';
      case 'MINIMAL': return '미니멀';
      case 'BOHEMIAN': return '보헤미안';
      case 'LUXURY': return '럭셔리';
      case 'SPORTY': return '스포티';
      case 'ATHLEISURE': return '애슬레저';
      case 'AFFORDABLE': return '저렴한';
      case 'TRENDY': return '트렌디';
      case 'MID_RANGE': return '중저가';
      case 'KID_CORE': return '키드코어';
      case 'BASIC': return '베이직';
      case 'ARTISTIC': return '아티스틱';
      case 'DRESS_UP': return '드레스업';
      case 'HIPSTER': return '힙스터';
      case 'FEMININE': return '페미닌';
      case 'CHIC': return '시크';
      case 'STREET': return '스트릿';
      case 'KITSCH': return '키치';
      case 'PUNKY': return '펑키';
      case 'OTHER': return '기타';
      default: return eng;
    }
  }
}
