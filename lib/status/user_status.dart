import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';

/// User authorization completion status
/// [notCompletedSetup] - user did not enter his personal data
/// [notAccepted] - user did not confirm terms of use
/// [completedSetup] - user completely finished the step of authorization
enum UserStatus { notCompletedSetup, notAccepted, completedSetup }

UserStatus? decodeUserStatus(String? value) {
  if (value == null) {
    throw Exception('Value not found');
  }
  var status =
      UserStatus.values.singleWhereOrNull((e) => encodeUserStatus(e) == value);

  return status;
}

String encodeUserStatus(UserStatus status) {
  return describeEnum(status);
}
