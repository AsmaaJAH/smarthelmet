// // import 'package:flutter/material.dart';
// // import 'package:web_socket_channel/io.dart';
// // import 'package:firebase_database/firebase_database.dart';

// // class TestRecievingText extends StatefulWidget {
// //   @override
// //   State<TestRecievingText> createState() => _TestRecievingTextState();
// // }

// // class _TestRecievingTextState extends State<TestRecievingText> {
// //   late DatabaseReference ref;
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     ref = FirebaseDatabase.instance.reference();
// //   }

// //   Future<void> sendData() async {
// //     DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");

// //     await ref.set({
// //       "name": "John",
// //       "age": 18,
// //       "address": {"line1": "100 Mountain View"}
// //     });
// //     print("after send");
// //   }
// //   // FirebaseDatabase database = FirebaseDatabase.instance;

// // // await ref.set({
// // //   "name": "John",
// // //   "age": 18,
// // //   "address": {
// // //     "line1": "100 Mountain View"
// // //   }
// // // });
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           print("object");
// //           sendData();
// //         },
// //       ),
// //       appBar: AppBar(
// //         title: const Text(
// //           'Test: Receiving any text',
// //           style: TextStyle(
// //             fontSize: 22.0,
// //             fontWeight: FontWeight.bold,
// //             letterSpacing: 2.0,
// //             color: Colors.white,
// //             fontFamily: 'Ubuntu',
// //           ),
// //         ),
// //         backgroundColor: Colors.cyan,
// //         elevation: 0.0,
// //         leading: IconButton(
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //           icon: const Icon(Icons.arrow_back_ios_new),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class WebSocketLed extends StatefulWidget {
// //   @override
// //   State<StatefulWidget> createState() {
// //     return _WebSocketLed();
// //   }
// // }

// // class _WebSocketLed extends State<WebSocketLed> {
// //   bool ledstatus = false; //boolean value to track LED status, if its ON or OFF
// //   late IOWebSocketChannel channel;
// //   bool connected = false; //boolean value to track if WebSocket is connected

// //   @override
// //   void initState() {
// //     ledstatus = false; //initially leadstatus is off so its FALSE
// //     connected = false; //initially connection status is "NO" so its FALSE

// //     channelconnect();
// //     Future.delayed(Duration.zero, () async {
// //       channelconnect(); //connect to WebSocket wth NodeMCU
// //     });

// //     super.initState();
// //   }

// //   channelconnect() {
// //     //function to connect
// //     try {
// //       channel = IOWebSocketChannel.connect(
// //           "wss://echo.websocket.events"); //channel IP : Port
// //       channel.stream.listen(
// //         (message) {
// //           message = "connected";
// //           print("................" + message + "................");
// //           setState(() {
// //             if (message == "connected") {
// //               connected = true; //message is "connected" from NodeMCU
// //             } else if (message == "poweron:success") {
// //               ledstatus = true;
// //             } else if (message == "poweroff:success") {
// //               ledstatus = false;
// //             }
// //           });
// //         },
// //         onDone: () {
// //           //if WebSocket is disconnected
// //           print("Web socket is closed");
// //           setState(() {
// //             connected = false;
// //           });
// //         },
// //         onError: (error) {
// //           print(error.toString());
// //         },
// //       );
// //     } catch (_) {
// //       print("error on connecting to websocket.");
// //     }
// //   }

// //   Future<void> sendcmd(String cmd) async {
// //     if (connected == true) {
// //       if (ledstatus == false && cmd != "poweron" && cmd != "poweroff") {
// //         print("Send the valid command");
// //       } else {
// //         channel.sink.add(cmd); //sending Command to NodeMCU
// //       }
// //     } else {
// //       channelconnect();
// //       print("Websocket is not connected.");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //           title: Text("LED - ON/OFF NodeMCU"),
// //           backgroundColor: Colors.redAccent),
// //       body: Container(
// //           alignment: Alignment.topCenter, //inner widget alignment to center
// //           padding: EdgeInsets.all(20),
// //           child: Column(
// //             children: [
// //               Container(
// //                   child: connected
// //                       ? Text("WEBSOCKET: CONNECTED")
// //                       : Text("DISCONNECTED")),
// //               Container(
// //                   child: ledstatus ? Text("LED IS: ON") : Text("LED IS: OFF")),
// //               Container(
// //                   margin: EdgeInsets.only(top: 30),
// //                   child: FlatButton(
// //                       //button to start scanning
// //                       color: Colors.redAccent,
// //                       colorBrightness: Brightness.dark,
// //                       onPressed: () {
// //                         //on button press
// //                         if (ledstatus) {
// //                           //if ledstatus is true, then turn off the led
// //                           //if led is on, turn off
// //                           sendcmd("poweroff");
// //                           ledstatus = false;
// //                         } else {
// //                           //if ledstatus is false, then turn on the led
// //                           //if led is off, turn on
// //                           sendcmd("poweron");
// //                           ledstatus = true;
// //                         }
// //                         setState(() {});
// //                       },
// //                       child: ledstatus
// //                           ? Text("TURN LED OFF")
// //                           : Text("TURN LED ON")))
// //             ],
// //           )),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class Try extends StatefulWidget {
//   const Try({Key? key}) : super(key: key);

//   @override
//   State<Try> createState() => _TryState();
// }

// class _TryState extends State<Try> {
//   Future<void> sendData() async {
//     DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");

//     await ref.set({
//       "name": "John",
//       "age": 18,
//       "address": {"line1": "100 Mountain View"}
//     });
//     print("after send");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           sendData();
//         },
//       ),
//     );
//   }
// }
// class AddUser extends StatelessWidget {
//   final String fullName;
//   final String company;
//   final int age;

//   AddUser(this.fullName, this.company, this.age);

//   @override
//   Widget build(BuildContext context) {
//     // Create a CollectionReference called users that references the firestore collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     Future<void> addUser() {
//       // Call the user's CollectionReference to add a new user
//       return users
//           .add({
//             'full_name': fullName, // John Doe
//             'company': company, // Stokes and Sons
//             'age': age // 42
//           })
//           .then((value) => print("User Added"))
//           .catchError((error) => print("Failed to add user: $error"));
//     }

//     return FlatButton(
//       onPressed: addUser,
//       child: Text(
//         "Add User",
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Try extends StatelessWidget {
  Try({super.key});
  final dataBase = FirebaseDatabase.instance.reference();
// class Try extends StatefulWidget {
//   const Try({Key? key}) : super(key: key);

//   @override
//   State<Try> createState() => _TryState();
// }

// class _TryState extends State<Try> {

  // Future<void> sendData() async {
  // // Query db = FirebaseDatabase.instance.ref().child('test');
  // // DataSnapshot dataSnapshot = await db.get();
  // //   dataSnapshot.children.forEach((element) {
  // //     print("---------------------------1");
  // //     print(element.value);
  // //     print("---------------------------1");
  // //   });
  //   print("***********************************");
  //   FirebaseFirestore.instance.collection('notes').snapshots().listen((event) {
  //     event.docs.forEach((element) {
  //       var data = element.data();
  //       print(data['name']);
  //       print(data['email']);

  //       print("----------------------------------");
  //     });
  //   });
  //   // DatabaseReference ref = FirebaseDatabase.instance;
  //   // print("---------------------------1");
  //   // CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //   // print("---------------------------2");
  //   // await users.get().then((value) {
  //   //   print("---------------------------3");
  //   //   value.docs.forEach((element) {
  //   //     var data = element.data() as Map<String, dynamic>;
  //   //     print("----------------------------------");
  //   //     print(data['email']);
  //   //     print(data['userName']);
  //   //     print("----------------------------------");
  //   //   });
  //   // });
  //   //
  //   // await ref.set({
  //   //   "name": "John",
  //   //   "age": 18,
  //   //   "address": {"line1": "100 Mountain View"}
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    final test = dataBase.child("yousef/");

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        test
            .set({"key_pass": '50'})
            .then((value) => print('done'))
            .catchError((onError) => print("error ${onError.toString()}"));
      }),
    );
  }
}
