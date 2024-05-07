import 'package:flutter/material.dart';
import 'package:my_chat_app/pages/login_page.dart';
import 'package:my_chat_app/utils/constants.dart';
import 'package:my_chat_app/models/profile.dart';
import 'dart:async';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const UserProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    // Get current user information
    final user = supabase.auth.currentUser;
    final userEmail = user?.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Logout button
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
              // Navigate back to the login page after logout
              Navigator.of(context).pushAndRemoveUntil(LoginPage.route(), (route) => false);
              // Show logout success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                  backgroundColor: Color.fromARGB(255, 127, 57, 112),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<Profile?>(
        future: getUserProfile(user?.id ?? ''), // Fetch user profile data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message if data fetching fails
          } else {
            final profile = snapshot.data;
            if (profile != null) {
              // Display user profile information
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display the email
                    const Text(
                      'Email:',
                      style: TextStyle(color: Color.fromARGB(255, 239, 129, 215), fontSize: 18),
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Display the username
                    const Text(
                      'Username:',
                      style: TextStyle(color: Color.fromARGB(255, 239, 129, 215), fontSize: 18),
                    ),
                    Text(
                      profile.username,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Display user creation date
                    const Text(
                      'Created At:',
                      style: TextStyle(color: Color.fromARGB(255, 239, 129, 215), fontSize: 18),
                    ),
                    Text(
                      _formatDateTime(profile.createdAt),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            } else {
              return const Text(
                'User Profile not found',
                style: TextStyle(color: Color.fromARGB(255, 127, 57, 112)));
            }
          }
        },
      ),
    );
  }

  // Format date time into a readable string
  String _formatDateTime(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
}

  // Fetch user profile data from Supabase
  Future<Profile?> getUserProfile(String userId) async {
    final data = await supabase.from('profiles').select().eq('id', userId).single().execute();
    if (data.data == null) {
      return null; // Return null if there's an error
    } else {
      return Profile.fromMap(data.data as Map<String, dynamic>);
    }
  }
}