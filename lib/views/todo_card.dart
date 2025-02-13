import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final Map<String, dynamic> todo;
  final Function(bool) onStatusChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoCard({
    required this.todo,
    required this.onStatusChanged,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo["status"] ? Colors.greenAccent : Colors.orangeAccent,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Checkbox(
          value: todo["status"],
          onChanged: (value) => onStatusChanged(value!),
        ),
        title: Text(
          todo['taskName'],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: todo["status"] ? Colors.black : Colors.white,
          ),
        ),
        subtitle: Text(
          todo['taskDescription'],
          style: TextStyle(
            fontSize: 18,
            color: todo["status"] ? Colors.black : Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
