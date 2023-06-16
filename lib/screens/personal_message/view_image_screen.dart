import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image View'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement share image logic
            },
            icon: Icon(Icons.share),
            label: Text('Share'),
          ),
        ],
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
