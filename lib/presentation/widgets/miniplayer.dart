import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:joel_osteen_sermons/audio/audio_hander.dart';
import 'package:joel_osteen_sermons/audio/queue_state.dart';
import 'package:joel_osteen_sermons/presentation/screens/now_playing_screen.dart';
import 'package:marquee/marquee.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  static final audioHandler = GetIt.I<AudioPlayerHandler>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder<QueueState>(
      stream: audioHandler.queueState,
      builder: (context, queueSnapshot) {
        if (queueSnapshot.connectionState != ConnectionState.active) {
          return const SizedBox.shrink();
        }
        if(!queueSnapshot.hasData){
          return const SizedBox.shrink();
        }
        final queueState = queueSnapshot.data;
        final queue = queueState!.queue;
        if(queue.length<2){
          return const SizedBox.shrink();
        }
        return StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (_, mediaSnapshot) {
            if(!mediaSnapshot.hasData){
              return const SizedBox.shrink();
            }
            final mediaItem = mediaSnapshot.data;
            return Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Theme.of(context).dividerColor,width: 0.5)),
                gradient: LinearGradient(
                  colors: [
                    isDark?Colors.white12:Theme.of(context).primaryColor.withOpacity(0.1),
                    isDark?Colors.black12:Colors.white12,
                    isDark?Colors.black:Colors.white,
                  ],begin: Alignment.topCenter,end: Alignment.bottomCenter,stops: const [0.1,0.5,0.7]
                )
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListTile(
                      dense: true,
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          elevation: 3,
                          margin: EdgeInsets.zero,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset("assets/images/joel_osteen.jpg")),
                        ),
                      ),
                      title: SizedBox(height: 18,
                        child: Marquee(
                          text: mediaItem?.title??'',
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          pauseAfterRound: const Duration(seconds: 2),
                          accelerationDuration: const Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: const Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                      subtitle: Text(mediaItem?.artist??''),
                      trailing: StreamBuilder<PlaybackState>(
                          stream: audioHandler.playbackState,
                          builder: (_, snapshot) {
                            final playbackState = snapshot.data;
                            final processingState = playbackState?.processingState;
                            final playing = playbackState?.playing ?? false;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: ()=>queueState.hasPrevious?audioHandler.skipToPrevious():null,
                                    padding:EdgeInsets.zero,
                                    icon: const Icon(Icons.skip_previous)),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if(processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering)
                                      CircularProgressIndicator(strokeWidth: 2,color: Theme.of(context).textTheme.caption!.color),
                                    IconButton(
                                        onPressed: ()=>playing?audioHandler.pause():audioHandler.play(),
                                        padding:EdgeInsets.zero,
                                        iconSize:35,
                                        icon: Icon(playing?Icons.pause_circle_filled:Icons.play_circle_filled)),
                                  ],
                                ),
                                IconButton(onPressed: ()=>queueState.hasNext?audioHandler.skipToNext():null,
                                    padding:EdgeInsets.zero,
                                    icon: const Icon(Icons.skip_next)),
                              ],
                            );
                          }
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>const NowPlayingScreen()));
                      },
                    ),
                  ),
                  StreamBuilder<Duration>(
                      stream: AudioService.position,
                      builder: (_,durationSnapshot){
                        final position = durationSnapshot.data;
                        if(position==null) {
                          return const SizedBox.shrink();
                        }
                        if(position.inSeconds.toDouble()<0.0){
                          return const SizedBox.shrink();
                        }
                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.green[500],
                              inactiveTrackColor: Colors.transparent,
                              trackHeight: 0.7,
                              thumbColor: Theme.of(context).colorScheme.secondary,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 1.0),
                              overlayColor: Colors.transparent,
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 2.0)),
                          child: Slider(
                            inactiveColor: Colors.transparent,
                            value: position.inSeconds.toDouble(),
                            max: mediaItem!.duration!.inSeconds.toDouble(),
                            onChanged: (newPosition) {
                              audioHandler.seek(Duration(seconds: newPosition.round()),
                              );
                            },
                          ),
                        );
                      }),

                ],
              ),
            );
          }
        );
      }
    );
  }
}
