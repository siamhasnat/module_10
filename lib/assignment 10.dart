import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();
  List<TodoItem> todoItems = [];

  void _addTodoItem() {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        todoItems.add(TodoItem(title, description));
        titleController.clear();
        descriptionController.clear();
      });
    }
  }

  void _showEditDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditBottomSheet(index);
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todoItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(int index) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    titleController.text = todoItems[index].title;
    descriptionController.text = todoItems[index].description;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Adjust this value to increase the height
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        todoItems[index].title = titleController.text;
                        todoItems[index].description = descriptionController.text;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Edit Done'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  List<TodoItem> _searchTodoItems(String query) {
    return todoItems
        .where((item) =>
        item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TodoSearchDelegate(todoItems),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  ElevatedButton(
                    onPressed: _addTodoItem,
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('${index + 1}.'),
                  title: Text('Title: ${todoItems[index].title}'),
                  subtitle: Text('Description: ${todoItems[index].description}'),
                  trailing: Icon(Icons.arrow_forward), // Add the arrow icon
                  onLongPress: () {
                    _showEditDeleteDialog(index);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem {
  dynamic title;
  dynamic description;

  TodoItem(this.title, this.description);
}

class TodoSearchDelegate extends SearchDelegate<TodoItem?> {
  final List<TodoItem> items;

  TodoSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _searchTodoItems(query);
    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = _searchTodoItems(query);
    return _buildSearchResults(results);
  }

  List<TodoItem?> _searchTodoItems(String query) {
    return items
        .where((item) =>
        item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget _buildSearchResults(List<TodoItem?> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Title: ${results[index]!.title}'),
          subtitle: Text('Description: ${results[index]!.description}'),
        );
      },
    );
  }
}
