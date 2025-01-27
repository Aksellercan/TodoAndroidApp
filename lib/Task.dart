class Task {

  int _id;
  String _taskDescription;
  DateTime taskCreation;
  DateTime dueDate;

  //constructor
  Task(this._id, this._taskDescription, this.taskCreation,this.dueDate);

  //getters
  String get gettaskDescription{
    return _taskDescription;
  }

  DateTime get gettaskCreation{
    return taskCreation;
  }

  DateTime get getDueDate{
    return dueDate;
  }

  int get getId{
    return _id;
  }

  //setters

set settaskDescription(String _taskDescription){
    this._taskDescription = _taskDescription;
}
set setdueDate(DateTime dueDate){
    this.dueDate = dueDate;
  }

  set setId(int _id){
    this._id = _id;
  }

  set settaskCreation(DateTime taskCreation){
    this.taskCreation = taskCreation;
  }

  @override
  String toString() {
    return 'Task{id: $_id, task: $_taskDescription, created: $taskCreation, due: $dueDate}';
  }
}