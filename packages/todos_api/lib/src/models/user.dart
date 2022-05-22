/// модель пользователя
class User {
  /// модель пользователя
  User(this.name);

  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
