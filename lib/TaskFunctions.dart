import 'dart:io';


import 'task.dart';

class TaskFunctions{
  List<Task> tasks = [];
  String filepath = "tasklists.txt";
  static int _idCounter = 0;

  static int generateId() {
    _idCounter++; // Increment the counter for the next ID
    return _idCounter;
  }

  List<Task> getAllTasks() {
    return tasks;
  }

  //create
  Task createTask(String taskDescription, DateTime dueDate){
    DateTime taskCreation = DateTime.utc(DateTime.now().year,DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

    // if (dueDate == null){
    //   dueDate = taskCreation;
    // }

    dueDate ??= taskCreation;

    int id = generateId();
    //Task newTask = Task(generateId as String,taskDescription as DateTime,taskCreation,dueDate);
    Task newTask = Task(id,taskDescription,taskCreation,dueDate);
    tasks.add(newTask);
    print(newTask.toString());
    saveToFile();
    return newTask;
  }

  Task? getTaskbyId(int id){
    if (tasks[id] == null){
      return null;
    }
    return tasks[id];
  }

  //update
  void updateTask(int id, {String? newDescription, DateTime? newDueDate}){
    Task? task = getTaskbyId(id);
    
    if (task == null){
      print("${id} task not found");
      return;
    }
    
    if(newDescription != null){
      task.settaskDescription = newDescription;
    }
    
    if (newDueDate != null){
      task.setdueDate = newDueDate;
    }
    
    print('${task.getId} is updated');
  }


  //remove
  void removeTask(int id){
    Task? task = getTaskbyId(id);

    if (task == null){
      print("${id} doest exist");
      return;
    }

    tasks.remove(task);
    saveToFile();
    print('${task.getId} is removed');
  }

void listAllTasks(){
    if (tasks.isEmpty){
      print("empty");
      return;
    } else {
      for (var task in tasks){
        print(task.toString());
      }
    }
}

  // Future<void> saveToFile() async {
  //   final file = File(filepath);
  //   try {
  //     // Clear the file first
  //     await file.writeAsString('', mode: FileMode.write);
  //
  //     // Write all tasks
  //     for (var task in tasks) {
  //       // You can customize the format (e.g., JSON, CSV, etc.)
  //       String taskString = '${task.getId},${task.gettaskDescription},${task.gettaskCreation},${task.dueDate}\n';
  //       await file.writeAsString(taskString, mode: FileMode.append);
  //     }
  //     print('Tasks saved to file.');
  //   } catch (e) {
  //     print('Error saving tasks to file: $e');
  //   }
  // }

  Future<void> saveToFile() async {
    try {
      // Get the external storage directory for the app-specific files
      Directory externalDir = Directory(
          '/storage/emulated/0/Android/data/com.example.introdcution/files/');

      // Make sure the directory exists
      if (!await externalDir.exists()) {
        await externalDir.create(recursive: true);
      }

      // Create or open the file
      final file = File('${externalDir.path}/tasklists.txt');

      // Convert tasks to a string format for saving
      String taskData = tasks.map((task) {
        return '${task.getId},${task.gettaskDescription},${task.gettaskCreation},${task.dueDate}';
      }).join('\n');

      // Write to file
      await file.writeAsString(taskData, mode: FileMode.write);
      print('Tasks saved to external storage.');
    } catch (e) {
      print('Error saving tasks to file: $e');
    }
  }

  Future<void> loadFromFile() async {
    final file = File(filepath);

    try {
      // Check if the file exists before attempting to read it
      if (await file.exists()) {
        List<String> lines = await file.readAsLines();  // Read file lines
        for (var line in lines) {
          // Split the line by commas (customize this based on your file format)
          List<String> parts = line.split(',');

          if (parts.length >= 3) {
            // Parse the values from the line
            int id = int.parse(parts[0]);
            String taskDescription = parts[1];
            DateTime taskCreation = DateTime.parse(parts[2]);
            DateTime dueDate = DateTime.parse(parts[3]);

            // Create and add the task object
            Task task = Task(id,taskDescription,taskCreation,dueDate);
            tasks.add(task);
          }
        }
        print('Tasks loaded from file.');
      } else {
        print('File does not exist.');
      }
    } catch (e) {
      print('Error reading tasks from file: $e');
    }
  }

}