part of 'ui_cubit.dart';

class UiState extends Equatable {
  final int fullLiveCount;
  final int lastLifeCount;
  final int lastUpdated;
  final int remainingTime;
  final Map<CharacterType, int> received;
  final List<Map<CharacterType, int>> rewards;

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
    List<Map<CharacterType, int>>? rewards,
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
    List<Map<CharacterType,int>> getList(List<dynamic> json){
      List<Map<CharacterType,int>> elements = [];
      try {
        for (List<dynamic> el in json) {
          elements.add({el[0]: el[1]});
        }
      }catch(e){
        elements = [];
      }
      print(elements);
      return elements;
    }
    return UiState(
      fullLiveCount: json["full_live_count"],
      lastLifeCount: json["last_life_count"],
      lastUpdated: json["last_updated"],
      rewards: getList(json["rewards"]),
      received: const {},
      remainingTime: json["remaining_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_live_count": fullLiveCount,
      "last_updated": lastUpdated,
      "last_life_count": lastLifeCount,
      "rewards": rewards.map((e) => [e.entries.first.key.toString(),e.entries.first.value]).toList(),
      "remaining_time": remainingTime,
    };
  }

  int getRewardCount(CharacterType characterType){
    for(Map<CharacterType,int> reward in rewards){
      if(reward.entries.first.key == characterType){
        return reward.entries.first.value;
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
