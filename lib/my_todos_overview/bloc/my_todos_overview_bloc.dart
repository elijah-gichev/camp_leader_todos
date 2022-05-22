import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/home/reps/user_reps.dart';
import 'package:flutter_todos/my_todos_overview/models/todos_view_filter.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

part 'my_todos_overview_event.dart';
part 'my_todos_overview_state.dart';

class MyTodosOverviewBloc extends Bloc<MyTodosOverviewEvent, MyTodosOverviewState> {
  late Timer _timer;
  MyTodosOverviewBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const MyTodosOverviewState()) {
    on<MyTodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<MyTodosOverviewTodoCompletionToggled>(_onTodoCompletionToggled);
    on<MyTodosOverviewTodoDeleted>(_onTodoDeleted);
    on<MyTodosOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<MyTodosOverviewFilterChanged>(_onFilterChanged);
    on<MyTodosOverviewToggleAllRequested>(_onToggleAllRequested);
    on<MyTodosOverviewClearCompletedRequested>(_onClearCompletedRequested);

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      add(MyTodosOverviewSubscriptionRequested());
    });
    //context.read<MyTodosOverviewBloc>().add(MyTodosOverviewSubscriptionRequested());
  }

  final TodosRepository _todosRepository;

  final UserReps _userReps = UserReps();

  Future<void> _onSubscriptionRequested(
    MyTodosOverviewSubscriptionRequested event,
    Emitter<MyTodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodosOverviewStatus.success,
        todos: () {
          final myTodos = todos.where((element) => element.user == _userReps.me).toList();
          return myTodos;
        },
      ),
      onError: (_, __) => state.copyWith(
        status: () => TodosOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    MyTodosOverviewTodoCompletionToggled event,
    Emitter<MyTodosOverviewState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<void> _onTodoDeleted(
    MyTodosOverviewTodoDeleted event,
    Emitter<MyTodosOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onUndoDeletionRequested(
    MyTodosOverviewUndoDeletionRequested event,
    Emitter<MyTodosOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todosRepository.saveTodo(todo);
  }

  void _onFilterChanged(
    MyTodosOverviewFilterChanged event,
    Emitter<MyTodosOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    MyTodosOverviewToggleAllRequested event,
    Emitter<MyTodosOverviewState> emit,
  ) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
    MyTodosOverviewClearCompletedRequested event,
    Emitter<MyTodosOverviewState> emit,
  ) async {
    await _todosRepository.clearCompleted();
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
