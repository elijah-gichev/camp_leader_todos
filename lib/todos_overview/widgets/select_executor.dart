import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/home/reps/user_reps.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class SelectExecutorOptionsButton extends StatelessWidget {
  final users = UserReps().users;

  final Todo todo;

  SelectExecutorOptionsButton(this.todo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final todos = context.select((TodosOverviewBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;

    return PopupMenuButton<String>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.todosOverviewOptionsTooltip,
      onSelected: (options) {
        if (options == users[0].name) {
          context.read<TodosOverviewBloc>().add(
                TodosOverviewChooseUser(
                  users[0],
                  todo,
                ),
              );
        }

        if (options == users[1].name) {
          context.read<TodosOverviewBloc>().add(
                TodosOverviewChooseUser(
                  users[1],
                  todo,
                ),
              );
        }

        if (options == users[2].name) {
          context.read<TodosOverviewBloc>().add(
                TodosOverviewChooseUser(
                  users[2],
                  todo,
                ),
              );
        }

        if (options == users[3].name) {
          context.read<TodosOverviewBloc>().add(
                TodosOverviewChooseUser(
                  users[3],
                  todo,
                ),
              );
        }
      },
      itemBuilder: (context) {
        return [
          ...users.map(
            (user) {
              return PopupMenuItem(
                value: user.name,
                enabled: hasTodos,
                child: Text(
                  user.name,
                ),
              );
            },
          ),

          // PopupMenuItem(
          //   value: TodosOverviewOption.toggleAll,
          //   enabled: hasTodos,
          //   child: Text(
          //     completedTodosAmount == todos.length ? l10n.todosOverviewOptionsMarkAllIncomplete : l10n.todosOverviewOptionsMarkAllComplete,
          //   ),
          // ),
          // PopupMenuItem(
          //   value: TodosOverviewOption.clearCompleted,
          //   enabled: hasTodos && completedTodosAmount > 0,
          //   child: Text(l10n.todosOverviewOptionsClearCompleted),
          // ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
