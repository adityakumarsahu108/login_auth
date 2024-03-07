import 'package:flutter/material.dart';
import 'package:login_auth/pages/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.deepPurple[500],
      child: ListView(
        shrinkWrap: true,
        children: [
          //logo
          const DrawerHeader(
            child: Center(
              child: Icon(
                Icons.android,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),

          //home title
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
              title: const Text(
                "H O M E",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              onTap: () {
                //pop the drawer
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: const Text(
                "S E T T I N G S",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onTap: () {
                //pop the drawer
                Navigator.pop(context);

                //navigate to the settings page

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
