import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  XFile? pickedImage;
  Uint8List? previewBytes;
  bool saving = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      pickedImage = picked;
      previewBytes = bytes;
    });
  }

  Future<void> saveProduct() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('নাম, দাম ও ছবি দিন')),
      );
      return;
    }

    setState(() => saving = true);
    try {
      // ১. ছবি Storage-এ আপলোড
      final imageUrl = await StorageService.uploadProductImage(pickedImage!);

      // ২. তথ্য Firestore-এ সেভ
      await FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text.trim(),
        'price': double.tryParse(priceController.text) ?? 0,
        'image': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোডাক্ট সেভ হয়েছে')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('সেভ ব্যর্থ: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: previewBytes == null
                    ? const Center(child: Text('ছবি বাছাই করতে ট্যাপ করুন'))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(previewBytes!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 24),
            saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: saveProduct,
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}