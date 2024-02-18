import 'package:flutter/material.dart';
import 'package:mob_pit/nmodel.dart';
import 'package:mob_pit/helper.dart';
import 'package:mob_pit/screen.dart';
import 'demo.dart';

class NoteScreen extends StatefulWidget {
  NoteScreen({Key? key, this.index, this.note}) : super(key: key);

  final Note? note;
  final int? index;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _subjectController.text = widget.note!.subject;
      _dateController.text = widget.note!.date;
      _descriptionController.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.note != null ? "Edit" : "Add"} notes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTextField(_titleController, 'Title'),
                  SizedBox(height: 30),
                  _buildTextField(_subjectController, 'Subject'),
                  SizedBox(height: 20),
                  _buildTextField(_dateController, 'Date'),
                  SizedBox(height: 20),
                  _buildTextField(_descriptionController, 'Description'),
                  SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                      if (widget.note != null) {
                        await DBHElper.updateNote(Note(
                          id: widget.note!.id, // Have to add id here
                          title: _titleController.text,
                          subject: _subjectController.text,
                          date: _dateController.text,
                          description: _descriptionController.text,
                        ));
                      } else {
                        await DBHElper.createNote(Note(
                          title: _titleController.text,
                          subject: _subjectController.text,
                          date: _dateController.text,
                          description: _descriptionController.text,
                        ));
                      }
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ListScreen()),
    );

    }
                },
                child: Text('Save'),
              ),
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController _controller, String hint) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your $hint";
        }
        return null;
      },
      controller: _controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

}
