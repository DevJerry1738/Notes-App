import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/edit_note.dart';

class NoteDetails extends StatefulWidget {
  final String noteId;
  const NoteDetails({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
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
                  Text(data['title']),
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditNote(noteId: data['noteid'])));
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data['content'],
                style: const TextStyle(fontSize: 20, fontFamily: 'Acme'),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.purpleAccent,
          ),
        );
      },
    );
  }
}
