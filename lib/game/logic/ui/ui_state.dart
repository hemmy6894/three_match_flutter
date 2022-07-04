part of 'ui_cubit.dart';

class UiState extends Equatable {
  final int fullLiveCount;
  final int lastLifeCount;
  final int lastUpdated;
  final int remainingTime;
  final Map<CharacterType, int> received;
  final List<RewardModel> rewards;



  const UiState(
      {required this.fullLiveCount,
      required this.lastLifeCount,
      required this.remainingTime,
      required this.rewards,
      required this.received,
      required this.lastUpdated});

  UiState copyWith({
    int? fullLiveCount,
    int? lastLifeCount,
    int? lastUpdated,
    int? remainingTime,
    Map<CharacterType, int>? received,
    List<RewardModel>? rewards,

  }) {
    return UiState(
      fullLiveCount: fullLiveCount ?? this.fullLiveCount,
      lastLifeCount: lastLifeCount ?? this.lastLifeCount,
      remainingTime: remainingTime ?? this.remainingTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rewards: rewards ?? this.rewards,
      received: received ?? this.received,
    );
  }

  factory UiState.empty() {
    return UiState(
        fullLiveCount: 5,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
        remainingTime: 0,

        received: const {},
        rewards: const [],
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
      rewards: RewardModel.getList(json["rewards"]),
      received: const {},

      remainingTime: json["remaining_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_live_count": fullLiveCount,
      "last_updated": lastUpdated,
      "last_life_count": lastLifeCount,
      "rewards": RewardModel.getMap(rewards),
      "remaining_time": remainingTime,
    };
  }

  int getRewardCount(CharacterType characterType) {
    for (RewardModel reward in rewards) {
      if (reward.character == characterType) {
        return reward.amount;
      }
    }
    return 0;
  }

  @override
  List<Object?> get props => [
        fullLiveCount,
        lastUpdated,
        lastLifeCount,
        rewards,
        received,

        remainingTime,
      ];
}
