import 'package:flutter/material.dart';
import 'package:flutter_application_1/splashscreen/splashscreen.dart';
import 'package:hive/hive.dart';
import '../databas/Favoritedb.dart';
import '../databas/model_db.dart';



class PlaylistDb extends ChangeNotifier {
  static ValueNotifier<List<MusicWorld>> playlistNotifier = ValueNotifier([]);
  static final playlistDb = Hive.box<MusicWorld>('playlistDb');

  static Future<void> addPlaylist(MusicWorld value) async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  static Future<void> editPlaylist(int index, MusicWorld value) async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
  }

  static void resetAPP(BuildContext context) {}

  
}
