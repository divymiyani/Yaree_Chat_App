import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yaree_chat_app/main.dart';
import 'package:yaree_chat_app/models/message.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key, required this.message});

  final Message message;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: mq.width * .5,
        height: mq.height * .3,
        imageUrl: widget.message.msg,
        placeholder: (context, url) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Icon(Icons.image, size: 70),
      ),
    );
  }
}
