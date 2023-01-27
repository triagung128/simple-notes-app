import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/db_provider.dart';
import '../utils/styles.dart';

class NoteAddUpdatePage extends StatefulWidget {
  final Note? note;

  const NoteAddUpdatePage({super.key, this.note});

  @override
  State<NoteAddUpdatePage> createState() => _NoteAddUpdatePageState();
}

class _NoteAddUpdatePageState extends State<NoteAddUpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isUpdate = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _isUpdate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: blackColor2,
                      elevation: 0,
                      padding: const EdgeInsets.all(14),
                      minimumSize: Size.zero,
                      fixedSize: const Size(50, 50),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_isUpdate) {
                        final note = Note(
                          title: _titleController.text,
                          description: _descriptionController.text,
                        );

                        Provider.of<DbProvider>(context, listen: false)
                            .addNote(note);
                      } else {
                        final note = Note(
                          id: widget.note!.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                        );

                        Provider.of<DbProvider>(context, listen: false)
                            .updateNote(note);
                      }

                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Berhasil disimpan',
                            ),
                          ),
                        );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: blackColor2,
                      elevation: 0,
                      padding: const EdgeInsets.all(14),
                      minimumSize: Size.zero,
                      fixedSize: const Size(50, 50),
                    ),
                    child: const Icon(Icons.save),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        maxLines: null,
                        minLines: 1,
                        style: whiteTextStyle.copyWith(fontSize: 35),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Title',
                          hintStyle: greyTextStyle2.copyWith(fontSize: 48),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        minLines: 1,
                        style: whiteTextStyle.copyWith(fontSize: 23),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type something...',
                          hintStyle: greyTextStyle2.copyWith(fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
