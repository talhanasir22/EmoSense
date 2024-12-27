import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'note_provider.dart';

class NotePadPage extends StatefulWidget {
  final String? title;
  final String? content;

  NotePadPage({this.title, this.content});

  @override
  State<NotePadPage> createState() => _NotePadPageState();
}

class _NotePadPageState extends State<NotePadPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  FocusNode noteFocusNode = FocusNode();
  String formattedDateTime = '';
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed title and content
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);

    // Format the current date and time
    formattedDateTime = DateFormat('MM/dd/yyyy, hh:mma').format(DateTime.now());

    // Add listeners to text controllers
    titleController.addListener(_checkVisibility);
    contentController.addListener(_checkVisibility);
  }

  @override
  void dispose() {
    noteFocusNode.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (titleController.text.isNotEmpty || contentController.text.isNotEmpty) {
      setState(() {
        _isVisible = true;
      });
    } else {
      setState(() {
        _isVisible = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 600),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (BuildContext context, NoteProviderModel, child) => Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          actions: [
            if (_isVisible)
              IconButton(
                onPressed: () {
                  String titleStr = titleController.text.toString();
                  String contentStr = contentController.text.toString();
                  NoteProviderModel.addTitle(titleStr);
                  NoteProviderModel.addContent(contentStr);
                  titleController.clear();
                  contentController.clear();
                  showSnackBar(context, 'Noted Successfully');
                },
                icon: Icon(Icons.done, color: Colors.white),
              ),
          ],
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Notes',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            // Focus on the second TextField when tapping outside
            noteFocusNode.requestFocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title TextField
                TextField(
                  controller: titleController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    formattedDateTime,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Note TextField
                TextField(
                  controller: contentController,
                  focusNode: noteFocusNode,
                  maxLines: 100,
                  minLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Note something down',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                SizedBox(height: double.maxFinite),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
