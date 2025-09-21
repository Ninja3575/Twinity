import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twinity/services/db_service.dart';
import 'package:twinity/services/storage_service.dart';
import 'main_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  final User user;
  const CreateProfileScreen({super.key, required this.user});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final StorageService _storageService = StorageService();
  final DbService _dbService = DbService();

  XFile? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.displayName ?? "";
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String? photoURL = widget.user.photoURL;

        if (_imageFile != null) {
          // Upload the new image if one was selected
          photoURL = await _storageService.uploadProfilePicture(widget.user.uid, File(_imageFile!.path));
        }

        // Create the user document in Firestore
        await _dbService.updateUserProfile(widget.user.uid, {
          'name': _nameController.text,
          'email': widget.user.email,
          'photoURL': photoURL,
        });

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save profile: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Profile')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : (widget.user.photoURL != null
                        ? NetworkImage(widget.user.photoURL!)
                        : null) as ImageProvider?,
                    child: _imageFile == null && widget.user.photoURL == null
                        ? const Icon(Icons.add_a_photo, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Tap the circle to change your photo", textAlign: TextAlign.center),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Your Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save and Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}