import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseVideoPage extends StatelessWidget {
  final List<String> videoLinks = [
    'https://www.youtube.com/watch?v=iNxlTO--6Fo&pp=ygUaa2FubmFkYSBwaHlzaW90aGVyYXB5IHRpcHM%3D',
    "https://www.youtube.com/watch?v=mmYdAKjNVJc&pp=ygUaa2FubmFkYSBwaHlzaW90aGVyYXB5IHRpcHM%3D",
    "https://www.youtube.com/watch?v=ai3FqJcLGs8&pp=ygUVa2FubmFkYSBwaHlzaW90aGVyYXB5",
    "https://www.youtube.com/watch?v=DxCwuU-HGXs&pp=ygUVa2FubmFkYSBwaHlzaW90aGVyYXB5",
    "https://www.youtube.com/watch?v=caZ8I42iQQo&pp=ygUgdGlwcyBmb3IgaG9tZSBwaHlzaW90aGVyYXB5IGV4YW0%3D",
    "https://www.youtube.com/watch?v=wtMBPbYC7us&pp=ygUTbmV1cm8gcGh5c2lvdGhlcmFweQ%3D%3D",
    "https://www.youtube.com/watch?v=Nvs0avvo8hs&pp=ygUUY2FyZGlvIHBoeXNpb3RoZXJhcHk%3D",
    "https://www.youtube.com/watch?v=jQQ_yOVenRs&pp=ygUTb3J0aG8gcGh5c2lvdGhlcmFweQ%3D%3D",
    'https://www.youtube.com/watch?v=N3fH9b7oZHc&pp=ygUbcGh5c2lvdGhlcmFweSBzaG91bGRlciBwYWlu',
    'https://www.youtube.com/watch?v=XXwXJ1IAzxc&pp=ygUbcGh5c2lvdGhlcmFweSBzaG91bGRlciBwYWlu',
  ];

  ExerciseVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exercising Videos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: videoLinks.length,
                itemBuilder: (context, index) {
                  final videoLink = videoLinks[index];
                  final videoId = videoLink.split("v=")[1].split("&")[0];
                  final thumbnailUrl =
                      'https://img.youtube.com/vi/$videoId/0.jpg';

                  return InkWell(
                    onTap: () async {
                      if (Platform.isAndroid) {
                        await launch(videoLink,
                            forceSafariVC: false,
                            forceWebView: false,
                            universalLinksOnly: false);
                      } else if (Platform.isIOS) {
                        if (await canLaunch(videoLink)) {
                          await launch(videoLink);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Could not launch video link')),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              thumbnailUrl,
                              width: MediaQuery.of(context).size.width - 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Video ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
