import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';

class StorageProvider {
  final FirebaseStorage _storageReference = FirebaseStorage.instance;

  Future<String> uploadJD(File file, ReferralModel referralModel) async {
    StorageReference storageReference = _storageReference
        .ref()
        .child("jd/" + referralModel.getModel[ReferralConstants.REFERRAL_ID]);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Future<void> uploadPic(ProfileModel _profile, File img) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        "profilePictures/" + _profile.getModel[ProfileConstants.USERNAME]);
    final StorageUploadTask uploadTask = storageReference.putFile(img);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    _profile.getModel[ProfileConstants.PROFILE_PIC_URL] = url;
  }

  Future<void> uploadCover(ProfileModel _profile, File img) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("coverPictures/" + _profile.getModel[ProfileConstants.USERNAME]);
    final StorageUploadTask uploadTask = storageReference.putFile(img);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    _profile.getModel[ProfileConstants.COVER_URL] = url;
  }

  Future<String> uploadResume(ProfileModel _profile, File resume) async {
    StorageReference storageReference = _storageReference
        .ref()
        .child("resume/" + _profile.getModel[ProfileConstants.USERNAME]);
    final StorageUploadTask uploadTask = storageReference.putFile(resume);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    _profile.getModel[ProfileConstants.RESUME_URL] = url;
    return url;
  }
}
