import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'HomeScreen.dart';
import 'bottom_navigation_bar_worker.dart';
double sizewidth=0;
class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    sizewidth = context
        .read<DetailScreenProvider>()
        .cart_width_icon(MediaQuery.of(context).size.width);
    sizewidth = sizewidth / 2;
    DetailScreenProvider detailScreenProvider =
    Provider.of<DetailScreenProvider>(context);
    print(MediaQuery.of(context).size.width);

    final Stream<QuerySnapshot> _usersStream =
    FirebaseFirestore.instance.collection('User').snapshots();

    return WillPopScope(
      onWillPop: () async {

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text("History"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<WorkerSideProvider>().onItemTapped(0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkerHomePage()),
              );
            },
          ),
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> da =
                document.data()! as Map<String, dynamic>;
                return StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection('User').doc("${document.id}").collection("Request").where("Status",isEqualTo:"complete" ).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      shrinkWrap: true,
                      children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {

                        Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                        // var a= getValue(data["Uid"]);
                        // print("checkiiiinggg aaaaa isssss $imgUrl");
                        return Card(
                          child:Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                leading: ClipOval(

                                  child: data["User_Img"]=="default"?Icon(
                                      Icons.person_pin
                                  ):Image.network("${data['User_Img']}",
                                    height: 100,
                                    width: 50,
                                    fit: BoxFit.cover,

                                  ),

                                ),
                                title: Text(data['Name']),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text("${data['Distance']} Km "
                                      "\nRs ${data["Price"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                isThreeLine: true,
                                trailing: SizedBox(
                                  height: MediaQuery.of(context).size.height/20.76,
                                  width: MediaQuery.of(context).size.width/3.22,


                                  child: ElevatedButton(


                                      onPressed: ()async {

                                      },
                                      child: Text('Completed'),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18.0),
                                                  side: BorderSide(color: Colors.white)
                                              )
                                          )
                                      )

                                  ),
                                ),




                              ),

                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),


                        );
                      }).toList(),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBarWorker(),
      ),
    );
  }
}
