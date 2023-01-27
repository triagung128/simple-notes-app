import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/db_provider.dart';
import '../utils/styles.dart';
import 'note_add_update_page.dart';
import 'package:simple_note_app/models/note.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        toolbarHeight: 80,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Notes',
            style: whiteTextStyle.copyWith(
              fontSize: 43,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Consumer<DbProvider>(
        builder: (context, provider, child) {
          final notes = provider.notes;

          if (notes.isEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/empty_data.png',
                    width: 350,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Create your first note !',
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (_, __) => const Divider(
                thickness: 0.2,
                height: 1,
              ),
              itemCount: notes.length,
              padding: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
              ),
              itemBuilder: (context, index) {
                final note = notes[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Slidable(
                    key: Key(note.id.toString()),
                    endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          autoClose: true,
                          onPressed: (context) {
                            _showConfirmDelete(context, provider, note);
                          },
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        final selectedNote =
                            await provider.getNoteById(note.id!);

                        navigator.push(
                          MaterialPageRoute(
                            builder: (context) {
                              return NoteAddUpdatePage(
                                note: selectedNote,
                              );
                            },
                          ),
                        );
                      },
                      child: ListTile(
                        tileColor: const Color(0xffFFF599),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(24),
                        title: Text(
                          note.title,
                          style: blackTextStyle.copyWith(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blackColor,
        elevation: 10,
        child: const Icon(
          Icons.add,
          size: 42,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteAddUpdatePage(),
            ),
          );
        },
      ),
    );
  }

  _showConfirmDelete(
    BuildContext context,
    DbProvider provider,
    Note note,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(
          Icons.warning_rounded,
          size: 36,
          color: greyColor,
        ),
        iconPadding: const EdgeInsets.only(top: 40),
        contentPadding: const EdgeInsets.all(24),
        content: Text(
          'Apakah Anda ingin menghapus ?',
          style: greyTextStyle.copyWith(fontSize: 23),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.only(bottom: 38),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(112, 39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: redColor,
            ),
            child: Text(
              'Tidak',
              style: whiteTextStyle.copyWith(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteNote(note.id!);
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Berhasil menghapus',
                    ),
                  ),
                );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(112, 39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: greenColor,
            ),
            child: Text(
              'Ya',
              style: whiteTextStyle.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
