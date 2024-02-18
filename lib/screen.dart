import 'package:flutter/material.dart';
import 'package:mob_pit/add_contacts.dart';
import 'package:mob_pit/nmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'demo.dart';
import 'helper.dart';

class ListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  bool hasData = false;
  List<Note> note = [];
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Academic Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: DBHElper.readNote(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('No Note Yet'),
            );
          }
          if (snapshot.data!.isEmpty) {
            hasData = true;
          } else {
            hasData = true;
          }
          return snapshot.data!.isEmpty ? AlertDialog(
            title: Text('Hello User please Register Your Identity'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildTextField(_titleController, 'Title'),
                    SizedBox(height: 30),
                    _buildTextField(_subjectController, 'subject'),
                    SizedBox(height: 30),
                    _buildTextField(_dateController, 'date'),
                    SizedBox(height: 30),
                    _buildTextField(_descriptionController, 'description'),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DBHElper.createNote(Note(
                            title: _titleController.text,
                            subject: _subjectController.text,
                            date: _dateController.text,
                            description: _descriptionController.text,
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => super.widget,
                            ),
                          );
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          )
              : ListView(
            children: snapshot.data!.map((note) {
              return ListTile(
                trailing: snapshot.data!.first.title != note.title &&
                    snapshot.data!.length > 1 ||
                    snapshot.data!.length == 1
                    ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete contact'),
                          content: Text('Are you sure you want'
                              ' to delete this contact?'),
                          actionsAlignment:
                          MainAxisAlignment.spaceBetween,
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Database db =
                                await DBHElper.initDB();
                                db.rawDelete(
                                  'DELETE FROM contacts where id ="${note.id}"',
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => super.widget,
                                  ),
                                );
                              },
                              child: const Text('Delete'),
                            ),
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
                    : null,
                onTap: () async {
                  final bool? refresh =
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => NoteScreen(
                      index: snapshot.data!.first.title ==
                          note.title
                          ? 0
                          : null,
                      note: Note(
                        id: note.id,
                        title: note.title,
                        subject: note.subject,
                        date: note.date,
                        description: note.description,
                      ),
                    ),
                  ));
                  if (refresh != null) {
                    setState(() {
                      //if return true, rebuild whole widget
                    });
                  }
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final refresh = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteScreen()));
          if (refresh != null) {
            setState(() {
              //if return true, rebuild whole widget
            });
          }
        },
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController _controller,
      String hint) {
    return TextFormField(
      validator: (value) {
        return value == "" || value == null ? "Please enter your $hint" : null;
      },
      keyboardType: hint == 'note' ? TextInputType.phone : null,
      controller: _controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
