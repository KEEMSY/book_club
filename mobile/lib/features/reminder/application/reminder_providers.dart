import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/reminder_api.dart';
import '../data/reminder_repository.dart';

final reminderApiProvider = Provider<ReminderApi>((ref) {
  return ReminderApi(ref.watch(dioProvider));
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(reminderApiProvider));
});
