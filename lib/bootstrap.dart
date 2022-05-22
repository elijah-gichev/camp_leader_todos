import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todos/app/app.dart';
import 'package:flutter_todos/app/app_bloc_observer.dart';
import 'package:flutter_todos/home/reps/user_reps.dart';
import 'package:intl/intl.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

void bootstrap({required TodosApi todosApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final todosRepository = TodosRepository(todosApi: todosApi);

  generateTodos().forEach(
    (element) {
      todosRepository.saveTodo(element);
    },
  );

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(
          App(todosRepository: todosRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

List<Todo> generateTodos() {
  final userReps = UserReps();
  return [
    Todo(
      title: 'Завтрак отряда №1',
      description: formatDate(DateTime(2022, 5, 22, 10, 10)),
      user: userReps.me,
    ),
    Todo(
      title: 'Бассейн Денис Ковалев',
      description: formatDate(DateTime(2022, 5, 22, 12, 10)),
      user: userReps.me,
    ),
    Todo(
      title: 'Кинотеатр Фёдор Лагутин',
      description: formatDate(DateTime(2022, 5, 22, 15, 0)),
      user: userReps.me,
    ),
    Todo(
      title: 'Обед отряда №1',
      description: formatDate(DateTime.now()),
      user: userReps.me,
    ),
    Todo(
      title: 'Проверить температуру отряда №1',
      description: formatDate(DateTime(2022, 5, 22, 17, 10)),
      user: userReps.me,
    ),
    Todo(
      title: 'Поход отряда №1',
      description: formatDate(DateTime(2022, 5, 22, 19, 10)),
    ),
    Todo(
      title: 'Полдник общий',
      description: formatDate(DateTime(2022, 5, 17, 19, 20)),
    ),
    Todo(
      title: 'Ужин отряда №1',
      description: formatDate(DateTime(2022, 5, 17, 21, 10)),
    ),
  ];
}

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat("HH:mm");
  return formatter.format(date);
}
