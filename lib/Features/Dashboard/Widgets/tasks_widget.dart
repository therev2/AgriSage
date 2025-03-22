import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Models/task_model.dart';
import 'package:agrisage/Features/Dashboard/Services/task_service.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/ColorPage.dart';

class TasksWidget extends StatefulWidget {
  final TaskService taskService;

  const TasksWidget({super.key, required this.taskService});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 1));
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Task Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'Task Statistics',
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTaskStat(
                          'Total',
                          widget.taskService.getAllTasks().length.toString(),
                          Colors.blue,
                        ),
                        _buildTaskStat(
                          'Completed',
                          widget.taskService
                              .getCompletedTasks()
                              .length
                              .toString(),
                          Colors.green,
                        ),
                        _buildTaskStat(
                          'Pending',
                          widget.taskService.getActiveTasks().length.toString(),
                          Colors.orange,
                        ),
                        _buildTaskStat(
                          'High Priority',
                          widget.taskService
                              .getTasksByPriority(TaskPriority.high)
                              .length
                              .toString(),
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isDesktop)
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddTaskDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPage.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          if (!isDesktop)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => _showAddTaskDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add New Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPage.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All Tasks'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
            labelColor: ColorPage.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: ColorPage.primaryColor,
          ),

          // Tab content
          SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(widget.taskService.getAllTasks()),
                _buildTaskList(widget.taskService.getActiveTasks()),
                _buildTaskList(widget.taskService.getCompletedTasks()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStat(String label, String count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No tasks found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: MediaQuery.of(context).size.width > 600
                  ? CircleAvatar(
                      backgroundColor:
                          _getPriorityColor(task.priority).withOpacity(0.2),
                      child: Icon(
                        Icons.flag,
                        color: _getPriorityColor(task.priority),
                      ),
                    )
                  : null,
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  fontWeight:
                      task.isCompleted ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.description),
                  const SizedBox(height: 4),
                  Wrap(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Due: ${_formatDate(task.dueDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              _getPriorityColor(task.priority).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _getPriorityText(task.priority),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getPriorityColor(task.priority),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        widget.taskService.toggleTaskCompletion(task.id);
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.taskService.deleteTask(task.id);
                      });
                    },
                  ),
                ],
              ),
              onTap: () => _showEditTaskDialog(task),
            ),
          ),
        );
      },
    );
  }

  void _showAddTaskDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedDueDate = DateTime.now().add(const Duration(days: 1));
    _selectedPriority = TaskPriority.medium;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Priority: '),
                    const SizedBox(width: 8),
                    DropdownButton<TaskPriority>(
                      value: _selectedPriority,
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem<TaskPriority>(
                          value: priority,
                          child: Text(_getPriorityText(priority)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Due Date: '),
                    const SizedBox(width: 8),
                    TextButton(
                      child: Text(_formatDate(_selectedDueDate)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDueDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDueDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                widget.taskService.addTask(Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dueDate: _selectedDueDate,
                  priority: _selectedPriority,
                ));
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _selectedDueDate = task.dueDate;
    _selectedPriority = task.priority;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Priority: '),
                  const SizedBox(width: 8),
                  DropdownButton<TaskPriority>(
                    value: _selectedPriority,
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                    items: TaskPriority.values.map((priority) {
                      return DropdownMenuItem<TaskPriority>(
                        value: priority,
                        child: Text(_getPriorityText(priority)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Due Date: '),
                  const SizedBox(width: 8),
                  TextButton(
                    child: Text(_formatDate(_selectedDueDate)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDueDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Status: '),
                  const SizedBox(width: 8),
                  Switch(
                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        widget.taskService.toggleTaskCompletion(task.id);
                      });
                    },
                    activeColor: ColorPage.primaryColor,
                  ),
                  Text(task.isCompleted ? 'Completed' : 'Pending'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                widget.taskService.updateTask(
                  task.id,
                  Task(
                    id: task.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: _selectedDueDate,
                    priority: _selectedPriority,
                    isCompleted: task.isCompleted,
                  ),
                );
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Update Task'),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
