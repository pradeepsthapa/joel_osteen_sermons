import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'feed_state_controller.dart';
import 'storage_controller.dart';
import 'youtube_services.dart';

final feedProvider = StateNotifierProvider.family<FeedStateProvider,FeedState,String>((ref,url)=>FeedStateProvider(feedUrl: url));
final fontSizeProvider = StateProvider<double>((ref)=>17.0);
// final appColorProvider = StateProvider<int>((ref)=>0);
final globalFontProvider = StateProvider<int>((ref)=>0);
final boxStorageProvider = ChangeNotifierProvider<StorageProvider>((ref)=>StorageProvider(ref.read)..initStorage());

final alwaysShowCommentaryProvider = StateProvider<bool>((ref)=>true);

final youtubePlaylistProvider = FutureProvider<List<Video>>((ref)=>YTServices.getPlaylistSongs());