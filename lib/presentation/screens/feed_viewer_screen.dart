import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:joel_osteen_sermons/audio/audio_hander.dart';
import 'package:joel_osteen_sermons/audio/queue_state.dart';
import 'package:joel_osteen_sermons/presentation/widgets/miniplayer.dart';
import 'package:lottie/lottie.dart';
import 'package:webfeed/domain/rss_feed.dart';

class FeedViewerScreen extends ConsumerStatefulWidget {
  final RssFeed rssFeed;
  const FeedViewerScreen({Key? key, required this.rssFeed}) : super(key: key);

  @override
  ConsumerState createState() => _FeedViewerScreenState();
}

class _FeedViewerScreenState extends ConsumerState<FeedViewerScreen> {

  final audioHandler = GetIt.instance<AudioPlayerHandler>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final mediaList = widget.rssFeed.items?.map((e) => MediaItem(
        id: e.enclosure?.url??'',
        artist: e.itunes?.author??'',
        album: e.itunes?.subtitle??'',
        genre: e.description??'',
        duration: e.itunes?.duration??Duration.zero,
        artUri: Uri.parse(widget.rssFeed.image?.url??''),
        extras: {
          'date': e.pubDate.toString()
        },
        title: e.title??'',)).toList()??[];
      audioHandler.updateQueue(mediaList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QueueState>(
            stream: audioHandler.queueState,
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return const Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.hasError){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Something went wrong.\nAre you connected to internet?",style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).textTheme.caption!.color),)),
                );
              }
              if(snapshot.hasData){
                if(snapshot.data!.queue.length<2){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Something went wrong.\nAre you connected to internet?",style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).textTheme.caption!.color),)),
                  );
                }
                final queueState = snapshot.data;
                final List<MediaItem> queue = queueState?.queue??[];
                return ListView.builder(
                    itemCount:queue.length,
                    itemBuilder: (ctx,index){
                      final item = queue[index];
                      final date = item.extras?["date"]??'';
                      final formattedDateMonth = DateFormat.MMMd().format(DateTime.parse(date));
                      final formattedDate = DateFormat.yMMMEd().format(DateTime.parse(date));
                      return StreamBuilder<PlaybackState>(
                        stream: audioHandler.playbackState,
                        builder: (context, snap) {
                          final playbackState = snap.data;
                          final playing = playbackState?.playing ?? false;
                          final bool buffering = playbackState?.processingState==AudioProcessingState.loading || playbackState?.processingState == AudioProcessingState.buffering;

                          return Card(
                            elevation: 3,
                            shadowColor: Colors.black12,
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            child: ListTile(
                              selectedTileColor: Colors.black.withOpacity(0.03),
                              selected: playbackState?.queueIndex==index?true:false,
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset("assets/images/joel_osteen.jpg",width: 50,height: 50)),
                              title: Text(item.title,style: TextStyle(fontWeight: FontWeight.w600,color: playbackState?.queueIndex==index?Theme.of(context).colorScheme.secondary:null),),
                              subtitle: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 3),
                                    child: Text(item.album??'',maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(color: playbackState?.queueIndex==index?Theme.of(context).colorScheme.secondary.withOpacity(0.7):null),),
                                  ),
                                  if(playbackState?.queueIndex!=index)Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(formattedDate, style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 10,color: isDark?Colors.grey[500]:Theme.of(context).colorScheme.secondaryVariant.withOpacity(0.8)))),
                                ],
                              ),
                              onTap: (){
                                if(playbackState?.queueIndex!=index){
                                  audioHandler.skipToQueueItem(index);
                                  if(!playing){
                                    audioHandler.play();
                                  }
                                }else{
                                  if(!playing&&!buffering){
                                    audioHandler.play();
                                  }
                                }
                              },
                              trailing: playbackState?.queueIndex==index
                                  ? (buffering?Lottie.asset("assets/json/loading_dots_blue.json",height: 70,width: 70):Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  playing?Lottie.asset('assets/json/audio_playing_small.json', height: 30,width: 30):const Icon(Icons.play_circle_filled,size: 30,),
                                  const SizedBox(height: 9),
                                  Text(formattedDateMonth,style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 10,color: Theme.of(context).primaryColor))
                                ],
                              ))
                                  :null,
                            ),
                          );
                        }
                      );
                    }, );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        const MiniPlayer()
      ],
    );
  }
}
