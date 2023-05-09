import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/allsongs/allsongs.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetMostlyPlayedController {
  static ValueNotifier<List<SongModel>> mostlyPlayedNotifier =
      ValueNotifier([]);
  static List<dynamic> mostlyPlayed = [];
   static List<SongModel> mostlyPlayedsongs = [];

  static Future<void> addMostlyPlayed(item) async {
    final mostlyplayedDb = await Hive.openBox('MostlyPlayedNotifier');
    await mostlyplayedDb.add(item);
    getMostlyplayed();
    mostlyPlayedNotifier.notifyListeners();
  }

  static Future<void> getMostlyplayed() async {
    final mostlyplayedDb = await Hive.openBox('MostlyPlayedNotifier');
    mostlyPlayed = mostlyplayedDb.values.toList();
    displayMostlyPlayed();
    mostlyPlayedNotifier.notifyListeners();
  }

  static Future<List> displayMostlyPlayed() async {
    final mostlyPlayedDb = await Hive.openBox('MostlyPlayedNotifier');
    final mostlyPlayedItems = mostlyPlayedDb.values.toList();
    mostlyPlayedNotifier.value.clear();
    int count = 0;
    for (var i = 0; i < mostlyPlayedItems.length; i++) {
      for (var j = 0; j < mostlyPlayedItems.length; j++) {
        if (mostlyPlayedItems[i] == mostlyPlayedItems[j]) {
          count++;
        }
      }
      if (count > 3) {
        for (var k = 0; k < startSong.length; k++) {
          if (mostlyPlayedItems[i] == startSong[k].id) {
            mostlyPlayedNotifier.value.add(startSong[k]);
            mostlyPlayed.add(startSong[k]);
          }
        }
        count = 0;
      }
    }
    return mostlyPlayed;
  }
}