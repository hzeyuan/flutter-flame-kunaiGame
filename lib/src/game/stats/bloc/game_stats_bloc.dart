import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_stats_event.dart';

part 'game_stats_state.dart';

class GameStatsBloc extends Bloc<GameStatsEvent, GameStatsState> {
  GameStatsBloc() : super(const GameStatsState.empty()) {
    on<ScoreEventAdded>(
      (event, emit) => emit(
        state.copyWith(score: state.score + event.score),
      ),
    );

    on<ScoreEventCleared>(
      (event, emit) => emit(
        state.copyWith(score: 0),
      ),
    );

    // 苦无数量重置
    on<KunaiNumEvent>(
      (event, emit) => emit(
        state.copyWith(kunaiNum: event.kunaiNum),
      ),
    );

    // 苦无数量重置
    on<LevelEventAdded>(
      (event, emit) => emit(
        state.copyWith(level: event.level),
      ),
    );

    on<PlayerRespawned>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.respawned),
      ),
    );

    on<PlayerDied>((event, emit) {
      emit(
        state.copyWith(status: GameStatus.gameOver, level: 1),
      );
    });

    on<GameReset>(
      (event, emit) => emit(
        const GameStatsState.empty(),
      ),
    );
  }
}
