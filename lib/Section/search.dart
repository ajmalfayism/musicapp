


import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Allsongs/Allsongs.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

List<SongModel> allsongs = [];
List<SongModel> foundSongs = [];
final audioQuery = OnAudioQuery();

@override
class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    songsLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromARGB(255, 39, 10, 90),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:const Color.fromARGB(255, 39, 10, 90),
        title: TextField(
          textAlign: TextAlign.start,
          onChanged: (value) => updateList(value),
          style: const  TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              counterStyle: const TextStyle(
                  // color: Colors.white,
                  ),
              fillColor: Colors.transparent,
              filled: true,
              hintText: 'Search Song',
              hintStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none)),
        ),
      ),
      body: foundSongs.isNotEmpty
          ? ListTileWidget(songmodel: foundSongs)
          : const Center(child: Text("No Songs Found",style: TextStyle(color: Colors.white),)),
    );
  }

  void songsLoading() async {
    allsongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    setState(() {
      foundSongs = allsongs;
    });
  }

  void updateList(String enteredText) {
    List<SongModel> results = [];
    if (enteredText.isEmpty) {
      setState(() {
         results = allsongs;
      });
     
    } else {
      results = allsongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .trim()
              .contains(enteredText.toLowerCase().trim()))
          .toList();
    }
    setState(() {
      foundSongs = results;
    });
  }
}
