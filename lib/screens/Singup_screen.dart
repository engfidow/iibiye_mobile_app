import 'dart:io';

import 'package:flash_retail/dashboard.dart';
import 'package:flash_retail/models/user_model.dart';
import 'package:flash_retail/providers/user_provider.dart';
import 'package:flash_retail/screens/Sigin_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = false;
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  bool _isLoading = false;
  File? _image;
  String? _gender;

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }

  void _resetForm() {
    _formSignupKey.currentState!.reset();
    passwordController.clear();
    confirmPasswordController.clear();
    emailController.clear();
    fullNameController.clear();
    _image = null;
    agreePersonalData = false;
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

  void _registerUser(String fullName, String email, String password,
      String gender, File? image) async {
    if (_formSignupKey.currentState!.validate() && agreePersonalData) {
      try {
        setState(() {
          _isLoading = true;
        });
        User newUser = User(
          id: '',
          name: fullName,
          email: email,
          password: password,
          image: image?.path,
          gender: gender,
        );

        User? registeredUser =
            await Provider.of<UserProvider>(context, listen: false)
                .createUser(newUser, image: image);

        if (registeredUser != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register. ${e.toString()}')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please agree to the processing of personal data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60),
              Form(
                key: _formSignupKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFDC143C),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider<Object>?
                              : NetworkImage(
                                  "https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352156-stock-illustration-default-placeholder-profile-icon.jpg"),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: _pickImage,
                            icon: Icon(IconlyLight.camera),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Full name';
                        } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                          return 'Full name must contain letters and spaces only';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Full Name'),
                        hintText: 'Enter Full Name',
                        hintStyle: const TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        hintText: 'Enter Email',
                        hintStyle: const TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        label: const Text('Gender'),
                        // hintText: 'Enter Full Name',
                        hintStyle: const TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                      ),
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
                    const SizedBox(height: 25.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isHiddenPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        hintText: 'Enter Password',
                        hintStyle: const TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isHiddenPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordView,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _isHiddenConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Confirm Password'),
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isHiddenConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: _toggleConfirmPasswordView,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Row(
                      children: [
                        Checkbox(
                          value: agreePersonalData,
                          onChanged: (bool? value) {
                            setState(() {
                              agreePersonalData = value!;
                            });
                          },
                          activeColor: Color(0xFFDC143C),
                        ),
                        const Text(
                          'I agree to the processing of ',
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text(
                          'Personal data',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC143C)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formSignupKey.currentState!.validate() &&
                              agreePersonalData) {
                            _registerUser(
                                fullNameController.text,
                                emailController.text,
                                passwordController.text,
                                _gender!,
                                _image ?? File('default/path/to/image.jpg'));

                            _resetForm();
                          } else if (!agreePersonalData) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please agree to the processing of personal data')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                          backgroundColor: Color(0xFFDC143C),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.black45),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (e) => const SigIn(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC143C)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
