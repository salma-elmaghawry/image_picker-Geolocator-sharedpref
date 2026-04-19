import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  double? _latitude;
  double? _longitude;
  String? _address;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
        return;
      }
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitude = position.latitude!;
        _longitude = position.longitude!;
      });
      print('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    if (_latitude != null && _longitude != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _latitude!,
          _longitude!,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            _address = '${place.street}, ${place.locality}, ${place.country}';
          });
          print('Address: $_address');
        } else {
          print('No address found');
        }
      } catch (e) {
        print('Error getting address: $e');
      }
    } else {
      print('Coordinates are not available');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),

          ElevatedButton(
            onPressed: _getImageFromGallery,
            child: const Text('Pick Image from Gallery'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getImageFromCamera,
            child: const Text('Take Photo with Camera'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getLocation,
            child: const Text('Get Location'),
          ),
          Text(
            _latitude != null && _longitude != null
                ? 'Location: $_latitude, $_longitude'
                : 'Location not available',
          ),
          ElevatedButton(
            onPressed: _getAddressFromCoordinates,
            child: const Text('Get Address from Coordinates'),
          ),
          Text(
            _address != null ? 'Address: $_address' : 'Address not available',
          ),
        ],
      ),
    );
  }
}
