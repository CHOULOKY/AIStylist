// lib/data/shareddata.dart
final List<Map<String, dynamic>> closetItems = List.generate(10, (index) {
  return {
    'brand': index % 2 == 0 ? '21WN' : 'lame',
    'title': 'reversible angora cardigan',
    'price': '\$120',
    'image': 'assets/images/testbanner.jpg',
    'liked': false,
  };
});
