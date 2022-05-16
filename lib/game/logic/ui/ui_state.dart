part of 'ui_cubit.dart';

class UiState extends Equatable {
  final int fullLiveCount;
  final int lastLifeCount;
  final int lastUpdated;
  final int remainingTime;

  const UiState(
      {required this.fullLiveCount,
      required this.lastLifeCount,
      required this.remainingTime,
      required this.lastUpdated});

  UiState copyWith({
    int? fullLiveCount,
    int? lastLifeCount,
    int? lastUpdated,
    int? remainingTime,
  }) {
    return UiState(
      fullLiveCount: fullLiveCount ?? this.fullLiveCount,
      lastLifeCount: lastLifeCount ?? this.lastLifeCount,
      remainingTime: remainingTime ?? this.remainingTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory UiState.empty() {
    return UiState(
        fullLiveCount: 5,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
        remainingTime: 0,
        lastLifeCount: 1);
  }

  factory UiState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UiState.empty();
    }
    return UiState(
      fullLiveCount: json["full_live_count"],
      lastLifeCount: json["last_life_count"],
      lastUpdated: json["last_updated"],
      remainingTime: json["remaining_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_live_count": fullLiveCount,
      "last_updated": lastUpdated,
      "last_life_count": lastLifeCount,
      "remaining_time": remainingTime,
    };
  }

  @override
  List<Object?> get props => [
        fullLiveCount,
        lastUpdated,
        lastLifeCount,
        remainingTime,
      ];
}
