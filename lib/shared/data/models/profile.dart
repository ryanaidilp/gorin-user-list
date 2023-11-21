import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile extends ProfileEntity with _$Profile {
  factory Profile({
    required String id,
    required String email,
    required String name,
    required String avatar,
  }) = _Profile;
  const Profile._()
      : super(
          avatar: '',
          name: '',
          email: '',
          id: '',
        );
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  factory Profile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    // ignore: avoid_unused_constructor_parameters
    SnapshotOptions? options,
  ) {
    final json = snapshot.data();
    log('$json');

    if (json == null) {
      return Profile(id: '', email: '', name: '', avatar: '');
    }

    return Profile(
      id: json['uid'] as String? ?? '',
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
    );
  }
}
