import '../../../../core/utils/value_parsing/safe_value_parser.dart';
import '../../domain/entities/user.dart';

class UserDto {
  final int id;
  final String username;
  final String email;
  final String accessToken;
  final String refreshToken;

  final String firstName;
  final String lastName;
  final String gender;
  final String image;

  const UserDto({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: SafeValueParser.readInt(json['id']),
      username: SafeValueParser.readString(json['username']),
      email: SafeValueParser.readString(json['email']),
      firstName: SafeValueParser.readString(json['firstName']),
      lastName: SafeValueParser.readString(json['lastName']),
      gender: SafeValueParser.readString(json['gender']),
      image: SafeValueParser.readString(json['image']),
      accessToken: SafeValueParser.readString(json['accessToken']),
      refreshToken: SafeValueParser.readString(json['refreshToken']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'gender': gender,
    'image': image,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };

  User toEntity() => User(
    id: id,
    username: username,
    email: email,
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    image: image,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
