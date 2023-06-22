import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaree_chat_app/helper/my_date_util.dart';
import 'package:yaree_chat_app/main.dart';
import 'package:yaree_chat_app/models/chat_user.dart';

//view profile screen  --  to view profile user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(title: Text(widget.user.name)),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Joined On :- ',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              MyDateUtil.getLastMessageTime(
                  context: context,
                  time: widget.user.createdAt,
                  showYear: true),
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ],
        ),

        //body
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mq.width * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),

                // User Profile Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    width: mq.height * .2,
                    height: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                SizedBox(height: mq.height * .03),

                //user email lable
                Text(
                  widget.user.name,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),

                //for space
                SizedBox(height: mq.height * .02),

                //user about
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'About:- ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
