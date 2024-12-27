import 'package:emo_sense/Pages/NotepadPage.dart';
import 'package:emo_sense/Pages/note_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (BuildContext context, NoteProviderModel, child)=>
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade400,
          automaticallyImplyLeading: false,
          title: Text(
            'NotePad',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Colors.black87,
        floatingActionButton: FloatingActionButton(
          elevation: 2,
          shape: CircleBorder(),
          backgroundColor: Colors.white,
          child: Icon(
            size: 30,
            Icons.add,
            color: Colors.purple.shade400,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NotePadPage()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Bottom right
        body: Center(
          child: ListView.separated(
            itemCount: NoteProviderModel.titleList.length,
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 1, // Height specifies the thickness of the separator
                  color: Colors.grey.shade700, // Color for the separator
                ),
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4, top: 4),
                child: ListTile(
                  title: Text(
                    NoteProviderModel.titleList[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '12/09',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotePadPage(
                          title: NoteProviderModel.titleList[index],
                          content: NoteProviderModel.contentList[index],
                        ),
                      ),
                    );
                  },


                ),
              );
            },
          ),


        ),
      ),
    );
  }
}
