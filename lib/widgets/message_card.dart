import 'dart:developer';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaree_chat_app/api/apis.dart';
import 'package:yaree_chat_app/helper/dialogs.dart';
import 'package:yaree_chat_app/helper/my_date_util.dart';
import 'package:yaree_chat_app/main.dart';
import 'package:yaree_chat_app/models/message.dart';
import 'package:yaree_chat_app/widgets/image_screen.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;

    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  //sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      children: [
        //message content
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .002),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 249, 255),
              //message border line
              border:
                  Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
              //making border curved
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          child: widget.message.type == Type.text
              ?
              //show text
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: mq.width * .010,
                          left: mq.width * .020,
                          bottom: mq.width * .010,
                          right: mq.width * .010),
                      child: Text(
                        widget.message.msg,
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                    SizedBox(width: mq.width * .015),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mq.width * .01,
                          right: mq.width * .01,
                          bottom: mq.width * .01),
                      child: Row(
                        children: [
                          //show time
                          Text(
                            MyDateUtil.getFormattedTime(
                                context: context, time: widget.message.sent),
                            style:
                                TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    )
                  ],
                )

              //show image
              : InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ImageScreen(
                                  message: widget.message,
                                )));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: mq.width * .5,
                          height: mq.height * .3,
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image, size: 70),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Row(
                          children: [
                            //show time
                            Text(
                              MyDateUtil.getFormattedTime(
                                  context: context, time: widget.message.sent),
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),

        //message time
        // Padding(
        //   padding: EdgeInsets.only(right: mq.width * .04),
        //   child: Text(
        //     MyDateUtil.getFormattedTime(
        //         context: context, time: widget.message.sent),
        //     style: TextStyle(fontSize: 13, color: Colors.black54),
        //   ),

        //   //adding some space
        // )
      ],
    );
  }

  //our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //message time

        //message content
        Container(
          // padding: EdgeInsets.all(widget.message.type == Type.image
          //     ? mq.width * .01
          //     : mq.width * .025),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .002),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 237, 250, 242),
              //message border line
              border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
              //making border curved
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: widget.message.type == Type.text
              ?
              //show text
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: mq.width * .010,
                        left: mq.width * .020,
                        bottom: mq.width * .010,
                        right: mq.width * .010,
                      ),
                      child: Text(
                        widget.message.msg,
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                    SizedBox(width: mq.width * .015),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mq.width * .01,
                          right: mq.width * .01,
                          bottom: mq.width * .01),
                      child: Row(
                        children: [
                          //show time
                          Text(
                            MyDateUtil.getFormattedTime(
                                context: context, time: widget.message.sent),
                            style:
                                TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          SizedBox(width: 2),
                          //double tick blue for message read
                          if (widget.message.read.isNotEmpty)
                            Icon(Icons.done_all_rounded,
                                color: Colors.blue, size: 17),
                        ],
                      ),
                    )
                  ],
                )
              //show image
              : InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ImageScreen(
                                  message: widget.message,
                                )));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: mq.width * .5,
                          height: mq.height * .3,
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image, size: 70),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Row(
                          children: [
                            //show time
                            Text(
                              MyDateUtil.getFormattedTime(
                                  context: context, time: widget.message.sent),
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                            SizedBox(width: 4),
                            //double tick blue for message read
                            if (widget.message.read.isNotEmpty)
                              Icon(Icons.done_all_rounded,
                                  color: Colors.blue, size: 17),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  //bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ?
                  //Copy Option
                  _OptionItem(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      nmae: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  :
                  //save Option
                  _OptionItem(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      nmae: 'Save Image',
                      onTap: () async {
                        try {
                          log('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'Yaree Chat')
                              .then((success) {
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Successfully saved!');
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingnImg: $e');
                        }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black87,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              //edit Option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    nmae: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete Option
              if (isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    nmae: 'Delete Message',
                    onTap: () {
                      APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black87,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent Option
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                  ),
                  nmae:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read Option
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                  ),
                  nmae: widget.message.read.isEmpty
                      ? 'Read At: Not  seen Yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

//dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding:
                  EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.message, color: Colors.blue, size: 28),
                  Text(' Edit Message'),
                ],
              ),
              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //Actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      APIs.updateMessage(widget.message, updatedMsg);
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),
              ],
            ));
  }
}

//custom option card (for copy, edit, delete..etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String nmae;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.nmae, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '  $nmae',
              style: TextStyle(
                  fontSize: 15, color: Colors.black87, letterSpacing: .3),
            ))
          ],
        ),
      ),
    );
  }
}
