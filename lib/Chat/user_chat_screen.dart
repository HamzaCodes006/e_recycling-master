import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

final _firestore = FirebaseFirestore.instance;

late String email;
late String messageText;
late User loggedInUser;

class UserChatScreen extends StatefulWidget {
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final chatMsgTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getMessages();
  }

  void getCurrentUser() async {
    // try {
    //   final user = await _auth.currentUser!;
    //   if (user != null) {
    //     loggedInUser = user;
    //     setState(() {
    //       //username = loggedInUser.displayName!;
    //       email = loggedInUser.email!;
    //     });
    //   }
    // } catch (e) {
    //   print('current user getting error');
    // }
  }
  // void getMessages()async{
  //   final messages=await _firestore.collection('messages').getDocuments();
  //   for(var message in messages.documents){
  //     print(message.data);
  //   }
  // }

  // void messageStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     snapshot.documents;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.lightGreen),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(25, 2),
          child: Container(
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.lightGreen[100],
            ),
            decoration: BoxDecoration(
                // color: Colors.blue,

                // borderRadius: BorderRadius.circular(20)
                ),
            constraints: BoxConstraints.expand(height: 1),
          ),
        ),
        backgroundColor: Colors.white10,
        // leading: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png'),),
        // ),
        title: Center(
          child: Text(
            'Inbox',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 20, color: Colors.lightGreen),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_sharp),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserChatStream(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: chatMsgTextController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.lightGreen,
                    onPressed: () {
                      chatMsgTextController.clear();
                      _firestore
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('messages')
                          .add({
                        'assignReceiverEmail': context
                            .read<BottomNavigationProvider>()
                            .workerEmail,
                        'text': messageText,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'senderEmail': FirebaseAuth.instance.currentUser!.email,
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                    // Text(
                    //   'Send',
                    //   style: kSendButtonTextStyle,
                    // ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserChatStream extends StatelessWidget {
  final assignWorkerEmail;
  UserChatStream({this.assignWorkerEmail});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .orderBy('timestamp')
          // .where('senderEmail',
          //     isEqualTo: '${FirebaseAuth.instance.currentUser!.email}')
          // .where('senderEmail',
          //     isEqualTo:
          //         '${context.read<BottomNavigationProvider>().workerUid}')
          .snapshots(),
      builder: (context, snapshot) {
        print(FirebaseAuth.instance.currentUser!.email);
        print(assignWorkerEmail);
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          final receiverEmail =
              context.read<BottomNavigationProvider>().workerEmail;
          List<UserMessageBubble> messageWidgets = [];
          for (var message in messages) {
            final msgText = message.get('text');
            print(msgText);
            final msgSender = message.get('senderEmail');
            final assignReceiverEmail = message.get('assignReceiverEmail');
            final currentUser = FirebaseAuth.instance.currentUser!.email;
            final msgBubble = UserMessageBubble(
              msgText: msgText,
              msgSender: msgSender,
              user: currentUser == msgSender,
            );
            if ((msgSender == FirebaseAuth.instance.currentUser!.email &&
                    assignReceiverEmail == receiverEmail) ||
                (msgSender == receiverEmail &&
                    assignReceiverEmail ==
                        FirebaseAuth.instance.currentUser!.email)) {
              // if (assignReceiverEmail == receiverEmail ||
              //     assignReceiverEmail ==
              //         FirebaseAuth.instance.currentUser!.email) {
              messageWidgets.add(msgBubble);
              // }
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else {
          return Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.lightGreen),
          );
        }
      },
    );
  }
}

class UserMessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;
  UserMessageBubble(
      {required this.msgText, required this.msgSender, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              // msgSender,
              '',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.lightGreen : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.lightGreen,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
