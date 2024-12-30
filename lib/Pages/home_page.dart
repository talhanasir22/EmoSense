import 'package:emo_sense/Pages/Face_detect_page.dart';
import 'package:emo_sense/Pages/note_page.dart';
import 'package:emo_sense/Pages/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  // List of pages for navigation
  final List<Widget> _pages = [
    FaceDetectPage(),
    NotePage(), // Notes Page
  ];

  // Function to show Bottom Sheet (Settings)
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.password, color: Colors.white),
                title: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showChangePasswordDialog(context);
                },
              ),
              const Divider(color: Colors.white38),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  // Show the confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Sign Out"),
                      content: const Text("Are you sure you want to sign out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Sign out from Firebase
                            await FirebaseAuth.instance.signOut();

                            // Clear the login status in SharedPreferences
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.remove('isLoggedIn'); // Remove the 'isLoggedIn' flag

                            // Close the dialog
                            Navigator.of(context).pop();

                            // Navigate to the SignInPage and remove all previous routes
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInPage()),
                                  (route) => false,
                            );
                          },
                          child: const Text("Sign Out"),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }


  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter new password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.currentUser!
                      .updatePassword(_passwordController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully!'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                    ),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      // appBar: AppBar(
      //   backgroundColor: Colors.black87,
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(
      //         Icons.logout,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         showDialog(
      //           context: context,
      //           builder: (context) => AlertDialog(
      //             title: const Text("Sign Out"),
      //             content: const Text("Are you sure you want to sign out?"),
      //             actions: [
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: const Text("Cancel"),
      //               ),
      //               TextButton(
      //                 onPressed: () {
      //                   FirebaseAuth.instance.signOut();
      //                   Navigator.of(context).pop();
      //                   Navigator.pushAndRemoveUntil(
      //                     context,
      //                     MaterialPageRoute(builder: (context) => const SignInPage()),
      //                         (route) => false,
      //                   );
      //                 },
      //                 child: const Text("Sign Out"),
      //               ),
      //             ],
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: _currentIndex < _pages.length
          ? _pages[_currentIndex]
          : Container(), // Only show pages other than settings
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple.shade400,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: _currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        onTap: (index) {
          if (index == 2) {
            // If Settings is clicked, show Bottom Sheet
            _showSettingsBottomSheet(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
