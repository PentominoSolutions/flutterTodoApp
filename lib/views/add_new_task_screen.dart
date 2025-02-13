import 'package:flutter/material.dart';

class AddNewTask extends StatelessWidget {
  const AddNewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      elevation: 10,
      // title: const Text("Add new Task"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            AppBar(
              title: const Text('Add new Task'),
              backgroundColor: const Color.fromARGB(255, 233, 0, 0),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
            const SizedBox(
              width: 1000,
              height: 100,
            ),
            TextFormField(),
          ],
        ),
      ),
    );
  }
}
