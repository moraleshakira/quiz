import 'package:flutter/material.dart';

class NoteAdd extends StatefulWidget {
  @override
  _NoteAddState createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note!'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              TextButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (selectedDate != null && selectedDate != _dateController.text) {
                    setState(() {
                      _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
                child: TextFormField(
                  controller: _dateController,
                  enabled: false, // To prevent manual editing
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),

              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Additional Notes'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? true) {
                    _submitForm();
                  }
                },
                child: Text('Save'),
              )


            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    String title = _titleController.text;
    String subject = _subjectController.text;
    String date = _dateController.text;
    String notes = _notesController.text;

    print('Title: $title');
    print('Subject: $subject');
    print('Date: $date');
    print('Additional Notes: $notes');
  }
}
