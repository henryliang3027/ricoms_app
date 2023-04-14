import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ricoms_app/repository/root_repository/device_repository.dart';
import 'package:ricoms_app/repository/user.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';

part 'device_history_event.dart';
part 'device_history_state.dart';

class DeviceHistoryBloc extends Bloc<DeviceHistoryEvent, DeviceHistoryState> {
  DeviceHistoryBloc({
    required User user,
    required DeviceRepository deviceRepository,
    required int nodeId,
  })  : _user = user,
        _deviceRepository = deviceRepository,
        _nodeId = nodeId,
        super(const DeviceHistoryState()) {
    on<HistoryRequested>(_onHistoryRequested);
    on<MoreRecordsRequested>(_onMoreRecordsRequested);
    on<FloatingActionButtonHided>(_onFloatingActionButtonHided);
    on<FloatingActionButtonShowed>(_onFloatingActionButtonShowed);

    add(HistoryRequested(_nodeId));
  }

  final User _user;
  final DeviceRepository _deviceRepository;
  final int _nodeId;

  /// 處理針對特定 device 歷史紀錄的獲取
  Future<void> _onHistoryRequested(
    DeviceHistoryEvent event,
    Emitter<DeviceHistoryState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    List<dynamic> resultOfDeviceHistory =
        await _deviceRepository.getDeviceHistory(user: _user, nodeId: _nodeId);

    if (resultOfDeviceHistory[0]) {
      List<DeviceHistoryData> deviceHistoryRecords = resultOfDeviceHistory[1];
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        deviceHistoryRecords: deviceHistoryRecords,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        deviceHistoryRecords: [],
        errmsg: resultOfDeviceHistory[1],
      ));
    }
  }

  /// 處理更多歷史紀錄的獲取
  Future<void> _onMoreRecordsRequested(
    MoreRecordsRequested event,
    Emitter<DeviceHistoryState> emit,
  ) async {
    emit(state.copyWith(
      moreRecordsStatus: FormStatus.requestInProgress,
    ));

    // 取得最新的 device history records ( api 預設回傳最多 1000 筆 ) , 用來檢查是否有新的 record 產生
    List<dynamic> resultOfNewDeviceHistory =
        await _deviceRepository.getDeviceHistory(user: _user, nodeId: _nodeId);

    List<dynamic> resultOfDeviceHistory =
        await _deviceRepository.getMoreDeviceHistory(
      user: _user,
      nodeId: _nodeId,
      trapId: state.deviceHistoryRecords.last.trapId,
      next: 'top',
    );

    if (resultOfDeviceHistory[0]) {
      List<DeviceHistoryData> deviceHistoryRecords = [];
      deviceHistoryRecords.addAll(state.deviceHistoryRecords);

      if (resultOfNewDeviceHistory[0]) {
        // 目前的最新的一筆 record, 在 newRecords 裡的哪一個 index
        // 如果 index = 0; 代表沒有新的紀錄
        // 如果 index = -1; 代表找不到, 不做任何動作, 基本上不會有這種情況
        // 如果 index > 0; 有新的紀錄
        List<DeviceHistoryData> newdeviceHistoryRecords =
            resultOfNewDeviceHistory[1];
        int index = newdeviceHistoryRecords.indexWhere(
          (newdeviceHistoryRecord) =>
              newdeviceHistoryRecord.trapId == deviceHistoryRecords[0].trapId,
        );

        // 把新的紀錄加到 record list 的最前面
        if (index > 0) {
          deviceHistoryRecords.insertAll(
              0, newdeviceHistoryRecords.getRange(0, index));
        }
      }

      deviceHistoryRecords.addAll(resultOfDeviceHistory[1]);

      emit(state.copyWith(
        moreRecordsStatus: FormStatus.requestSuccess,
        deviceHistoryRecords: deviceHistoryRecords,
      ));
    } else {
      emit(state.copyWith(
        moreRecordsStatus: FormStatus.requestFailure,
        moreRecordsMessage: resultOfDeviceHistory[1],
      ));
    }
  }

  /// 隱藏載入更多歷史紀錄的 floating action button
  void _onFloatingActionButtonHided(
    FloatingActionButtonHided event,
    Emitter<DeviceHistoryState> emit,
  ) {
    emit(state.copyWith(
      moreRecordsStatus: FormStatus.none,
      isShowFloatingActionButton: false,
    ));
  }

  /// 顯示載入更多歷史紀錄的 floating action button, 當頁面滑到底部時會觸發 button 顯示
  void _onFloatingActionButtonShowed(
    FloatingActionButtonShowed event,
    Emitter<DeviceHistoryState> emit,
  ) {
    emit(state.copyWith(
      moreRecordsStatus: FormStatus.none,
      isShowFloatingActionButton: true,
    ));
  }
}
