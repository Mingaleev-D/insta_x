import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String? picture;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.picture,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? name,
    String? picture,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'name': this.name,
      'picture': this.picture,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      picture: map['picture'] as String,
    );
  }

  static const empty = UserEntity(
    uid: '',
    email: '',
    name: '',
    picture: '',
  );

  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;
  @override
  List<Object?> get props => [uid, email, name, picture];
}
