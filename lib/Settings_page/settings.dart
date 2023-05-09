import 'package:flutter/material.dart';
import 'package:flutter_application_1/Settings_page/privacy_policy.dart';
import 'package:flutter_application_1/Settings_page/termsand_contition.dart';
import 'package:flutter_application_1/playlist/playlist_db.dart';
import 'package:share_plus/share_plus.dart';
import '../controll/get_all_song_controll.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 10, 90),

      // appBar: AppBar(
      //   title: const Text('Settings'),
      // ),

      body: SafeArea(
        child: Column(
          children: [
            // About us
            Container(
              margin:
                  const EdgeInsets.only(right: 3, left: 3, top: 20, bottom: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                title: const Text(
                  'About Us',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Music World'),
                        contentPadding: const EdgeInsets.all(20),
                        children: [
                          const Text(
                            'Welcome to Music World App, make your life more live.We are dedicated to providing you the very best quality of sound and the music varient,with an emphasis on new features. playlists and favourites,and a rich user experience\n\n Founded in 2023 by Ajmal Fayis M . Music World app is our first major project with a basic performance of music hub and creates a better versions in future.Music World gives you the best music experience that you never had. it includes attractivemode of UI\'s and good practices.\n\nIt gives good quality and had increased the settings to power up the system as well as to provide better music rythms.\n\nWe hope you enjoy our music as much as we enjoy offering them to you.If you have any questions or comments, please don\'t hesitate to contact us.\n\nSincerely,\n\nAjmal Fayis M',
                            style: TextStyle(fontSize: 18),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Ok')),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            // / share
            ListTile(
              leading: const Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: const Text(
                'Share',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                FutureBuilder(
                  future: Future.delayed(const Duration(microseconds: 30), () {
                    return Share.share('https://play.google.com/store/games');
                  }),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.data;
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.lock_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.text_snippet,
                color: Colors.white,
              ),
              title: const Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TermsAndConditionScreen(),
                ));
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.restart_alt_sharp,
                color: Colors.white,
              ),
              title: const Text(
                'Reset',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text(
                        'Reset App',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: const Text(
                        """Are you sure do you want to reset the App?Your saved data will be deleted. """,
                        style: TextStyle(fontSize: 15),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            PlaylistDb.resetAPP(context);
                            GetAllSongController.audioPlayer.stop();
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'Version',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  Text(
                    '2.0.1',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    'Powered by AJ',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
