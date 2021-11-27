// import 'package:audio_service/audio_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:joel_osteen_sermons/audio/audio_hander.dart';
//
// class AudioProvider{
//   Future<void> startService() async {
//     final AudioPlayerHandler audioHandler = await AudioService.init(
//       builder: () => AudioPlayerHandlerImpl(),
//       config: const AudioServiceConfig(
//         androidNotificationChannelId: 'com.ccbc.joel_osteen_sermons',
//         androidNotificationChannelName: 'Joel Osteen Sermons',
//         androidNotificationOngoing: true,
//         // androidNotificationIcon: 'drawable/ic_stat_music_note',
//         // androidShowNotificationBadge: true,
//         // notificationColor: Colors.grey[900],
//       ),
//     );
//     final
//   }
// }
//
// final audioProvider = Provider((ref)=>AudioProvider());
// final audioStateProvider = StateProvider(()=>AudioPlayerHandler);
