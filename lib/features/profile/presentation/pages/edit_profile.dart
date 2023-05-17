import 'dart:typed_data';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/presentation/router/router.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/widgets/avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Consumer(
            builder: (_, watch, __) {
              return FutureBuilder(
                  future: prefs['photoId'] != null
                      ? ApiService.instance.getImageAvatar(
                          AppConstants.profileBucketId, prefs['photoId']!)
                      : ApiService.instance.getAvatar(user.name),
                  builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                    return Center(
                      child: Avatar(
                        showButton: true,
                        onButtonPressed: _pickImageButtonPressed,
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
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nameFieldLabel),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: ElevatedButton(
              child: _processing
                  ? const CircularProgressIndicator()
                  : Text(AppLocalizations.of(context)!.saveButtonLabel),
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
                        context.pop();
                      }
                    },
            ),
          )
        ],
      ),
    );
  }

  void _pickImageButtonPressed() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.pickImageDialogTitle,
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
                      title: Text(AppLocalizations.of(context)!
                          .pickFromCameraButtonLabel),
                    ),
                    ListTile(
                      onTap: () {
                        getImage(ImageSource.gallery);
                      },
                      title: Text(AppLocalizations.of(context)!
                          .pickFromGalleryButtonLabel),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.cancelButtonLabel,
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
    context.pop();
    _cropImage();
  }

  Future<void> _cropImage() async {
    final ib = await _image.readAsBytes();
    final image = await context.pushNamed<Uint8List?>(
      AppRoutes.cropPage,
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

  Future uploadImage() async {
    final file = InputFile.fromBytes(
        bytes: _imageBytes!,
        filename: "${context.authNotifier.user!.$id}.png",
        contentType: 'image/png');
    final res = await ApiService.instance.uploadFile(
      AppConstants.profileBucketId,
      file,
      permissions: [
        Permission.write(Role.user(context.authNotifier.user!.$id)),
        Permission.read(Role.any())
      ],
    );
    _uploadedFileId = res.$id;
  }
}
