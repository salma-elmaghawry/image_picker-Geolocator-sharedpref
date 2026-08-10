import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/cache_helper.dart';

import '../../services/location_service.dart';
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
  bool _isLoadingLocation = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final LocationService _locationService = LocationService();

  ///=========================cache helper========================

  Future<void> _loadUserData() async {
    final userData = await CacheHelper.loadUserData();
    setState(() {
      _nameController.text = userData['name'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _jobController.text = userData['jobTitle'] ?? '';
      _bioController.text = userData['bio'] ?? '';
      _latitude = userData['latitude'];
      _longitude = userData['longitude'];
      _address = userData['address'] ?? '';
      final profileImagePath = userData['profileImagePath'];
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        _selectedImage = File(profileImagePath);
      }
    });
  }

  Future<void> _saveUserData() async {
    final success = await CacheHelper.saveUserData(
      name: _nameController.text,
      email: _emailController.text,
      jobTitle: _jobController.text,
      bio: _bioController.text,
      latitude: _latitude,
      longitude: _longitude,
      address: _address,
      profileImagePath: _selectedImage?.path,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data saved successfully!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save data.')));
    }
  }

  Future<void> _clearUserData() async {
    final success = await CacheHelper.removeAllData();
    if (success) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data cleared successfully!')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to clear data.')));
    }
  }
//=========================get location========================
  Future<void> _getUserLocation() async {
    setState(() => _isLoadingLocation = true);
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
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _jobController.dispose();
    _bioController.dispose();
    super.dispose();
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
                isLoading: _isLoadingLocation,
                onGetLocation: _getUserLocation,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveUserData,
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: _loadUserData,
                    child: const Text('Load'),
                  ),
                  ElevatedButton(
                    onPressed: _clearUserData,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
