import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final int age;
  final String imagePath;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, name, phone, age, imagePath];
}
