import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'ui_state.dart';

class UiCubit extends Cubit<UiState> with HydratedMixin {
  UiCubit() : super(UiState.empty()) {
    // REFILLING LIVES
    int minutes = state.fullLiveCount * 60 * 1 * 1000; // every twenty minutes over fullLiveCount
    Timer.periodic(const Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      emit(
        state.copyWith(
          remainingTime: (minutes ~/ state.fullLiveCount) - (now - state.lastUpdated),
        ),
      );
      if ((now - state.lastUpdated) >= (minutes / state.fullLiveCount)) {
        if (state.lastLifeCount < state.fullLiveCount) {
          incrementLife();
        }
      }
    });
  }

  decrementLife() {
    emit(state.copyWith(
        lastLifeCount: (state.lastLifeCount - 1),
        lastUpdated: DateTime.now().millisecondsSinceEpoch));
  }

  incrementLife() {
    emit(state.copyWith(
        lastLifeCount: (state.lastLifeCount + 1),
        lastUpdated: DateTime.now().millisecondsSinceEpoch));
  }

  @override
  UiState? fromJson(Map<String, dynamic> json) {
    return UiState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(UiState state) {
    return state.toJson();
  }
}
