import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:metatube_flutter/services/file_service.dart';
import 'package:metatube_flutter/utils/app_styles.dart';
import 'package:metatube_flutter/widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileService fileService = FileService();

  @override
  void initState() {
    addListeners();
    super.initState();
  }

  @override
  void dispose() {
    removeListeners();
    super.dispose();
  }

  void addListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.descriptionController,
      fileService.tagsController
    ];

    for (TextEditingController c in controllers) {
      c.addListener(_onFieldChanged);
    }
  }

  void removeListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.descriptionController,
      fileService.tagsController
    ];

    for (TextEditingController c in controllers) {
      c.removeListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    setState(() {
      fileService.fieldNotEmpty = fileService.titleController.text.isNotEmpty &&
          fileService.tagsController.text.isNotEmpty &&
          fileService.descriptionController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _mainButton(() => fileService.newFile(context), 'new File'),
                Row(
                  children: [
                    _actionButton(
                        () => fileService.loadFile(context), Icons.file_upload),
                    const SizedBox(width: 8),
                    _actionButton(() => fileService.selectDirectory(context),
                        Icons.folder)
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              maxLength: 100,
              hintText: 'Enter Video Title',
              controller: fileService.titleController,
              maxLines: 3,
            ),
            const SizedBox(
              height: 40,
            ),
            CustomTextField(
              maxLength: 500,
              hintText: 'Enter Video Description',
              controller: fileService.descriptionController,
              maxLines: 5,
            ),
            const SizedBox(
              height: 40,
            ),
            CustomTextField(
              maxLength: 500,
              hintText: 'Enter Video Tags',
              controller: fileService.tagsController,
              maxLines: 4,
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                _mainButton(
                    fileService.fieldNotEmpty
                        ? () => fileService.saveContent(context)
                        : null,
                    'Save File')
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _mainButton(Function()? onPressed, String data) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(data),
      style: _buttonStyle(),
    );
  }

  IconButton _actionButton(Function()? onPressed, IconData icon) {
    return IconButton(
      icon: Icon(
        icon,
        color: AppTheme.medium,
      ),
      splashRadius: 20,
      splashColor: AppTheme.accent,
      onPressed: onPressed,
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accent,
        disabledBackgroundColor: AppTheme.disabledBackgroundColor,
        disabledForegroundColor: AppTheme.disabledForegroundColor);
  }
}
