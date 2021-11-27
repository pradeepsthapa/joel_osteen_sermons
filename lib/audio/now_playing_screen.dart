// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get_it/get_it.dart';
// import 'audio_hander.dart';
//
// class NowPlayingScreen extends ConsumerStatefulWidget {
//   const NowPlayingScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState createState() => _NowPlayingScreenState();
// }
//
// class _NowPlayingScreenState extends ConsumerState<NowPlayingScreen> {
//
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final handler = GetIt.instance<AudioPlayerHandler>();
//     return Scaffold(
//       appBar: AppBar(title: const Text("Now Playing"),),
//       body: StreamBuilder<MediaItem?>(
//         stream: handler.mediaItem,
//         builder: (context, snapshot) {
//           if(snapshot.connectionState==ConnectionState.waiting){
//             return const Center(child: CircularProgressIndicator(),);
//           }
//           final MediaItem? mediaItem = snapshot.data;
//           return Column(
//             children: [
//               StreamBuilder<PlaybackState>(
//                 stream: handler.playbackState,
//                 builder: (ctx, snap){
//                   final playbackState = snap.data;
//                   final processingState = playbackState?.processingState;
//                   final playing = playbackState?.playing ?? false;
//                   return Stack(
//                     children: [
//                       if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering)
//                         Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Theme.of(context).iconTheme.color!,
//                             ),
//                           ),
//                         ),
//                       playing ? IconButton(onPressed: ()=>handler.pause(), icon: const Icon(Icons.pause_rounded,),)
//                           : IconButton(onPressed: ()=>handler.play(), icon: const Icon(Icons.play_arrow_rounded),
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ],
//           );
//         },),
//     );
//   }
// }
