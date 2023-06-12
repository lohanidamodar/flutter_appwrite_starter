import 'dart:typed_data';
import 'package:api_service/api_service.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile/src/constants.dart';
import 'package:profile/types.dart';

import '../l10n/profile_localizations.dart';
import '../widgets/avatar.dart';

class EditProfile extends StatefulWidget {
  final VoidCallback onPop;
  final GotoCropPageCallback onGotoCropPage;
  const EditProfile(
      {Key? key, required this.onPop, required this.onGotoCropPage})
      : super(key: key);

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
    _nameController =
        TextEditingController(text: context.authNotifier.user?.name);
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.authNotifier;
    final User user = authNotifier.user!;
    final prefs = authNotifier.user!.prefs.data;
    final l10n = ProfileLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Consumer(
            builder: (_, watch, __) {
              return FutureBuilder(
                  future: prefs['photoId'] != null
                      ? ApiService.instance.getImageAvatar(
                          ProfileConstants.profileBucketId, prefs['photoId']!)
                      : ApiService.instance.getAvatar(user.name),
                  builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                    return Center(
                      child: Avatar(
                        showButton: true,
                        onButtonPressed: () => _pickImageButtonPressed(l10n),
                        radius: 50,
                        image: state == AppState.cropped && _imageBytes != null
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
            decoration: InputDecoration(labelText: l10n.nameFieldLabel),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: ElevatedButton(
              onPressed: _processing
                  ? null
                  : () async {
                      //save name
                      if (_nameController!.text.isEmpty &&
                          (_imageBytes == null || state != AppState.cropped)) {
                        return;
                      }
                      setState(() {
                        _processing = true;
                      });

                      if (_imageBytes != null && state == AppState.cropped) {
                        await uploadImage();
                      }
                      if (_nameController!.text.isNotEmpty) {
                        await authNotifier.updateName(
                            name: _nameController!.text);
                      }
                      if (_uploadedFileId != null) {
                        prefs['photoId'] = _uploadedFileId;
                        await authNotifier.updatePrefs(prefs: prefs);
                      }
                      if (mounted) {
                        setState(() {
                          _processing = false;
                        });
                        widget.onPop.call();
                      }
                    },
              child: _processing
                  ? const CircularProgressIndicator()
                  : Text(l10n.saveButtonLabel),
            ),
          )
        ],
      ),
    );
  }

  void _pickImageButtonPressed(ProfileLocalizations l10n) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              l10n.pickImageDialogTitle,
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
                      title: Text(l10n.pickFromCameraButtonLabel),
                    ),
                    ListTile(
                      onTap: () {
                        getImage(ImageSource.gallery);
                      },
                      title: Text(l10n.pickFromGalleryButtonLabel),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.cancelButtonLabel,
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
    widget.onPop?.call();
    _cropImage();
  }

  Future<void> _cropImage() async {
    final ib = await _image.readAsBytes();
    final image = await widget.onGotoCropPage(ib);
    if (image == null) return;
    _imageBytes = image;
    setState(() {
      state = AppState.cropped;
    });
  }

  Future uploadImage() async {
    final file = InputFile.fromBytes(
        bytes: _imageBytes!,
        filename: "${context.authNotifier.user!.$id}.png",
        contentType: 'image/png');
    final res = await ApiService.instance.uploadFile(
      ProfileConstants.profileBucketId,
      file,
      permissions: [
        Permission.write(Role.user(context.authNotifier.user!.$id)),
        Permission.read(Role.any())
      ],
    );
    _uploadedFileId = res.$id;
  }
}
