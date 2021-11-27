import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joel_osteen_sermons/logics/providers.dart';
import 'package:joel_osteen_sermons/presentation/screens/settings_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeHome extends ConsumerWidget {
  const YouTubeHome({Key? key}) : super(key: key);

  @override
  Widget build(context,ref) {
    final state = ref.watch(youtubePlaylistProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: isDark?Colors.black:Colors.purple[700],
          centerTitle: true,
          title: const Text("Videos"),
          actions: [
            IconButton(icon: const Icon(Icons.settings),
              padding: EdgeInsets.zero,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>const SettingsScreen()));
              },),
          ],
        ),
      ),
      body: state.when(
          data: (data){
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index){
                  final video = data[index];
                  return InkWell(
                    onTap: ()async{
                      if(await canLaunch(video.url)){
                      await launch(video.url);
                      }
                      else{
                      throw 'Could not launch ${video.url}';
                      }
                    },
                    child: Card(
                      elevation: 7,
                      shadowColor: Colors.black12,
                      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          CachedNetworkImage(
                            imageUrl: video.thumbnails.standardResUrl,
                            placeholder: (context, url) => Lottie.asset("assets/json/image_loading.json",width: size.width,fit: BoxFit.cover),
                            errorWidget: (_,url,error)=>Lottie.asset("assets/json/image_loading.json",width: size.width,fit: BoxFit.cover),
                          ),
                          // Image.network(video.thumbnails.standardResUrl,height: 220,width: size.width,fit: BoxFit.cover),
                          ListTile(
                            title: Text(video.title,style: const TextStyle(fontWeight: FontWeight.bold),maxLines: 3,overflow: TextOverflow.ellipsis,),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(video.author,),
                                Text(video.duration.toString().split('.')[0].replaceFirst('0.0', ''),),
                              ],
                            ),
                            onTap: (){
                              print(video.duration.toString());
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          error: (error,st)=>Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Something went wrong",style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).textTheme.caption!.color),),
          )),
          loading: ()=>Center(child: Lottie.asset("assets/json/loading_dots_blue.json"))),
    );
  }
}
