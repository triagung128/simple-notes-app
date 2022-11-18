import 'package:flutter/material.dart';

import 'db_helper.dart';
import 'note.dart';

class DbProvider extends ChangeNotifier {
  List<Note> _notes = [];
  late DbHelper _dbHelper;

  List<Note> get notes => _notes;

  DbProvider() {
    _dbHelper = DbHelper();
    _getAllNotes();
  }

  void _getAllNotes() async {
    _notes = await _dbHelper.getNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _dbHelper.insertNote(note);
    _getAllNotes();
  }

  Future<Note> getNoteById(int id) async {
    return await _dbHelper.getNoteById(id);
  }

  void updateNote(Note note) async {
    await _dbHelper.updateNote(note);
    _getAllNotes();
  }

  void deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _getAllNotes();
  }
}
