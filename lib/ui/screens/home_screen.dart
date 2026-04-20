import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/location_service.dart';
import '../../database/cache_helper.dart';
import '../widgets/bio_widget.dart';
import '../widgets/location_display_widget.dart';
import '../widgets/personal_details_widget.dart';
import '../widgets/profile_picture_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  double? _latitude;
  double? _longitude;
  String _address = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _jobController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> loadSavedData() async {
    final data = await CacheHelper.loadUserData();
    if (data.isNotEmpty && data['name'] != '') {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _jobController.text = data['jobTitle'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _latitude = data['latitude'];
        _longitude = data['longitude'];
        _address = data['address'] ?? '';
        if (data['imagePath'] != null && data['imagePath'].isNotEmpty) {
          _selectedImage = File(data['imagePath']);
        }
      });
    } else {
      print('No saved data found');
    }
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        final address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _address = address;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> saveUserData() async {
    final Sucessful = await CacheHelper.SaveUserData(
      name: _nameController.text,
      email: _emailController.text,
      jobTitle: _jobController.text,
      bio: _bioController.text,
      latitude: _latitude,
      longitude: _longitude,
      address: _address,
      imagePath: _selectedImage?.path,
    );
    print('User data saved successfully: $Sucessful');
  }

  Future<void> loadData() async {
    final data = await CacheHelper.loadUserData();
    setState(() {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _jobController.text = data['jobTitle'] ?? '';
      _bioController.text = data['bio'] ?? '';
      _latitude = data['latitude'];
      _longitude = data['longitude'];
      _address = data['address'] ?? '';
    });
  }

  Future<void> removeData() async {
    final successful = await CacheHelper.clearUserData();
    if (successful) {
      setState(() {
        _nameController.clear();
        _emailController.clear();
        _jobController.clear();
        _bioController.clear();
        _latitude = null;
        _longitude = null;
        _address = '';
        _selectedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              ProfilePictureWidget(
                selectedImage: _selectedImage,
                onImageSelected: (image) {
                  setState(() => _selectedImage = image);
                },
              ),
              const SizedBox(height: 30),
              PersonalDetailsWidget(
                nameController: _nameController,
                emailController: _emailController,
                jobController: _jobController,
              ),
              const SizedBox(height: 24),
              BioWidget(bioController: _bioController),
              const SizedBox(height: 24),

              Divider(),
              const SizedBox(height: 24),
              LocationDisplayWidget(
                address: _address,
                latitude: _latitude,
                longitude: _longitude,
                onGetLocation: _getUserLocation,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: saveUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Load',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: removeData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
