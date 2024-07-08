import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_retail/models/user_model.dart';
import 'package:flash_retail/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _gender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserFromStorage();
    if (userProvider.user != null) {
      setState(() {
        _nameController.text = userProvider.user!.name!;
        _emailController.text = userProvider.user!.email!;
        if (['Male', 'Female'].contains(userProvider.user!.gender)) {
          _gender = userProvider.user!.gender;
        } else {
          _gender = null;
        }
        // Load image if available
        // _image = File(userProvider.user!.imagePath); // Adjust according to your image storage logic
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Updating...');

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final updatedUser = User(
        id: userProvider.user!.id,
        name: _nameController.text,
        email: _emailController.text,
        gender: _gender!,
        password: userProvider.user!.password, // Keep existing password
        image: userProvider.user!.image, // Keep existing image path
      );

      bool success = await userProvider.updateUser(updatedUser, image: _image);

      EasyLoading.dismiss();

      _showPopupMessage(success);
    }
  }

  void _showPopupMessage(bool success) {
    AwesomeDialog(
      context: context,
      dialogType: success ? DialogType.success : DialogType.error,
      animType: AnimType.rightSlide,
      title: success ? 'Success' : 'Error',
      desc:
          success ? 'Profile Updated Successfully' : 'Failed to Update Profile',
      btnOkOnPress: () {
        if (success) {
          Navigator.of(context).pop(); // Close the UpdateProfile screen
        }
      },
    ).show();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.grey[200],
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  void _showProfilePhoto(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.user == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                              var kEndpoint =
                                  "https://retailflash.up.railway.app/";
                              String imageUrl = Uri.tryParse(kEndpoint +
                                              (userProvider.user?.image ?? ''))
                                          ?.isAbsolute ==
                                      true
                                  ? kEndpoint + userProvider.user!.image!
                                  : 'https://via.placeholder.com/150';
                              return GestureDetector(
                                onTap: () =>
                                    _showProfilePhoto(context, imageUrl),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      CachedNetworkImageProvider(imageUrl),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: -10,
                            left: 60,
                            child: IconButton(
                              onPressed: _pickImage,
                              icon: const Icon(
                                IconlyBold.camera,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Gender'),
                      value: _gender,
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                            value: 'Female', child: Text('Female')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: _updateProfile,
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
