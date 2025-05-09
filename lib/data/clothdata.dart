final List<ClothItem> testClosetItems = List.generate(30, (index) {
  return ClothItem(
    id: index,
    image: 'https://example.com/images/testbanner.jpg',
    category: index % 3 == 0 ? '입을 옷' : index % 3 == 1 ? '안 입을 옷' : '세탁 중',
    color: '색 $index',
    season: '시즌 $index',
    style: '스타일 $index',
  );
});

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

  factory ClothItem.fromJson(Map<String, dynamic> json) => ClothItem(
    id: json['id'] as int,
    image: json['imageUrl'] as String? ?? '',       // ← 여기 수정
    category: json['category'] as String? ?? '',
    color: json['color'] as String? ?? '',
    season: json['season'] as String? ?? '',
    style: json['style'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'category': category,
    'color': color,
    'season': season,
    'style': style,
  };
}
