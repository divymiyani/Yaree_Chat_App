import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yaree_chat_app/api/apis.dart';
import 'package:yaree_chat_app/main.dart';
import 'package:yaree_chat_app/models/chat_user.dart';
import 'package:yaree_chat_app/screens/chat_screen.dart';
import 'package:yaree_chat_app/screens/view_profile_screen.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  //isuploading -- for checking if image is uploading or not?
  // ignore: unused_field
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AlertDialog(
          backgroundColor: Colors.white.withOpacity(.8),
          insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: mq.width * .6,
            height: mq.height * .33,
            child: Stack(
              children: [
                //user profile picture
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(mq.height * .01),
                        topRight: Radius.circular(mq.height * .01)),
                    child: Container(
                      height: mq.height * .33,
                      width: mq.width * .68,
                      child: CachedNetworkImage(
                        // height: mq.height * .25,
                        // width: mq.width * .5,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) => CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),
                ),

                //user name
                Card(
                  color: Colors.transparent,
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: mq.width,
                    height: mq.height * 0.028,
                    child: Text(widget.user.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),

                //text overlay
                // Positioned(
                //   top: mq.height * .006,
                //   left: mq.width * .13,
                //   child: Text(
                //     user.name,
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.black,
          width: mq.width * .68,
          height: mq.height * .05,
          child: Card(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //pick image from gallery button
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      //pick multiple image
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      //uploading & sending image one by one
                      for (var i in images) {
                        setState(() => _isUploading = true);
                        log('Image Path: ${i.path}');
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: Icon(Icons.image, color: Colors.white)),

                //take image from camera button
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      //pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = true);
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 26,
                    )),

                //message icon button
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                    user: widget.user,
                                  )));
                    },
                    icon: Icon(Icons.message_outlined, color: Colors.white)),

                //Call icon button
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.call_rounded, color: Colors.white)),

                //Info icon button
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ViewProfileScreen(user: widget.user)));
                    },
                    icon:
                        Icon(Icons.info_outline_rounded, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}





















// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:yaree_chat_app/main.dart';
// import 'package:yaree_chat_app/models/chat_user.dart';

// class ProfileDialog extends StatefulWidget {
//   const ProfileDialog({super.key, required this.user, required this.context});

//   final ChatUser user;
//   final BuildContext context;

//   static Future<dynamic> createAlertDialog(
//       {required ChatUser user, required BuildContext context}) {
//     return showDialog(
//       context: context,
//       builder: (_) => ProfileDialog(
//         context: context,
//         user: user,
//       ),
//     );
//   }

//   @override
//   State<ProfileDialog> createState() => _ProfileDialogState();
// }

// class _ProfileDialogState extends State<ProfileDialog> {
//   ChatUser get user => widget.user;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       // width: mq.width * .3,
//       height: mq.height * .26,
//       child: Center(
//         child: Stack(
//           children: [
//             // Text(user.name,
//             //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//             //user profile picture
//             CachedNetworkImage(
//               width: mq.width * 0.5,
//               height: mq.height * 0.27,
//               fit: BoxFit.cover,
//               imageUrl: widget.user.image,
//               errorWidget: (context, url, error) => CircleAvatar(
//                 child: Icon(CupertinoIcons.person),
//               ),
//             ),

//             //text overlay
//             Positioned(
//               top: mq.height * .005,
//               left: mq.width * .10,
//               child: Text(
//                 user.name,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
