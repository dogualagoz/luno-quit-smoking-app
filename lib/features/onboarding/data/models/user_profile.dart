import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String nickname;

  @HiveField(1)
  final int dailyCigarettes;

  @HiveField(2)
  final int smokingYears;

  @HiveField(3)
  final double packPrice;

  @HiveField(4)
  final int cigarettesPerPack;

  @HiveField(5)
  final DateTime? quitDate;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String? tryingToQuitCount;

  @HiveField(8)
  final List<String> quitReasons;

  @HiveField(9)
  final String? triggerMoment;

  @HiveField(10)
  final String? userId; // Firebase UID için

  @HiveField(11)
  final String? email; // Kullanıcı e-postası için

  @HiveField(12, defaultValue: 0)
  final int weeklySmokingGoal; // Haftalık azaltma hedefi (sigara adet). 0 = hedef girilmemiş.

  UserProfile({
    required this.nickname,
    required this.dailyCigarettes,
    required this.smokingYears,
    required this.packPrice,
    required this.cigarettesPerPack,
    this.quitDate,
    required this.createdAt,
    this.tryingToQuitCount,
    this.quitReasons = const [],
    this.triggerMoment,
    this.userId,
    this.email,
    this.weeklySmokingGoal = 0,
  });

  /// Sadece değişen alanları güncelleyerek yeni bir kopya oluşturur
  UserProfile copyWith({
    String? nickname,
    int? dailyCigarettes,
    int? smokingYears,
    double? packPrice,
    int? cigarettesPerPack,
    DateTime? quitDate,
    DateTime? createdAt,
    String? tryingToQuitCount,
    List<String>? quitReasons,
    String? triggerMoment,
    String? userId,
    String? email,
    int? weeklySmokingGoal,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      dailyCigarettes: dailyCigarettes ?? this.dailyCigarettes,
      smokingYears: smokingYears ?? this.smokingYears,
      packPrice: packPrice ?? this.packPrice,
      cigarettesPerPack: cigarettesPerPack ?? this.cigarettesPerPack,
      quitDate: quitDate ?? this.quitDate,
      createdAt: createdAt ?? this.createdAt,
      tryingToQuitCount: tryingToQuitCount ?? this.tryingToQuitCount,
      quitReasons: quitReasons ?? this.quitReasons,
      triggerMoment: triggerMoment ?? this.triggerMoment,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      weeklySmokingGoal: weeklySmokingGoal ?? this.weeklySmokingGoal,
    );
  }

  /// Firestore ile uyum için JSON dönüşümü
  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'dailyCigarettes': dailyCigarettes,
    'smokingYears': smokingYears,
    'packPrice': packPrice,
    'cigarettesPerPack': cigarettesPerPack,
    'quitDate': quitDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'tryingToQuitCount': tryingToQuitCount,
    'quitReasons': quitReasons,
    'triggerMoment': triggerMoment,
    'userId': userId,
    'email': email,
    'weeklySmokingGoal': weeklySmokingGoal,
  };

  /// Firestore'dan gelen JSON'dan UserProfile oluşturur
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    nickname: json['nickname'] as String,
    dailyCigarettes: json['dailyCigarettes'] as int,
    smokingYears: json['smokingYears'] as int,
    packPrice: (json['packPrice'] as num).toDouble(),
    cigarettesPerPack: json['cigarettesPerPack'] as int,
    quitDate: json['quitDate'] != null
        ? DateTime.parse(json['quitDate'] as String)
        : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    tryingToQuitCount: json['tryingToQuitCount'] as String?,
    quitReasons: List<String>.from(json['quitReasons'] as List? ?? []),
    triggerMoment: json['triggerMoment'] as String?,
    userId: json['userId'] as String?,
    email: json['email'] as String?,
    weeklySmokingGoal: json['weeklySmokingGoal'] as int? ?? 0,
  );
}
