import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joel_osteen_sermons/data/constants.dart';
import 'package:joel_osteen_sermons/logics/feed_state_controller.dart';
import 'package:joel_osteen_sermons/logics/providers.dart';
import 'package:joel_osteen_sermons/presentation/screens/youtube_screen.dart';
import 'package:joel_osteen_sermons/presentation/widgets/facebook_banner_widget.dart';
import 'package:lottie/lottie.dart';
import 'feed_viewer_screen.dart';
import 'main_drawer.dart';
import 'settings_screen.dart';

class AudioScreen extends ConsumerStatefulWidget {
  const AudioScreen({Key? key,}) : super(key: key);

  @override
  ConsumerState createState() => _AudioScreenState();
}

class _AudioScreenState extends ConsumerState<AudioScreen> {

  @override
  void initState() {
    ref.read(feedProvider(Constants.joelOsteenAudio).notifier).getFeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedProvider(Constants.joelOsteenAudio));
    if(state is FeedLoading){
      return Center(child: Lottie.asset('assets/json/loading_aeroplane.json'));
    }
    if(state is FeedLoaded){

      return Scaffold(
          drawer: const MainDrawer(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: const Text("Joel Osteen Sermons"),
              actions: [
                IconButton(icon: const Icon(Icons.videocam),
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const YouTubeHome()));
                  },),
              IconButton(icon: const Icon(Icons.tune),
                padding: EdgeInsets.zero,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const SettingsScreen()));
                },),

            ],
          ),
        ),
          body: FeedViewerScreen(rssFeed: state.feed),
        bottomNavigationBar: const FacebookBannerWidget(),
      );
    }
    if(state is FeedError){
      return Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/json/error.json"),
            Text("Something went wrong",style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).errorColor),),
            Text("Please connect to the internet and try again.",style: Theme.of(context).textTheme.caption,),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                minWidth: MediaQuery.of(context).size.width *.7,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                  onPressed: (){
                    ref.read(feedProvider(Constants.joelOsteenAudio).notifier).getFeed();
                  },
                child: Text("Retry",style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
              ),
            )
          ],
        ),
      ),);
    }
    return const SizedBox.shrink();
  }
}
