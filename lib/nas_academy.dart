import 'package:flutter/material.dart';


class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  List<String> Customer=[];
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF323844),
        title: Text("Customer List"),
        centerTitle: true,


      ),
     body: ListView.builder(
         itemCount: Customer.length,
         shrinkWrap: true,
         itemBuilder: (BuildContext context,int index){
           return Card(
             child: ListTile(


                 title:Text("${Customer[index]}")
             ),
           );
         }
     ),

     bottomNavigationBar: Row(
       children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
             height: 50,
             width: 250,
               child:TextField (
                 controller: name,
                 decoration: InputDecoration(
                   focusColor: Colors.purple,


                     border: OutlineInputBorder(
                     ),
                     //labelText: 'Add Customer',
                     hintText: 'Add Customer'
                 ),
               ),

           ),
         ),
         SizedBox(
           width: 10,
         ),
         SizedBox(
           height: 50,
           width: 100,
           child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    primary: Colors.green,

    ),

               onPressed: (){
             setState(() {
               Customer.add(name.text.trim());
               name.clear();
             });


           }, child: Text("Add")),
         )
       ],
     ),
    );
  }
}
