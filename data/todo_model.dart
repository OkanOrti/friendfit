import 'package:friendfit_ready/utils/uuid.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final String? id, parent;
  final String? name;
  final String? hour;
  final String? phrase;
  @JsonKey(name: 'completed')
  final int? isCompleted;

  static var _todos = [
    Todo(
      "Vegetables",
      parent: '1',
    ),
    Todo(
      "Birthday gift",
      parent: '1',
    ),
    Todo("Chocolate cookies", parent: '1', isCompleted: 1),
    Todo(
      "20 pushups",
      parent: '2',
    ),
    Todo(
      "Tricep",
      parent: '2',
    ),
    Todo(
      "15 burpees (3 sets)",
      parent: '2',
    ),
  ];

  Todo(this.name,
      {@required this.parent,
      this.isCompleted = 0,
      this.hour,
      this.phrase,
      String? id})
      : this.id = id ?? Uuid().generateV4();

  Todo copy({String? name, int? isCompleted, String? id, String? parent}) {
    return Todo(
      name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id ?? this.id,
      parent: parent ?? this.parent,
    );
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TodoFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TodoFromJson`.
  Map<String?, dynamic> toJson() => _$TodoToJson(this);
}
