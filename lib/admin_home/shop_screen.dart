import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:c_o2e/flutter_flow/model/shop.dart';

class AdminShopPage extends StatefulWidget {
  static const String id = 'admin_shop_page';
  const AdminShopPage({super.key});

  @override
  State<AdminShopPage> createState() => _AdminShopPageState();
}

class _AdminShopPageState extends State<AdminShopPage> {
  String name = '';
  int price = 0;
  String description = '';
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> uploadShopItem() async {
    if (name.isEmpty || description.isEmpty || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('shop_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image!);
      final snapshot = await uploadTask;
      final imagePath = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('shops').add({
        'name': name,
        'price': price,
        'description': description,
        'imagePath': imagePath,
      });

      setState(() {
        name = '';
        price = 0;
        description = '';
        image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop item uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload shop item: $e')),
      );
    }
  }

  Future<void> deleteShopItem(String id) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('shops').doc(id);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        String? imagePath = docSnapshot.get('imagePath') as String?;

        await docRef.delete();

        if (imagePath != null && imagePath.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(imagePath).delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop item deleted successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete shop item: $e')),
      );
    }
  }

  Future<void> updateShopItem(String id, Shop shop) async {
    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      String? imagePath;

      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('shop_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(image!);
        final snapshot = await uploadTask;
        imagePath = await snapshot.ref.getDownloadURL();
      } else {
        imagePath = shop.imagePath;
      }

      await FirebaseFirestore.instance.collection('shops').doc(id).update({
        'name': name,
        'price': price,
        'description': description,
        'imagePath': imagePath,
      });

      setState(() {
        name = '';
        price = 0;
        description = '';
        image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop item updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update shop item: $e')),
      );
    }
  }

  void showAddItemDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Shop Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(hintText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                  onPressed: pickImage,
                ),
                if (image != null)
                  const Text('Image selected',
                      style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  price = int.tryParse(priceController.text) ?? 0;
                  description = descriptionController.text;
                });
                uploadShopItem();
                Navigator.pop(context);
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  void showEditItemDialog(String id, Shop shop) {
    final nameController = TextEditingController(text: shop.name);
    final priceController = TextEditingController(text: shop.price.toString());
    final descriptionController = TextEditingController(text: shop.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Shop Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(hintText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                  onPressed: pickImage,
                ),
                if (image != null)
                  const Text('Image selected',
                      style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  price = int.tryParse(priceController.text) ?? 0;
                  description = descriptionController.text;
                });
                updateShopItem(id, shop);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shop),
            SizedBox(width: 10),
            Text('商店管理'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddItemDialog,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('shops').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          final shopDocs = snapshot.data?.docs ?? [];

          if (shopDocs.isEmpty) {
            return const Center(child: Text('No shop items available'));
          }

          return ListView.builder(
            itemCount: shopDocs.length,
            itemBuilder: (context, index) {
              final shop = Shop.fromDocument(shopDocs[index]);
              return Card(
                child: ListTile(
                  leading: Image.network(shop.imagePath),
                  title: Text(shop.name),
                  subtitle: Text('Price: \$${shop.price}\n${shop.description}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        showEditItemDialog(shopDocs[index].id, shop);
                      } else if (value == 'Delete') {
                        deleteShopItem(shopDocs[index].id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
