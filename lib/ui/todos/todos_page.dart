import 'package:flutter/material.dart';

import '../../data/repository/todos_repository.dart';
import '../../models/todo_model.dart';
import '../app_colors.dart';
import '../_shared/progress_widget.dart';
import 'add_todo_widget.dart';
import 'todo_item_widget.dart';

class TodosPage extends StatefulWidget {
  final TodosRepository todosRepository;

  const TodosPage({Key? key, required this.todosRepository}) : super(key: key);

  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  late List<TodoModel> todos;
  bool isLoading = true;
  ValueNotifier<bool> isAddingTodo = ValueNotifier(false);

  @override
  void initState() {
    fetchTodos();
    super.initState();
  }

  Future<void> fetchTodos() async {
    try {
      final fetchedTodos = await widget.todosRepository.fetchTodos();
      if (mounted) {
        setState(() {
          todos = fetchedTodos;
          isLoading = false;
        });
      }
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while fetching the todos!'),
        ),
      );
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      final isAdded = await widget.todosRepository.addTodo(todo);
      if (isAdded && mounted) {
        setState(() => todos.add(todo));
        toggleIsAddingTodo();
      }
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while adding the todo!'),
        ),
      );
    }
  }

  //TODO: Reorder To-dos

  Future<bool> onWillPop() async {
    if (isAddingTodo.value) {
      toggleIsAddingTodo();
      return Future.value(false);
    }
    return Future.value(true);
  }

  void toggleIsAddingTodo() {
    isAddingTodo.value = !isAddingTodo.value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        floatingActionButton: buildFloatingActionButton(),
        bottomSheet: buildBottomSheet(),
        body: isLoading ? const ProgressWidget() : buildTodoList(),
      ),
    );
  }

  Widget buildTodoList() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 90),
      children: todos
          .map(
            (todo) => TodoItemWidget(
              todo: todo,
              todosRepository: widget.todosRepository,
            ),
          )
          .toList(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => toggleIsAddingTodo(),
      backgroundColor: AppColors.accentColor,
      child: ValueListenableBuilder(
        valueListenable: isAddingTodo,
        builder: (_, bool isAddingMode, __) {
          return Icon(
            isAddingMode ? Icons.close : Icons.add,
            color: Colors.white,
          );
        },
      ),
    );
  }

  Widget buildBottomSheet() {
    return ValueListenableBuilder(
      valueListenable: isAddingTodo,
      child: BottomSheet(
        backgroundColor: AppColors.secondaryColor,
        onClosing: () {},
        builder: (_) => AddTodoWidget(onSubmitTap: addTodo),
      ),
      builder: (_, bool isAddingMode, Widget? child) {
        return isAddingMode && child != null ? child : const SizedBox.shrink();
      },
    );
  }
}
