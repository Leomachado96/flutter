import 'package:flutter/material.dart';
import 'package:projeto/models/teste_model.dart';
import 'package:projeto/services/task_service.dart';
import 'package:projeto/views/form_view_tasks.dart';

class ListViewTasks extends StatefulWidget {
  const ListViewTasks({super.key});

  @override
  State<ListViewTasks> createState() => _ListViewTasksState();
}

class _ListViewTasksState extends State<ListViewTasks> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  getAllTasks() async {
    tasks = await taskService.getTasks();

    setState(() {});
  }

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas'),
        ),
        body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              bool localIsDone = tasks[index].isDone ?? false;
              return Column(children: [
                Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tasks[index].title.toString(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: localIsDone
                                          ? Colors.green
                                          : Colors.grey),
                                ),
                                Radio(
                                    value: false,
                                    groupValue: false,
                                    onChanged: (value) {})
                              ],
                            ),
                            Checkbox(
                              value: tasks[index].isDone ?? false,
                              onChanged: (value) async {
                                if (value != null) {
                                  await taskService.editTask(
                                      index,
                                      tasks[index].title!,
                                      tasks[index].description!,
                                      value);
                                  setState(() {
                                    tasks[index].isDone = value;
                                  });
                                }
                              },
                            ),
                            Text(tasks[index].title.toString(),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FormTasks(
                                                  task: tasks[index],
                                                  index: index)));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 123, 168, 239),
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      await taskService.deleteTask(index);
                                      getAllTasks();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 232, 9, 9),
                                    )),
                              ],
                            )
                          ],
                        )))
              ]);
            }));
  }
}
