class CalendarEntryDto {
  final int id;
  final int userId;
  final String date; // YYYY-MM-DD 형식의 문자열
  final String recommendation; // JSON 문자열
  final String createdAt;
  final String updatedAt;

  CalendarEntryDto({
    required this.id,
    required this.userId,
    required this.date,
    required this.recommendation,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON Map에서 CalendarEntryDto 객체를 생성하는 팩토리 생성자
  factory CalendarEntryDto.fromJson(Map<String, dynamic> json) {
    return CalendarEntryDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: json['date'] as String,
      recommendation: json['recommendation'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}
