import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'notes_screen.dart';

class EditNote extends StatefulWidget {
  final String noteId;
  const EditNote({super.key, required this.noteId});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String noteTitle;
  late String content;
  late String noteId;

  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  bool processing = false;

  void saveNote() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      noteId = const Uuid().v4();
      setState(() {
        processing = true;
      });
      try {
        await notes.doc(noteId).update({
          'title': noteTitle,
          'content': content,
          'noteid': noteId,
          'timestamp': Timestamp.now(),
        });
        print(noteTitle);
        print(content);
        setState(() {
          processing = false;
        });
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NotesScreen()));
      } catch (e) {
        setState(() {
          processing = false;
        });
        print(e);
      }
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: notes.doc(widget.noteId).get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Note'),
                    processing
                        ? const CircularProgressIndicator(
                            color: Colors.purpleAccent,
                          )
                        : IconButton(
                            onPressed: () {
                              saveNote();
                            },
                            icon: const Icon(Icons.save))
                  ],
                ),
              ),
              body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller:
                              TextEditingController(text: data['title']),
                          onSaved: (value) {
                            noteTitle = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter title';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller:
                              TextEditingController(text: data['content']),
                          onSaved: (value) {
                            content = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter content';
                            } else {
                              return null;
                            }
                          },
                          maxLines: 30,
                          maxLength: 1000,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.purple, width: 1),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepPurpleAccent, width: 2),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              label: const Center(child: Text('content'))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Colors.purpleAccent,
                  ),
                  Text('loading...')
                ],
              ),
            ),
          );
        });
  }
}
