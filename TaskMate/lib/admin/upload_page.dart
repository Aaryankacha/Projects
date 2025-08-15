import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _fileName;
  String? _responseMessage;
  bool _isUploading = false;

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      setState(() {
        _fileName = fileName;
        _isUploading = true;
      });

      final uri = Uri.parse(
        'your-URL',
      );
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      try {
        var response = await request.send();
        var res = await http.Response.fromStream(response);
        setState(() {
          _isUploading = false;
          _responseMessage = response.statusCode == 200
              ? 'Uploaded Successfully!\nURL: ${res.body}'
              : 'Failed! Status: ${response.statusCode}';
        });
      } catch (e) {
        setState(() {
          _isUploading = false;
          _responseMessage = 'Upload failed: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload File")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isUploading ? null : pickAndUploadFile,
              child: const Text("Pick & Upload File"),
            ),
            const SizedBox(height: 20),
            if (_fileName != null) Text("Selected: $_fileName"),
            if (_isUploading) const CircularProgressIndicator(),
            if (_responseMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(_responseMessage!, textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
    );
  }
}
