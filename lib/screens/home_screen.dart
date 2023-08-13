import 'package:flutter/material.dart';
import 'package:notes/screens/add_note.dart';
import 'notes_screen.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NoteButton(
                title: 'Add Notes',
                iconData: Icons.add,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AddNote(title: 'Add Note')));
                }),
            NoteButton(
                title: 'view Notes',
                iconData: Icons.notes,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotesScreen(),
                      ));
                })
          ],
        ),
      ),
      //
    );
  }
}

class NoteButton extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function() onPressed;
  const NoteButton(
      {super.key,
      required this.title,
      required this.iconData,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(30)),
        height: 200,
        width: 150,
        child: TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 50,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20, letterSpacing: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
