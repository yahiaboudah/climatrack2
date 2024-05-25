class Bookmark {
  final String id; // Document ID
  final String roomName;
  final DateTime date;
  final double? temperature;
  final double? humidity;

  Bookmark({
    required this.id,
    required this.roomName,
    required this.date,
    this.temperature,
    this.humidity,
  });
}