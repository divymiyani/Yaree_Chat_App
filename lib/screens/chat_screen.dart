import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yaree_chat_app/api/apis.dart';
import 'package:yaree_chat_app/helper/my_date_util.dart';
import 'package:yaree_chat_app/main.dart';
import 'package:yaree_chat_app/models/chat_user.dart';
// ignore: unused_import
import 'package:flutter/src/rendering/box.dart';
import 'package:yaree_chat_app/models/message.dart';
import 'package:yaree_chat_app/screens/view_profile_screen.dart';
import 'package:yaree_chat_app/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all message
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isuploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if search is on & back button is pressed then close search
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },

          child: Scaffold(
            //app bar
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),

            backgroundColor: Color.fromARGB(255, 234, 241, 253),

            //body
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return SizedBox();

                        //if some or data is loaded then show it.
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          // for (var i in data!) {
                          //   // log('Data: ${i.data()}');
                          //   log('Data: ${jsonEncode(i.data())}');
                          //   list.add(i.data()['name']);
                          // }

                          // _list.clear();

                          // _list.add(Message(
                          //   msg: 'Hi',
                          //   read: '',
                          //   told: 'aakash',
                          //   type: Type.text,
                          //   sent: '12:00 AM',
                          //   fromId: APIs.user.uid,
                          // ));
                          // _list.add(Message(
                          //   msg: 'Hiii',
                          //   read: '',
                          //   told: APIs.user.uid,
                          //   type: Type.text,
                          //   sent: '12:02 AM',
                          //   fromId: 'xyz',
                          // ));

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              // padding: EdgeInsets.only(top: mq.width * .015),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  'Say Hii..👋',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                //progress indicator for showing uploding
                if (_isUploading)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))),

                //chat input filed
                _chatInput(),

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Color.fromARGB(255, 234, 241, 253),
                        columns: 9,
                        // initCategory: Category.SMILEYS,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return Padding(
        padding: EdgeInsets.only(top: mq.height * .01),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ViewProfileScreen(user: widget.user)));
            },
            child: StreamBuilder(
              stream: APIs.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];

                return Row(
                  children: [
                    //back button
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: Colors.white)),

                    //user profile picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .03),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        width: mq.height * .05,
                        height: mq.height * .05,
                        imageUrl:
                            list.isNotEmpty ? list[0].image : widget.user.image,
                        errorWidget: (context, url, error) =>
                            CircleAvatar(child: Icon(CupertinoIcons.person)),
                      ),
                    ),

                    //for adding some space
                    SizedBox(width: 10),

                    //user name & last seen time
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //user name
                        Text(list.isNotEmpty ? list[0].name : widget.user.name,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),

                        //for adding some space
                        SizedBox(height: 2),

                        //user seen time of user
                        Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? 'online'
                                    : MyDateUtil.getLastActiveTime(
                                        context: context,
                                        lastActive: list[0].lastActive)
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: widget.user.lastActive),
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                      ],
                    )
                  ],
                );
              },
            )));
  }

  //bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .015),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: Icon(Icons.emoji_emotions, color: Colors.white)),

                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white), //<-- SEE HERE

                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none),
                    ),
                  ),

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
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = true);
                        }
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 26,
                      )),

                  //adding space
                  SizedBox(
                    width: mq.width * .02,
                  ),

                  //sand message icon button
                  // IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.send_sharp, color: Colors.green)),
                ],
              ),
            ),
          ),

          //sand message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply sent message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}
