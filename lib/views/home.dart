import 'package:flutter/material.dart';
import 'package:ps_todo_app/service/todo_service.dart';
import 'package:ps_todo_app/views/todo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _todos = [];
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() => _isLoading = true);
    List<Map<String, dynamic>> todos = await TodoService.getTodos();
    setState(() {
      _todos = todos;
      _isLoading = false;
    });
  }

  void _addTodo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    bool success = await TodoService.addTodo(
      _titleController.text,
      _descriptionController.text,
    );
    if (success) {
      _titleController.clear();
      _descriptionController.clear();
    }
    _fetchTodos();
  }

  void _updateStatus(String id, bool status) async {
    setState(() => _isLoading = true);
    await TodoService.updateStatus(id, status);
    _fetchTodos();
  }

  void _deleteTodoAt(int index) async {
    setState(() => _isLoading = true);
    await TodoService.deleteTodo(_todos[index]['id']);
    _fetchTodos();
  }

  void _showTodoDialog({bool isEdit = false, int? index}) {
    if (isEdit) {
      _titleController.text = _todos[index!]['taskName'];
      _descriptionController.text = _todos[index]['taskDescription'];
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title, color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Title cannot be empty' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description, color: Colors.green),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Description cannot be empty' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                setState(() => _isLoading = true);
                if (isEdit) {
                  await TodoService.updateTodo(
                    _todos[index!]['id'],
                    _titleController.text,
                    _descriptionController.text,
                  );
                } else {
                  _addTodo();
                }
                Navigator.of(context).pop();
                _fetchTodos();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
            TextButton(
              onPressed: () {
                _titleController.clear();
                _descriptionController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pentomino To-Do App')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return TodoCard(
                    todo: _todos[index],
                    onStatusChanged: (status) =>
                        _updateStatus(_todos[index]['id'], status),
                    onEdit: () => _showTodoDialog(isEdit: true, index: index),
                    onDelete: () => _deleteTodoAt(index),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
