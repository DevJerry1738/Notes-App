import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/notes_screen.dart';
import 'package:uuid/uuid.dart';

class AddNote extends StatefulWidget {
  final String title;
  const AddNote({super.key, required this.title});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String noteTitle;
  late String content;
  late String noteId;
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  bool processing = false;

  void addNote() async {
    if (formKey.currentState!.validate()) {
      noteId = const Uuid().v4();
      setState(() {
        processing = true;
      });
      try {
        await notes.doc(noteId).set({
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            processing
                ? const CircularProgressIndicator(
                    color: Colors.purpleAccent,
                  )
                : IconButton(
                    onPressed: () {
                      addNote();
                    },
                    icon: const Icon(Icons.save))
          ],
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    noteTitle = value;
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
                  onChanged: (value) {
                    content = value;
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
                        borderSide:
                            const BorderSide(color: Colors.purple, width: 1),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 2),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      label: const Center(child: Text('content'))),
                ),
                // processing
                //     ? const CircularProgressIndicator(
                //         color: Colors.purpleAccent,
                //       )
                //     : TextButton(
                //         onPressed: () {
                //           addNote();
                //         },
                //         child: Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
