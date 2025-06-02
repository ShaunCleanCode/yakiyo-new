import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? deviceId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.deviceId,
  });

  @override
  List<Object?> get props => [id, name, email, deviceId];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? deviceId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
