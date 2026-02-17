import 'dart:io' show File; // mobile/desktop အတွက်
import 'dart:typed_data' show Uint8List; // web အတွက် bytes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  // Mobile/Desktop အတွက်
  File? _videoFile;
  // Web အတွက်
  Uint8List? _videoBytes;
  String? _fileName;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isUploading = false;
  String? _errorMessage;

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final platformFile = result.files.first;

      setState(() {
        _fileName = platformFile.name;

        if (kIsWeb) {
          // Web မှာ bytes သုံး
          _videoBytes = platformFile.bytes;
          _videoFile = null;
        } else {
          // Mobile/Desktop မှာ path သုံး
          _videoFile = File(platformFile.path!);
          _videoBytes = null;
        }
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_fileName == null || (_videoFile == null && _videoBytes == null)) {
      setState(() { _errorMessage = "ဗီဒီယို ဖိုင်မရွေးရသေးပါ"; });
      return;
    }

    if (_titleController.text.isEmpty) {
      setState(() { _errorMessage = "ခေါင်းစဉ် ဖြည့်ပေးပါ"; });
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("အကောင့်ဝင်မထားပါ");

      // ဖိုင်နာမည်အသစ် ဖန်တီး
      final fileExtension = _fileName!.split('.').last;
      final storagePath = 'videos/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final ref = FirebaseStorage.instance.ref().child(storagePath);

      // Upload လုပ်တယ် (platform ခွဲပြီး)
      if (kIsWeb) {
        await ref.putData(_videoBytes!);
      } else {
        await ref.putFile(_videoFile!);
      }

      final downloadUrl = await ref.getDownloadURL();

      // Firestore ထဲ သိမ်း
      await FirebaseFirestore.instance.collection('videos').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'url': downloadUrl,
        'fileName': _fileName,
        'uploadedBy': user.uid,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ဗီဒီယို တင်ပြီးပါပြီ!")),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = "တင်မရပါ: $e";
      });
      print("Upload error: $e");
    } finally {
      setState(() { _isUploading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ဗီဒီယို တင်ရန်")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.video_library),
                label: const Text("ဗီဒီယို ရွေးပါ"),
                onPressed: _pickVideo,
              ),
              if (_fileName != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("ရွေးထားတဲ့ ဖိုင်: $_fileName"),
                ),

              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "ခေါင်းစဉ်",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "ဖော်ပြချက် / ညွန်ကြားချက်",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),

              ElevatedButton(
                onPressed: _isUploading ? null : _uploadVideo,
                child: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : const Text("တင်မယ်"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}