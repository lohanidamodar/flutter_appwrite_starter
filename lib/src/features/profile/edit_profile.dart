import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/api_service/api_service.dart';
import 'package:flutter_appwrite_starter/src/api_service/constants.dart';
import 'package:flutter_appwrite_starter/src/components/avatar.dart';
import 'package:flutter_appwrite_starter/src/features/profile/crop_page.dart';
import 'package:flutter_appwrite_starter/src/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  static String name = 'edit_profile';
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController? _nameController;
  late bool _processing;
  AppState? state;
  late XFile _image;
  Uint8List? _imageBytes;
  String? _uploadedFileId;

  @override
  void initState() {
    super.initState();
    _processing = false;
    state = AppState.free;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final authNotifier = ref.read(authProvider.notifier);
      final authState = ref.watch(authProvider);
      final User user = authState.user!;
      final prefs = authState.user!.prefs.data;
      _nameController = TextEditingController(text: user.name);
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editProfile),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Consumer(
              builder: (_, watch, __) {
                return FutureBuilder(
                    future: prefs['photoId'] != null
                        ? ApiService.instance.getImageAvatar(
                            ApiConstants.profileBucketId, prefs['photoId']!)
                        : ApiService.instance.getAvatar(user.name),
                    builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                      return Center(
                        child: Avatar(
                          showButton: true,
                          onButtonPressed: _pickImageButtonPressed,
                          radius: 50,
                          image:
                              state == AppState.cropped && _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : (prefs['photoUrl'] != null
                                      ? NetworkImage(prefs['photoUrl']!)
                                      : snapshot.hasData
                                          ? MemoryImage(snapshot.data!)
                                          : null) as ImageProvider<dynamic>?,
                        ),
                      );
                    });
              },
            ),
            const SizedBox(height: 10.0),
            Center(child: Text(user.email)),
            const SizedBox(height: 10.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).nameFieldLabel),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: _processing
                    ? null
                    : () async {
                        //save name
                        if (_nameController!.text.isEmpty &&
                            (_imageBytes == null ||
                                state != AppState.cropped)) {
                          return;
                        }
                        setState(() {
                          _processing = true;
                        });

                        if (_imageBytes != null && state == AppState.cropped) {
                          await uploadImage(user);
                        }
                        if (_nameController!.text.isNotEmpty) {
                          await authNotifier.updateName(
                              name: _nameController!.text);
                        }
                        if (_uploadedFileId != null) {
                          prefs['photoId'] = _uploadedFileId;
                          await authNotifier.updatePrefs(prefs: prefs);
                        }
                        setState(() {
                          _processing = false;
                        });
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                child: _processing
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context).saveButtonLabel),
              ),
            )
          ],
        ),
      );
    });
  }

  void _pickImageButtonPressed() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).pickImageDialogTitle,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ...ListTile.divideTiles(
                  color: Theme.of(context).dividerColor,
                  tiles: [
                    ListTile(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      title: Text(AppLocalizations.of(context)
                          .pickFromCameraButtonLabel),
                    ),
                    ListTile(
                      onTap: () {
                        getImage(ImageSource.gallery);
                      },
                      title: Text(AppLocalizations.of(context)
                          .pickFromGalleryButtonLabel),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).cancelButtonLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    _image = image;
    setState(() {
      state = AppState.picked;
    });
    if (!mounted) {
      return;
    }
    context.pop();
    _cropImage();
  }

  Future<void> _cropImage() async {
    final ib = await _image.readAsBytes();
    if (!mounted) {
      return;
    }
    final image = await context.pushNamed<Uint8List?>(
      CropPage.name,
      extra: ib,
    );
    if (image == null) return;
    _imageBytes = image;
    setState(() {
      state = AppState.cropped;
    });
    /* File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      maxWidth: 800,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    } */
  }

  Future uploadImage(User user) async {
    final file = InputFile.fromBytes(
        bytes: _imageBytes!,
        filename: "${user.$id}.png",
        contentType: 'image/png');
    final res = await ApiService.instance.uploadFile(
      ApiConstants.profileBucketId,
      file,
      permissions: [
        Permission.write(Role.user(user.$id)),
        Permission.read(Role.any())
      ],
    );
    _uploadedFileId = res.$id;
  }
}
