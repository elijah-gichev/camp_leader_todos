import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/view/edit_todo_page.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/my_todos_overview/bloc/my_todos_overview_bloc.dart';
import 'package:flutter_todos/my_todos_overview/widgets/todo_list_tile.dart';
import 'package:flutter_todos/my_todos_overview/widgets/todos_overview_filter_button.dart';
import 'package:flutter_todos/my_todos_overview/widgets/todos_overview_options_button.dart';
import 'package:todos_repository/todos_repository.dart';

class MyTodosOverviewPage extends StatelessWidget {
  const MyTodosOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyTodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const MyTodosOverviewSubscriptionRequested()),
      child: const MyTodosOverviewView(),
    );
  }
}

class MyTodosOverviewView extends StatelessWidget {
  const MyTodosOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои задачи'),
        actions: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MyTodosOverviewBloc, MyTodosOverviewState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.todosOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<MyTodosOverviewBloc, MyTodosOverviewState>(
            listenWhen: (previous, current) => previous.lastDeletedTodo != current.lastDeletedTodo && current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.todosOverviewTodoDeletedSnackbarText(
                        deletedTodo.title,
                      ),
                    ),
                    action: SnackBarAction(
                      label: l10n.todosOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context.read<MyTodosOverviewBloc>().add(const MyTodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<MyTodosOverviewBloc, MyTodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'Задач больше нет!',
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final todo in state.filteredTodos)
                    TodoListTile(
                      todo: todo,
                      onToggleCompleted: (isCompleted) {
                        context.read<MyTodosOverviewBloc>().add(
                              MyTodosOverviewTodoCompletionToggled(
                                todo: todo,
                                isCompleted: isCompleted,
                              ),
                            );
                      },
                      onDismissed: (_) {
                        context.read<MyTodosOverviewBloc>().add(MyTodosOverviewTodoDeleted(todo));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditTodoPage.route(initialTodo: todo),
                        );
                        //context.read<MyTodosOverviewBloc>().add(MyTodosOverviewSubscriptionRequested());
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
