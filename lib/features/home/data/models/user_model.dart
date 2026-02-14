import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  int age;

  @HiveField(4)
  String imagePath;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    required this.imagePath,
  });

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        phone: phone,
        age: age,
        imagePath: imagePath,
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        phone: entity.phone,
        age: entity.age,
        imagePath: entity.imagePath,
      );
}
