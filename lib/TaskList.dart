import 'package:flutter/material.dart';
import 'task.dart';
import 'TaskFunctions.dart';

//define widget
class TaskList extends StatefulWidget {
  //link state
  @override
  _TaskListState createState() => _TaskListState();
}

//state class
class _TaskListState extends State<TaskList> {
  List<Task> tasks = []; // List to hold tasks

  //adding task dialog
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onTaskAdded: (task) {
            setState(() {
              tasks.add(task); // Add the new task to the task list
            });
          },
        );
      },
    );
  }

  //updating details dialog
  void _showUpdateTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateTaskDialog(
          task: task,
          onTaskUpdated: (updatedTask) { //if details change
            setState(() { //update task
              int index = tasks.indexWhere((t) => t.getId == updatedTask.getId); // find it by Id
              if (index != -1) {
                tasks[index] = updatedTask;
              }
            });
          },
        );
      },
    );
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task); // Remove the task from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //structure
      appBar: AppBar( //top bar (title and blue color)
        title: Text("To-Do List"),
        //backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder( //dynamic ui builder for scrollable list
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile( //each task line
            title: Text(tasks[index].gettaskDescription),
            subtitle: Text('Due: ${tasks[index].dueDate}'),
            leading: IconButton( ////edit button
              icon: Icon(Icons.edit),
              onPressed: () => _showUpdateTaskDialog(tasks[index]),//action it does when pressed
            ),
            trailing: IconButton(//delete button
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => _deleteTask(tasks[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(//button on bottom left corner
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),//icon for it
      ),
    );
  }
}

//class for add task dialog
class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded; // Callback to notify when a task is added
//required
  const AddTaskDialog({Key? key, required this.onTaskAdded}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}
//state for add task dialog
class _AddTaskDialogState extends State<AddTaskDialog> {
  TaskFunctions taskFunctions = TaskFunctions();

  final TextEditingController _taskDescriptionController = TextEditingController(); //declare controller
  DateTime? _dueDate;

  void _submitTask() {
    if (_taskDescriptionController.text.isNotEmpty) { //check if input field is not empty
      Task newTask = taskFunctions.createTask(
        _taskDescriptionController.text,
        _dueDate ?? DateTime.now(), //if no due date is given its set to current date
      );
      widget.onTaskAdded(newTask);
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskDescriptionController,
            decoration: InputDecoration(labelText: 'Task Description'),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Due Date',
              hintText: 'yyyy-mm-dd',
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode()); // Dismiss keyboard
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  _dueDate = pickedDate;
                });
              }
            },
            controller: TextEditingController(text: _dueDate != null ? _dueDate.toString().substring(0, 10) : ''),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitTask,
          child: Text('Add Task'),
        ),
      ],
    );
  }
}

//Update dialog
class UpdateTaskDialog extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdated; // Callback to notify when a task is updated
//requires
  const UpdateTaskDialog({Key? key, required this.task, required this.onTaskUpdated}) : super(key: key);

  @override
  _UpdateTaskDialogState createState() => _UpdateTaskDialogState();
}
//update dialog state
class _UpdateTaskDialogState extends State<UpdateTaskDialog> {
  final TextEditingController _taskDescriptionController = TextEditingController(); //controller
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();//pre fill the fields with task info to be updated
    _taskDescriptionController.text = widget.task.gettaskDescription;
    _dueDate = widget.task.dueDate;
  }

  void _submitUpdatedTask() {
    if (_taskDescriptionController.text.isNotEmpty) {
      widget.task.settaskDescription = _taskDescriptionController.text;
      widget.task.dueDate = _dueDate ?? DateTime.now();
      widget.onTaskUpdated(widget.task); // Notify parent (TaskList) about the update
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskDescriptionController,
            decoration: InputDecoration(labelText: 'Task Description'),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Due Date',
              hintText: 'yyyy-mm-dd',
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode()); // Dismiss keyboard
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  _dueDate = pickedDate;
                });
              }
            },
            controller: TextEditingController(text: _dueDate != null ? _dueDate.toString().substring(0, 10) : ''),//format
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitUpdatedTask,
          child: Text('Update Task'),
        ),
      ],
    );
  }
}
