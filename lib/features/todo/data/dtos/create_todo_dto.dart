import '../../../../core/utils/value_parsing/safe_value_parser.dart';

class CreateTodoDto {
  final String title;
  final String description;
  final bool completed;

  const CreateTodoDto({
    required this.title,
    required this.description,
    required this.completed,
  });

  factory CreateTodoDto.fromJson(Map<String, dynamic> json) {
    return CreateTodoDto(
      title: SafeValueParser.readString(json['title']),
      description: SafeValueParser.readString(json['description']),
      completed: SafeValueParser.readBool(json['completed']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'completed': completed,
  };
}
