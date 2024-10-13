import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metatube_flutter/utils/snackbar_utils.dart';

class FileService {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  bool fieldNotEmpty = false;

  File? _selectedFile = null;
  String _selectedDirectory = '';

  void saveContent(context) async {
    final title = titleController.text;
    final description = descriptionController.text;
    final tags = tagsController.text;

    final textContent =
        "Title:\n\n$title\n\nDescription:\n\n$description\n\nTags:\n\n$tags";

    try {
      if (_selectedFile != null) {
        await _selectedFile!.writeAsString(textContent);
      } else {
        final todayDate = getTodayDate();
        String metadataDirPath = _selectedDirectory;

        if (metadataDirPath.isEmpty) {
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = metadataDirPath = directory!;
        }

        final filePath = '$metadataDirPath/$todayDate-$title-metadata.txt';
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);

        SnackbarUtils.showSnackbar(
            context, 'File saved successfully', Icons.check);
      }
    } catch (e) {
      print(e);
      SnackbarUtils.showSnackbar(context, 'file not saved', Icons.error);
    }
  }

  void loadFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result == null) {
        SnackbarUtils.showSnackbar(context, 'no file selected', Icons.error);
        throw Exception('no file selected');
      }

      File file = File(result.files.single.path!);
      _selectedFile = file;

      final fileContent = await file.readAsString();

      final lines = fileContent.split('\n\n');

      titleController.text = lines[1];
      descriptionController.text = lines[3];
      tagsController.text = lines[5];

      SnackbarUtils.showSnackbar(context, 'file uploaded', Icons.upload_file);
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'something went wrong', Icons.error);
    }
  }

  void selectDirectory(context) async {
    try {
      final String? directory = await FilePicker.platform.getDirectoryPath();

      if (directory != null) {
        _selectedDirectory = directory;
        _selectedFile = null;

        SnackbarUtils.showSnackbar(
            context, 'directory successfully updated', Icons.check);
      } else {
        SnackbarUtils.showSnackbar(
            context, 'no directory selected', Icons.error);
      }
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'something went wrong', Icons.error);
    }
  }

  void newFile(context) {
    _selectedFile = null;

    titleController.clear();
    descriptionController.clear();
    tagsController.clear();

    SnackbarUtils.showSnackbar(context, 'new file created', Icons.check);
  }

  static String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }
}
