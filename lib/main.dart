// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Returns MaterialApp, which has properties like Home
      title: 'Todo List',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];

// This will be called each time the + button is pressed
  void _addTodoItem(String task) {
    // setState basically notifies the framework that the internal state of this object has changed that might impact UI
    if (task.isNotEmpty) {
      // Only add the task if the user actually entered something
      setState(() => _todoItems.add(task));
    }
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return ListView.builder(
      itemCount:
          _todoItems.length, // @REQUIRED if you don't want red-screen error
      itemBuilder: (context, index) {
        final indexes = _todoItems[index];
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
        throw Exception("Woah! Something unexpected happened!");
      },
    );
  }

// Creates the individual lines for the to-do list
  Widget _buildTodoItem(String todoText, int index) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text(todoText),
            onTap: () => _promptRemoveTodoItem(index),
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.red[900],
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: "Add task",
        child: const Icon(Icons.add),
        backgroundColor: Colors.red[900],
      ),
    );
  }

  Widget _addItems() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new task"),
        backgroundColor: Colors.red[900],
      ),
      body: TextField(
        autofocus: true,
        onSubmitted: (val) {
          _addTodoItem(val);
          Navigator.pop(context);
        },
        decoration: const InputDecoration(
          hintText: "Add a to do item",
          contentPadding: EdgeInsets.all(16.0),
        ),
      ),
    );
  }

  void _pushAddTodoScreen() {
// Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
      MaterialPageRoute(builder: (context) {
        return _addItems();
      }),
    );
  }

  void _removeTodoItem(int index) {
    setState(
        () => _todoItems.removeAt(index)); // Goes to the list and removes item
  }

// When you click on the item line, it'll send a prompt if we want to mark something as done or complete
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Mark "${_todoItems[index]}" as done?'),
            actions: <Widget>[
              FlatButton(
                // FlatButton requires a "onPressed"
                child: const Text("CANCEL"),
                onPressed: () =>
                    Navigator.of(context).pop(), // Removes the screen
              ),
              FlatButton(
                  child: const Text("MARK AS DONE"),
                  onPressed: () {
                    _removeTodoItem(index); // Removes the item from the list
                    Navigator.of(context).pop(); // Gets out of that screen
                  }),
            ],
          );
        });
  }
}
