import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/device_status_model.dart';

final deviceStatusProvider =
    StateNotifierProvider<DeviceStatusNotifier, AsyncValue<DeviceStatusModel>>(
        (ref) {
  return DeviceStatusNotifier();
});

class DeviceStatusNotifier
    extends StateNotifier<AsyncValue<DeviceStatusModel>> {
  DeviceStatusNotifier() : super(const AsyncLoading());

  void updateStatus(DeviceStatusModel status) {
    state = AsyncData(status);
  }

  void setError(String error) {
    state = AsyncError(error, StackTrace.current);
  }
}
