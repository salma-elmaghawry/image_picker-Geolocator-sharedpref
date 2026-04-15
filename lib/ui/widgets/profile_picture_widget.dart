import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/image_service.dart';

class ProfilePictureWidget extends StatefulWidget {
  final File? selectedImage;
  final Function(File?) onImageSelected;

  const ProfilePictureWidget({
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  final ImageService _imageService = ImageService();

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    final image = await _imageService.pickImageFromCamera();
    if (image != null) {
      widget.onImageSelected(image);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final image = await _imageService.pickImageFromGallery();
    if (image != null) {
      widget.onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: widget.selectedImage != null
              ? FileImage(widget.selectedImage!)
              : null,
          child: widget.selectedImage == null
              ? Icon(Icons.person, size: 60, color: Colors.grey[600])
              : null,
        ),
        FloatingActionButton(
          mini: true,
          onPressed: _showImagePickerOptions,
          backgroundColor: Colors.green,
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }
}
