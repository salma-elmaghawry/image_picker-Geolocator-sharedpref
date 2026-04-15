import 'dart:io';

import 'package:flutter/material.dart';

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final LocationService _locationService = LocationService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _jobController.dispose();
    _bioController.dispose();
    super.dispose();
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
            ],
          ),
        ),
      ),
    );
  }
}
