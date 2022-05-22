import 'package:todos_api/todos_api.dart';

class UserReps {
  UserReps() {
    users.addAll(
      [
        me,
        User('Andrey'),
        User('Maria'),
        User('Oleg'),
      ],
    );
  }
  final users = <User>[];
  final me = User('Ivan');
}
