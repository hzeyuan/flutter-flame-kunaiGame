part of 'game_stats_bloc.dart';

enum GameStatus {
  initial,
  respawn,
  respawned,
  gameOver,
}

class GameStatsState extends Equatable {
  final int score; // 总分数
  final int kunaiNum; // 苦无数量
  final bool isMute;
  final GameStatus status;
  final int level; //当前关卡

  const GameStatsState({
    required this.score,
    required this.status,
    required this.isMute,
    required this.level,
    required this.kunaiNum,
  });

  const GameStatsState.empty()
      : this(
          score: 0,
          status: GameStatus.initial,
          isMute: false,
          level: 1,
          kunaiNum: 9,
        );

  GameStatsState copyWith({
    int? score,
    GameStatus? status,
    int? level,
    int? kunaiNum,
    bool? isMute,
  }) {
    return GameStatsState(
      score: score ?? this.score,
      status: status ?? this.status,
      isMute: isMute ?? this.isMute,
      level: level ?? this.level,
      kunaiNum: kunaiNum ?? this.kunaiNum,
    );
  }

  @override
  List<Object?> get props => [score, status, kunaiNum, level];
}
