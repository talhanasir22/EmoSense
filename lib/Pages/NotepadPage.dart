import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotePadPage extends StatefulWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;

  NotePadPage({this.noteId, this.initialTitle, this.initialContent});

  @override
  State<NotePadPage> createState() => _NotePadPageState();
}

class _NotePadPageState extends State<NotePadPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  FocusNode noteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveNote() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final notesRef = FirebaseDatabase.instance.ref().child('users/$uid/notes');

    final title = titleController.text.isNotEmpty ? titleController.text : 'Untitled';
    final content = contentController.text;
    final timestamp = DateTime.now().toString();

    if (widget.noteId == null) {
      // Create new note
      notesRef.push().set({
        'title': title,
        'content': content,
        'timestamp': timestamp,
      });
    } else {
      // Update existing note
      notesRef.child(widget.noteId!).update({
        'title': title,
        'content': content,
        'timestamp': timestamp,
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveNote,
            icon: Icon(Icons.done, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Notes', style: TextStyle(color: Colors.white)),
      ),
      body: GestureDetector(

        onTap: (){
          noteFocusNode.requestFocus();
        },

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
                ),
              ),
              Text(
                DateTime.now().toString(),
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              TextField(
                controller: contentController,
                focusNode: noteFocusNode,
                maxLines: 100,
                minLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note something down',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              SizedBox(height: double.maxFinite,)
            ],
          ),
        ),
      ),
    );
  }
}
