import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:yaree_chat_app/api/apis.dart';
import 'package:yaree_chat_app/helper/dialogs.dart';
import 'package:yaree_chat_app/models/chat_user.dart';
import 'package:yaree_chat_app/screens/Profile_screen.dart';
import 'package:yaree_chat_app/widgets/chat_user_card.dart';
import '../main.dart';

//home screen -- where all available contacts are show
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all user
  List<ChatUser> _list = [];

  //for storing searched items
  final List<ChatUser> _searchList = [];

  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to life events
    //resume  --  active or online
    //pause  --  inactive or offlie
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            //app bar
            appBar: AppBar(
              leading: Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'name, Email, ....'),
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 0.5,
                          color: Colors.white),
                      onChanged: (val) {
                        //search logic
                        _searchList.clear();

                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    )
                  : Text("Yaree Chat App"),
              actions: [
                //Search button
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),

                //more features button
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: APIs.me,
                                  )));
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),

            //floating button to add new user
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                  onPressed: () {
                    _addChatUserDialog();
                  },
                  child: Icon(
                    Icons.add_comment_rounded,
                  )),
            ),

            //body
            body: StreamBuilder(
                stream: APIs.getMyUsersId(),

                //get id of only known users, who's ids are provided
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());

                    //if some or data is loaded then show it.
                    case ConnectionState.active:
                    case ConnectionState.done:

                      //
                      return StreamBuilder(
                        stream: APIs.getAllUsers(
                            snapshot.data?.docs.map((e) => e.id).toList() ??
                                []),

                        //get only those user, who's ids are provided
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            // if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            // return Center(child: CircularProgressIndicator());

                            //if some or data is loaded then show it.
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              // for (var i in data!) {
                              //   // log('Data: ${i.data()}');
                              //   log('Data: ${jsonEncode(i.data())}');
                              //   list.add(i.data()['name']);
                              // }
                              _list = data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  padding:
                                      EdgeInsets.only(top: mq.width * .015),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(
                                        user: _isSearching
                                            ? _searchList[index]
                                            : _list[index]);
                                    // return Text('Name: ${list[index]}');
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    'No Connections Found!',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                );
                              }
                          }
                        },
                      );
                  }
                })),
      ),
    );
  }

  //adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding:
                  EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.person_add, color: Colors.blue, size: 28),
                  Text('  Add User'),
                ],
              ),
              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
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

                //add button
                MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not exists');
                          }
                        });
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),
              ],
            ));
  }
}
