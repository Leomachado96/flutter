import 'package:flutter/material.dart';
import 'package:projeto/models/teste_model.dart';
import 'package:projeto/services/task_service.dart';

class FormTasks extends StatefulWidget {
  final Task? task;
  final int? index;

  const FormTasks({super.key, this.task, this.index});

  @override
  State<FormTasks> createState() => _FormTasksState();
}

class _FormTasksState extends State<FormTasks> {
  final _formKey = GlobalKey<FormState>();
  final TaskService taskService = TaskService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title!;

      _descriptionController.text = widget.task!.description!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Tarefa'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  label: const Text('Título da Tarefa'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Título não preenchido!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  label: const Text('Descrição da Tarefa'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String title = _titleController.text;
                    String description = _descriptionController.text;

                    if (widget.task != null && widget.index != null) {
                      await taskService.editTask(
                          widget.index!, title, description, false);
                    } else {
                      await taskService.saveTask(title, description);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Tarefa salva com sucesso!')),
                    );
                  }
                },
                child: const Text('Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
