import 'package:flutter/material.dart';
import 'package:flutter_application_1/controll/get_all_song_controll.dart';
import 'package:flutter_application_1/databas/Favoritedb.dart';
import 'package:flutter_application_1/nowplaying/nowplaying.dart';
import 'package:flutter_application_1/provide/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListTileWidget extends StatefulWidget {
  ListTileWidget({super.key, required this.songModel});

  List<SongModel> songModel;

  @override
  State<ListTileWidget> createState() => _ListTileWidgetState();
}

class _ListTileWidgetState extends State<ListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.songModel.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(left: 3, right: 3, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Color.fromARGB(255, 132, 63, 252),
        ),
        child: ListTile(
          title: Text(
            widget.songModel[index].displayNameWOExt,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          subtitle: Text(
            "${widget.songModel[index].artist}",
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
              onPressed: () {
                showBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.black,
                        child: ValueListenableBuilder(
                            valueListenable: FavoriteDb.favoriteSongs,
                            builder: (context, List<SongModel> favoriteSongs,
                                Widget? child) {
                              return Column(
                                //  crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                      onPressed: () {
                                        if (FavoriteDb.isFavor(
                                            widget.songModel[index])) {
                                          FavoriteDb.delete(
                                              widget.songModel[index].id);
                                          // ignore: unused_local_variable
                                          var remove = ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(const SnackBar(
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.red,
                                                  content: Text('Removed')));

                                          FavoriteDb.favoriteSongs
                                              .notifyListeners();
                                          Navigator.of(context).pop();
                                        } else {
                                          FavoriteDb.add(widget.songModel[index]);
                                          var ADD =
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      duration:
                                                          Duration(seconds: 3),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 0, 255, 13),
                                                      content: Text('SAVED')));

                                          Navigator.of(context).pop();
                                        }
                                        FavoriteDb.favoriteSongs
                                            .notifyListeners();
                                      },
                                      icon: FavoriteDb.isFavor(widget.songModel[index])
                                          ? const Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite,
                                              color: Colors.white,
                                            ),
                                      label: const Text("Favourite"))
                                ],
                              );
                            }),
                      );
                    });
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              )),
          leading: QueryArtworkWidget(
            id: widget.songModel[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note),
          ),
          onTap: () {
            GetAllSongController.audioPlayer.setAudioSource(
              GetAllSongController.createSongList(widget.songModel),
              initialIndex: index,
            );
            context.read<SongModelProvider>().setid(widget.songModel[index].id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NowPlaying(
                  songModel: widget.songModel,
                  count: widget.songModel.length,
                ),
              ),
            );
          },
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(
        height: 5,
      ),
    );
  }
}
