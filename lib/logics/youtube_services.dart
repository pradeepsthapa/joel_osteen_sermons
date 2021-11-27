import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTServices{

  static final YoutubeExplode _yt = YoutubeExplode();
  static const _playListUrl = "https://www.youtube.com/watch?v=IXwGUWg4IAM&list=UUvxWyn4rfcI2H9APhfUIB1Q&ab_channel=JoelOsteen";

  static Future<List<Video>> getPlaylistSongs() async {
    final List<Video> results = await _yt.playlists.getVideos(_playListUrl).take(100).toList();
    return results;
  }

  static Future<Playlist> getPlaylistDetails() async {
    final Playlist metadata = await _yt.playlists.get(_playListUrl);
    return metadata;
  }
}
