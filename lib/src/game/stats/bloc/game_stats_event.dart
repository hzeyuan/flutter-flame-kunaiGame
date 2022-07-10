import 'package:equatable/equatable.dart';

abstract class GameStatsEvent extends Equatable {
  const GameStatsEvent();
}

class ScoreEventAdded extends GameStatsEvent {
  const ScoreEventAdded(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
}

class KunaiNumEvent extends GameStatsEvent {
  const KunaiNumEvent(this.kunaiNum);
  final int kunaiNum;

  @override
  List<Object?> get props => [kunaiNum];
}

class LevelEventAdded extends GameStatsEvent {
  const LevelEventAdded(this.level);
  final int level;

  @override
  List<Object?> get props => [level];
}

class ScoreEventCleared extends GameStatsEvent {
  const ScoreEventCleared();

  @override
  List<Object?> get props => [];
}

class PlayerDied extends GameStatsEvent {
  const PlayerDied();

  @override
  List<Object?> get props => [];
}

class PlayerRespawned extends GameStatsEvent {
  const PlayerRespawned();

  @override
  List<Object?> get props => [];
}

class GameReset extends GameStatsEvent {
  const GameReset();

  @override
  List<Object?> get props => [];
}
