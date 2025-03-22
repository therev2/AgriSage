import 'package:agrisage/Features/Dashboard/Models/task_model.dart';

class TaskService {
  // In-memory storage for tasks
  final List<Task> _tasks = [];

  // Get all tasks
  List<Task> getAllTasks() {
    return List.from(_tasks);
  }

  // Get active (non-completed) tasks
  List<Task> getActiveTasks() {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  // Get tasks due today
  List<Task> getTasksDueToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _tasks.where((task) {
      final dueDate =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      return dueDate.isAtSameMomentAs(today);
    }).toList();
  }

  // Add a new task
  void addTask(Task task) {
    _tasks.add(task);
  }

  // Update an existing task
  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  // Get tasks by priority
  List<Task> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  // Get tasks by category
  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  // Get completed tasks
  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  // Toggle task completion status
  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    }
  }
}
