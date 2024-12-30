import 'package:emo_sense/Pages/NotepadPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool _isSelectionMode = false;
  Set<String> _selectedNoteIds = {};

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final notesRef = FirebaseDatabase.instance.ref().child('users/$uid/notes');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade400,
        automaticallyImplyLeading: false,
        title: Text(
          'NotePad',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: _isSelectionMode
            ? [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              final shouldDelete = await _showConfirmationDialog(context);
              if (shouldDelete) {
                // Delete selected notes
                for (String noteId in _selectedNoteIds) {
                  await notesRef.child(noteId).remove();
                }
                setState(() {
                  _isSelectionMode = false;
                  _selectedNoteIds.clear();
                });
              }
            },
          ),
        ]
            : null,
      ),
      backgroundColor: Colors.black87,
      floatingActionButton: !_isSelectionMode
          ? FloatingActionButton(
        elevation: 2,
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        child: Icon(
          size: 30,
          Icons.add,
          color: Colors.purple.shade400,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotePadPage(noteId: null)),
          );
        },
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: StreamBuilder(
        stream: notesRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('No notes found.', style: TextStyle(color: Colors.white)),
            );
          }

          final notes = (snapshot.data!.snapshot.value as Map?) ?? {};
          final noteEntries = notes.entries.toList();

          return ListView.separated(
            itemCount: noteEntries.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade700),
            itemBuilder: (context, index) {
              final note = noteEntries[index];
              final noteId = note.key;
              final noteData = note.value as Map;

              return ListTile(
                leading: _isSelectionMode
                    ? Checkbox(
                  value: _selectedNoteIds.contains(noteId),
                  onChanged: (bool? isChecked) {
                    setState(() {
                      if (isChecked == true) {
                        _selectedNoteIds.add(noteId);
                      } else {
                        _selectedNoteIds.remove(noteId);
                      }
                    });
                  },
                )
                    : null,
                title: Text(
                  noteData['title'] ?? 'Untitled',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  noteData['timestamp'] ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                onTap: () {
                  if (_isSelectionMode) {
                    setState(() {
                      if (_selectedNoteIds.contains(noteId)) {
                        _selectedNoteIds.remove(noteId);
                      } else {
                        _selectedNoteIds.add(noteId);
                      }
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotePadPage(
                          noteId: noteId,
                          initialTitle: noteData['title'],
                          initialContent: noteData['content'],
                        ),
                      ),
                    );
                  }
                },
                onLongPress: () {
                  setState(() {
                    _isSelectionMode = true;
                    _selectedNoteIds.add(noteId);
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Notes"),
        content: Text("Are you sure you want to delete the selected notes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirm
            child: Text("Delete"),
          ),
        ],
      ),
    ) ??
        false;
  }
}
