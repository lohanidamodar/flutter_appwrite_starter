import 'dart:io';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/presentation/providers/providers.dart';
import 'package:flutter_appwrite_starter/core/res/data_constants.dart';
import 'package:flutter_appwrite_starter/core/res/routes.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user_field.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/widgets/avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfile extends StatefulWidget {
  final User user;

  const EditProfile({Key key, this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController;
  bool _processing;
  AppState state;
  PickedFile _image;
  Uint8List _imageBytes;
  String _uploadedFileId;

  @override
  void initState() {
    super.initState();
    _processing = false;
    state = AppState.free;
    _nameController = TextEditingController(text: widget.user?.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Consumer(
            builder: (_, watch, __) {
              final userRepo = watch(userRepoProvider);
              return FutureBuilder(
                  future: userRepo.prefs.photoId != null
                      ? ApiService.instance
                          .getImageAvatar(userRepo.prefs.photoId)
                      : ApiService.instance.getAvatar(widget.user.name),
                  builder: (context, snapshot) {
                    return Center(
                      child: Avatar(
                        showButton: true,
                        onButtonPressed: _pickImageButtonPressed,
                        radius: 50,
                        image: state == AppState.cropped && _imageBytes != null
                            ? MemoryImage(_imageBytes)
                            : userRepo.prefs.photoUrl != null
                                ? NetworkImage(userRepo.prefs.photoUrl)
                                : snapshot.hasData
                                    ? MemoryImage(snapshot.data.data)
                                    : null,
                      ),
                    );
                  });
            },
          ),
          const SizedBox(height: 10.0),
          Center(child: Text(widget.user.email)),
          const SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).nameFieldLabel),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: ElevatedButton(
              child: _processing
                  ? CircularProgressIndicator()
                  : Text(AppLocalizations.of(context).saveButtonLabel),
              onPressed: _processing
                  ? null
                  : () async {
                      //save name
                      if (_nameController.text.isEmpty &&
                          (_imageBytes == null || state != AppState.cropped))
                        return;
                      setState(() {
                        _processing = true;
                      });
                      if (_imageBytes != null && state == AppState.cropped) {
                        await uploadImage();
                      }
                      Map<String, dynamic> data = {};
                      if (_nameController.text.isNotEmpty)
                        data[UserFields.name] = _nameController.text;
                      if (_uploadedFileId != null)
                        data[UserFields.photoUrl] = _uploadedFileId;
                      if (data.isNotEmpty) {
                        //update data
                        await context.read(userRepoProvider).updateProfile(
                            name: _nameController.text,
                            photoId: _uploadedFileId);
                      }
                      if (mounted) {
                        setState(() {
                          _processing = false;
                        });
                        Navigator.pop(context);
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
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context).cancelButtonLabel,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker().getImage(source: source);
    if (image == null) return;
    _image = image;
    setState(() {
      state = AppState.picked;
    });
    Navigator.pop(context);
    _cropImage();
  }

  Future<Null> _cropImage() async {
    final ib = await _image.readAsBytes();
    final image = await Navigator.pushNamed(
      context,
      AppRoutes.cropPage,
      arguments: ib,
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
    final file =
        MultipartFile.fromBytes(_imageBytes, filename: "${widget.user.id}.png");
    final res = await ApiService.instance
        .uploadFile(file, write: ['user:${widget.user.id}']);
    _uploadedFileId = res.data['\$id'];

    //upload file

    /* setState(() {
      _uploadedFileURL = url;
    }); */
  }
}
