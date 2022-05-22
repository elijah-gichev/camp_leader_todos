part of 'my_todos_overview_bloc.dart';

abstract class MyTodosOverviewEvent extends Equatable {
  const MyTodosOverviewEvent();

  @override
  List<Object> get props => [];
}

class MyTodosOverviewSubscriptionRequested extends MyTodosOverviewEvent {
  const MyTodosOverviewSubscriptionRequested();
}

class MyTodosOverviewTodoCompletionToggled extends MyTodosOverviewEvent {
  const MyTodosOverviewTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final Todo todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

class MyTodosOverviewTodoDeleted extends MyTodosOverviewEvent {
  const MyTodosOverviewTodoDeleted(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class MyTodosOverviewUndoDeletionRequested extends MyTodosOverviewEvent {
  const MyTodosOverviewUndoDeletionRequested();
}

class MyTodosOverviewFilterChanged extends MyTodosOverviewEvent {
  const MyTodosOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class MyTodosOverviewToggleAllRequested extends MyTodosOverviewEvent {
  const MyTodosOverviewToggleAllRequested();
}

class MyTodosOverviewClearCompletedRequested extends MyTodosOverviewEvent {
  const MyTodosOverviewClearCompletedRequested();
}
