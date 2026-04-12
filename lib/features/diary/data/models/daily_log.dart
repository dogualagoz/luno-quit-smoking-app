import 'package:hive/hive.dart';

part 'daily_log.g.dart';

/// Günlük check-in / kriz (craving) kaydını tutan veri modeli
@HiveType(typeId: 3)
class DailyLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int cravingIntensity; // 0-10 arası kriz şiddeti

  @HiveField(3)
  final bool hasSmoked;

  @HiveField(4)
  final int smokeCount; // Sadece hasSmoked true ise geçerli

  @HiveField(5)
  final String? location; // Neredeydi? (Konum string bilgisi)

  @HiveField(6)
  final List<String> moods; // Nasıl hissediyordun? (Çoklu seçim, örn: Annoyed, Anxious)

  @HiveField(7)
  final List<String> context; // Ne yapıyordun? (Örn: Drinking, Driving)

  @HiveField(8)
  final List<String> companions; // Kiminleydin? (Örn: Alone, Friends)

  @HiveField(9)
  final String? note; // Ekstra notlar

  @HiveField(10, defaultValue: 'craving')
  final String type; // 'craving' veya 'slip'

  DailyLog({
    required this.id,
    required this.date,
    required this.cravingIntensity,
    required this.hasSmoked,
    this.smokeCount = 0,
    this.location,
    required this.moods,
    required this.context,
    required this.companions,
    this.note,
    this.type = 'craving', // Varsayılan olarak kriz
  });

  // Firestore'dan okuma için
  factory DailyLog.fromMap(Map<String, dynamic> map, String documentId) {
    return DailyLog(
      id: documentId,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      cravingIntensity: map['cravingIntensity'] as int? ?? 0,
      hasSmoked: map['hasSmoked'] as bool? ?? false,
      smokeCount: map['smokeCount'] as int? ?? 0,
      location: map['location'] as String?,
      moods: List<String>.from(map['moods'] ?? []),
      context: List<String>.from(map['context'] ?? []),
      companions: List<String>.from(map['companions'] ?? []),
      note: map['note'] as String?,
      type: map['type'] as String? ?? 'craving',
    );
  }

  // Firestore'a yazma için
  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'cravingIntensity': cravingIntensity,
      'hasSmoked': hasSmoked,
      'smokeCount': smokeCount,
      'location': location,
      'moods': moods,
      'context': context,
      'companions': companions,
      'note': note,
      'type': type,
    };
  }

  DailyLog copyWith({
    String? id,
    DateTime? date,
    int? cravingIntensity,
    bool? hasSmoked,
    int? smokeCount,
    String? location,
    List<String>? moods,
    List<String>? context,
    List<String>? companions,
    String? note,
    String? type,
  }) {
    return DailyLog(
      id: id ?? this.id,
      date: date ?? this.date,
      cravingIntensity: cravingIntensity ?? this.cravingIntensity,
      hasSmoked: hasSmoked ?? this.hasSmoked,
      smokeCount: smokeCount ?? this.smokeCount,
      location: location ?? this.location,
      moods: moods ?? this.moods,
      context: context ?? this.context,
      companions: companions ?? this.companions,
      note: note ?? this.note,
      type: type ?? this.type,
    );
  }
}
