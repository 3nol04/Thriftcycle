import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thriftcycle/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUsername = 'user1234';
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUsername = prefs.getString('username') ?? 'user1234';
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        profileImage = File(imagePath);
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', currentUsername);
    if (profileImage != null) {
      await prefs.setString('profileImage', profileImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding:
        const EdgeInsets.symmetric(vertical:100 , horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 130),
                CircleAvatar(
                  radius: 65,
                  backgroundImage: profileImage == null
                      ? const AssetImage('image/Profile_Default.png')
                      : FileImage(profileImage!) as ImageProvider,
                ),
                const SizedBox(height: 20),
                Text(
                  currentUsername,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          initialUsername: currentUsername,
                          initialProfileImage: profileImage,
                        ),
                      ),
                    );
            
                    if (result != null) {
                      setState(() {
                        currentUsername = result['username'] ?? currentUsername;
                        profileImage = result['profileImage'] ?? profileImage;
                      });
                      await _saveProfileData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF2C7C7D),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          
        ),
      ),
    );
  }
}
