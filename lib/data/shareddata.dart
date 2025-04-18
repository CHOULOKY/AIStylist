// lib/data/shareddata.dart
final List<Map<String, dynamic>> closetItems = List.generate(30, (index) {
  return {
    'brand': '${index}',
    'title': 'reversible angora cardigan',
    'image': 'assets/images/testbanner.jpg',
    'liked': false,
    'category': index % 3 == 0 ? '입을 옷' : index % 3 == 1 ? '안 입을 옷' : '세탁 중',
  };
});
