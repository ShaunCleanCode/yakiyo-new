import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    String? deviceId,
  }) : super(
          id: id,
          name: name,
          email: email,
          deviceId: deviceId,
        );

  factory UserModel.fromFirebaseUser(firebase.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      deviceId: null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      deviceId: json['deviceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'deviceId': deviceId,
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? deviceId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
