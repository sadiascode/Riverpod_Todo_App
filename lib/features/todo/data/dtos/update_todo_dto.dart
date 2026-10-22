/// Request body for `PUT /todos/{id}`.
///
/// DummyJSON only requires the fields the caller wants to update, so this
/// DTO currently carries only `completed` (the only field the update
/// feature touches). Extend it as more update fields are introduced.
class UpdateTodoDto {
  final bool completed;

  const UpdateTodoDto({required this.completed});

  Map<String, dynamic> toJson() => {'completed': completed};
}
