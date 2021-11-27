import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:joel_osteen_sermons/audio/audio_hander.dart';
import 'package:joel_osteen_sermons/audio/media_state.dart';
import 'package:joel_osteen_sermons/audio/queue_state.dart';
import 'package:joel_osteen_sermons/audio/queue_stream_provider.dart';
import 'package:joel_osteen_sermons/presentation/widgets/seekbar.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({Key? key}) : super(key: key);

  static final audioHandler = GetIt.I<AudioPlayerHandler>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(Icons.expand_more,color: isDark?Colors.white:Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Now Playing",
          style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.bold,color: isDark?Colors.white:Theme.of(context).primaryColor),),
      ),
      body: StreamBuilder<QueueState>(
        stream: audioHandler.queueState,
        builder: (context, queueSnapshot) {
          if (queueSnapshot.connectionState != ConnectionState.active) {
            return const SizedBox.shrink();
          }
          if(!queueSnapshot.hasData){
            return const SizedBox.shrink();
          }
          final queueState = queueSnapshot.data!;
          return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, snapshot){
              final playbackState = snapshot.data;
              final processingState = playbackState?.processingState;
              if(processingState==AudioProcessingState.idle){
                return const Center(child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Audio Service not running"),
                ),);
              }
              return StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (_,mediaSnapshot){
                    if(!mediaSnapshot.hasData){
                      return const SizedBox.shrink();
                    }
                    final mediaItem = mediaSnapshot.data;
                    final date = mediaItem?.extras?["date"];
                    final formattedDate = DateFormat.yMMMEd().format(DateTime.parse(date));
                    return Column(
                      children: [
                        Flexible(
                          flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset("assets/images/joel_osteen.jpg",fit: BoxFit.cover,width: MediaQuery.of(context).size.width *.8,)),
                            )),
                        Flexible(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 12),
                                  child: Text(mediaItem?.title??'',style: Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text(formattedDate,style: TextStyle(color: Theme.of(context).colorScheme.secondaryVariant.withOpacity(0.7),fontWeight: FontWeight.w600,fontSize: 11)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 7),
                                  child: Text(mediaItem?.genre??'',style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(flex: 1,
                        child: StreamBuilder<PositionData>(
                          stream: customPositionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data ?? PositionData(Duration.zero, Duration.zero, mediaItem?.duration ?? Duration.zero);

                            return SeekBar(
                              position: positionData.position,
                              duration: positionData.duration,
                              bufferedPosition: positionData.bufferedPosition,
                              onChangeEnd: (newPosition){
                                audioHandler.seek(newPosition);
                              },
                            );
                          }
                        ),),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: StreamBuilder<PlaybackState>(
                                stream: audioHandler.playbackState,
                                builder: (_,snapshot){
                                  final playbackState = snapshot.data;
                                  final processingState = playbackState?.processingState;
                                  final playing = playbackState?.playing ?? false;
                                  if (processingState == AudioProcessingState.idle) {
                                    return const SizedBox.shrink();
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      StreamBuilder<AudioServiceRepeatMode>(
                                        stream: audioHandler.playbackState.map((event) => event.repeatMode).distinct(),
                                        builder: (_, repeatSnapshot) {
                                          const texts = ['None', 'All', 'One'];
                                          final repeatMode = repeatSnapshot.data ?? AudioServiceRepeatMode.none;
                                          final icons = [Icon(Icons.repeat_rounded, color: Theme.of(context).disabledColor), const Icon(Icons.repeat_rounded), const Icon(Icons.repeat_one_rounded)];
                                          const cycleModes = [AudioServiceRepeatMode.none, AudioServiceRepeatMode.all, AudioServiceRepeatMode.one];
                                          final cycleIndex = cycleModes.indexOf(repeatMode);
                                          return IconButton(
                                              padding:EdgeInsets.zero,
                                              iconSize:30,
                                              tooltip: 'Repeat ${texts[(cycleIndex + 1) % texts.length]}',
                                              onPressed: (){
                                                audioHandler.setRepeatMode(cycleModes[
                                                  (cycleModes.indexOf(repeatMode) + 1) % cycleModes.length],
                                                );
                                              },
                                              icon: icons[cycleIndex]);
                                        }
                                      ),
                                      IconButton(
                                          padding:EdgeInsets.zero,
                                          iconSize:45,
                                          onPressed: ()=>queueState.hasPrevious?audioHandler.skipToPrevious():null,
                                          icon: const Icon(Icons.skip_previous)),
                                      Stack(
                                        children: [
                                          if(processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering)
                                            Positioned(
                                                bottom:0,left:0,right:0,top:0,
                                                child: SizedBox(
                                                    height:50,width:60,
                                                    child: CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        color: isDark?Colors.white:Colors.black),),),
                                          IconButton(
                                            iconSize:60,
                                              padding:EdgeInsets.zero,
                                              onPressed: ()=>playing?audioHandler.pause():audioHandler.play(),
                                              icon: Icon(playing?Icons.pause_circle_filled:Icons.play_circle_filled)),
                                        ],
                                      ),
                                      IconButton(
                                          iconSize:45,
                                          padding:EdgeInsets.zero,
                                          onPressed: ()=>queueState.hasNext?audioHandler.skipToNext():null,
                                          icon: const Icon(Icons.skip_next)),
                                      IconButton(
                                          padding:EdgeInsets.zero,
                                          iconSize:30,
                                          onPressed: (){},
                                          icon: Icon(Icons.file_download,color: Theme.of(context).disabledColor),),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ],
                    );
                  });
            },
          );
        }
      ),
    );
  }
}
