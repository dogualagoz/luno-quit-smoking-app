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

  UserProfile({
    required this.nickname,
    required this.dailyCigarettes,
    required this.smokingYears,
    required this.packPrice,
    required this.cigarettesPerPack,
    this.quitDate,
    required this.createdAt,
  });

  // İleride Firestore ile uyum için toJson/fromJson eklenebilir
}
