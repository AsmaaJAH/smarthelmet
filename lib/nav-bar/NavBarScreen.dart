import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/SignIn/SignIn.dart';
import 'package:smarthelmet/nav-bar/Gas.dart';
import 'package:smarthelmet/nav-bar/Tempreture.dart';
import 'package:smarthelmet/nav-bar/UltrasonicSensor.dart';
import 'package:smarthelmet/shared/constants/Constants.dart';

import 'Alerts.dart';
import 'FallDeteting.dart';
import 'Logout.dart';
import 'Tracking.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 87.0,
            child: DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: navBarColor,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: navBarColor,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.grey[800],
                fontFamily: 'Ubuntu',
              ),
            ),
            onTap: () {
              // Update the state of the app
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Home()),
              // );
            },
          ),

          ExpansionTile(
            leading: Icon(Icons.speed_outlined),
            iconColor: Colors.grey[800],
            collapsedIconColor: navBarColor,
            title: Text(
              "Monitoring",
              style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.grey[800],
                fontFamily: 'Ubuntu',
              ),
            ),
            //leading: Icon(Icons.person), //add icon
            childrenPadding: EdgeInsets.only(left: 50), //children padding
            children: [
              ListTile(
                title: Text(
                  "Gas",
                  style: TextStyle(
                    fontSize: 14.0,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.grey[700],
                    fontFamily: 'Ubuntu',
                  ),
                ),
                onTap: () {
                  //action on press
                  // Update the state of the app
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GasScreen()),
                  );
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Temperature",
                  style: TextStyle(
                    fontSize: 14.0,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.grey[700],
                    fontFamily: 'Ubuntu',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TempretureScreen()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Fall Detection",
                  style: TextStyle(
                    fontSize: 14.0,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.grey[700],
                    fontFamily: 'Ubuntu',
                  ),
                ),
                onTap: () {
                  //action on press
                  // Update the state of the app
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FallDetection()),
                  );
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Utra sonic",
                  style: TextStyle(
                    fontSize: 14.0,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.grey[700],
                    fontFamily: 'Ubuntu',
                  ),
                ),
                onTap: () {
                  //action on press
                  // Update the state of the app
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UltraScreen()),
                  );
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
              //more child menu
            ],
          ),

          // ListTile(
          //   leading: Icon(Icons.chevron_right),
          //   title: Text(
          //       'Monitoring',
          //       style: TextStyle(
          //       fontSize: 14.0,
          //       //fontWeight: FontWeight.bold,
          //       letterSpacing: 2.0,
          //       color: Colors.grey[800],
          //       fontFamily: 'Ubuntu',
          //     ),
          //   ),
          //   onTap: () {
          //     // Update the state of the app
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const Monitoring()),
          //     );
          //     // Then close the drawer
          //     //Navigator.pop(context);
          //   },
          // ),

          ListTile(
            leading: Icon(Icons.near_me_outlined, color: navBarColor),
            title: Text(
              'Tracking',
              style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.grey[800],
                fontFamily: 'Ubuntu',
              ),
            ),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Tracking()),
              );
              // Then close the drawer
              //Navigator.pop(context);
            },
          ),

          ListTile(
            leading: Icon(
              Icons.report_problem_outlined,
              color: navBarColor,
            ),
            title: Text(
              'Alerts',
              style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.grey[800],
                fontFamily: 'Ubuntu',
              ),
            ),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Alerts()),
              );
              // Then close the drawer
              //Navigator.pop(context);
            },
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: const Center(
                  child: Text(
                    '8', // EDIT THIS TO BE VARIABLE LATER
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(),

          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 2.0,
                color: Colors.grey[800],
                fontFamily: 'Ubuntu',
              ),
            ),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
