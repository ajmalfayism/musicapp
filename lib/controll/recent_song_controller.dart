import 'package:flutter/material.dart';
import 'package:flutter_application_1/allsongs/allsongs.dart';
import 'package:hive/hive.dart';

import 'package:on_audio_query/on_audio_query.dart';

class GetRecentSongController extends ChangeNotifier {
  static ValueNotifier<List<SongModel>> recentSongNotifier = ValueNotifier([]);
  static List<dynamic> recentlyPlayed = [];

  static Future<void> addRecentlyPlayed(item) async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    await recentDb.add(item);
    getRecentSongs();
    recentSongNotifier.notifyListeners();
  }

  static Future<void> getRecentSongs() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    recentlyPlayed = recentDb.values.toList();
    displayRecents();
    recentSongNotifier.notifyListeners();
  }

  static Future<void> displayRecents() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    final recentSongItems = recentDb.values.toList();
    recentSongNotifier.value.clear();
    recentlyPlayed.clear();
    for (int i = 0; i < recentSongItems.length; i++) {
      for (int j = 0; j < startSong.length; j++) {
        if (recentSongItems[i] == startSong[j].id) {
          recentSongNotifier.value.add(startSong[j]); //uimttmvran
          recentlyPlayed.add(startSong[j]);
        }
      }
    }
  }
}