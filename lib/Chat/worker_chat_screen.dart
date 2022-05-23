import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

final _firestore = FirebaseFirestore.instance;
// late String email;
late String messageText;

class WorkerChatScreen extends StatefulWidget {
  @override
  _WorkerChatScreenState createState() => _WorkerChatScreenState();
}

class _WorkerChatScreenState extends State<WorkerChatScreen> {
  var chatMsgTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    uIdGet().whenComplete(() => setState(() {}));
    // setState(() {
    getCurrentUser();
    // });

    super.initState();

    // getMessages();
  }

  getCurrentUser() async {
    // try {
    //   // QuerySnapshot querySnapshot = await _firestore
    //   //     .collection('User')
    //   //     .where('Email', isEqualTo: '${widget.assignUserEmail}')
    //   //     .get();
    //   // assignUserId = querySnapshot.docs.first.id;
    //   // print("aaa//////////////////////${querySnapshot.docs.first.id}");
    //   // final user = await _auth.currentUser!;
    //   // if (user != null) {
    //   //   loggedInUser = user;
    //   //   setState(() {
    //   //     email = loggedInUser.email!;
    //   //     print('///////////////////////////$email');
    //   //   });
    //   }

    //   print("aaa//////////////////////");
    // } catch (e) {
    //   print('current user getting error');
    // }
  }

  @override
  Widget build(BuildContext context) {
    uIdGet();
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
          WorkerChatStream(),
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
                          print(value);
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
                    color: Colors.blue,
                    onPressed: () {
                      chatMsgTextController.clear();
                      _firestore
                          .collection('User')
                          .doc(context.read<BottomNavigationProvider>().userUid)
                          .collection('messages')
                          .add({
                        'assignReceiverEmail':
                            context.read<BottomNavigationProvider>().userEmail,
                        'text': messageText,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'senderEmail': FirebaseAuth.instance.currentUser!.email,
                      }).whenComplete(() => print(
                              'added in firebase from worker chat screen.'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  uIdGet() async {
    print('///////////////start');
    // setState(() async {
    // await _firestore
    //     .collection('User')
    //     .get()
    //     .then((value) => value.docs.forEach((element) {
    //           // var a = element.get('Email');
    //           if (widget.assignUserEmail == element.get('Email')) {
    //             widget.assignUserId = element.id;
    //             print('vo vali email ha///${widget.assignUserId}');
    //           }
    //           // print(a);
    //         }));
    // //
    // // });
    // print('///////////////end');
  }
}

class WorkerChatStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('User')
          .doc(context.read<BottomNavigationProvider>().userUid)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.lightGreen),
          );
        }
        print('messages bubbles');
        snapshot.data!.docs.map((e) {
          print(e.get('text'));
        });
        final messages = snapshot.data!.docs.reversed;
        List<WorkerMessageBubble> messageWidgets = [];
        final receiverEmail =
            context.read<BottomNavigationProvider>().userEmail;
        for (var message in messages) {
          final msgText = message.get('text');
          final msgSender = message.get('senderEmail');
          print('text message: $msgText');
          final assignReceiverEmail = message.get('assignReceiverEmail');
          final currentUser = FirebaseAuth.instance.currentUser!.email;
          final msgBubble = WorkerMessageBubble(
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
          // messageWidgets.add(msgBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            children: messageWidgets,
          ),
        );
      },
    );
    // : Center(
    //     child: CircularProgressIndicator(
    //       color: Colors.lightGreen,
    //     ),
    //   );
  }
}

class WorkerMessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;
  WorkerMessageBubble(
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
