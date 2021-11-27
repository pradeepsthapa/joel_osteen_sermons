import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:joel_osteen_sermons/audio/audio_hander.dart';
import 'package:joel_osteen_sermons/audio/media_state.dart';
import 'package:rxdart/rxdart.dart';

final audioHandler = GetIt.I<AudioPlayerHandler>();

Stream<Duration> get customBufferedPositionStream => audioHandler.playbackState.map((state) => state.bufferedPosition).distinct();
Stream<Duration?> get customDurationStream => audioHandler.mediaItem.map((item) => item?.duration).distinct();
Stream<PositionData> get customPositionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  AudioService.position,
  customBufferedPositionStream,
  customDurationStream, (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero),);