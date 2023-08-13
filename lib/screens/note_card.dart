import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/note_details.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({Key? key}) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final Stream<QuerySnapshot> _notesStream = FirebaseFirestore.instance
      .collection('notes')
      .orderBy('timestamp', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _notesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return NotesCard(
                title: data['title'],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetails(
                        noteId: data['noteid'],
                      ),
                    ),
                  );
                });
          }).toList(),
        );
      },
    );
  }
}

class NotesCard extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const NotesCard({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: const Icon(Icons.notes),
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
                color: Colors.black, fontSize: 15, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
