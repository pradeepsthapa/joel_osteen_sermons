import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:http/http.dart' as http;

abstract class FeedState{
  const FeedState();
}

class FeedLoaded extends FeedState{
  final RssFeed feed;
  const FeedLoaded({required this.feed});
}

class FeedLoading extends FeedState{
  const FeedLoading();
}

class FeedError extends FeedState{
  final String message;
  const FeedError({required this.message});
}


class FeedStateProvider extends StateNotifier<FeedState> {
  final String feedUrl;
  FeedStateProvider({required this.feedUrl}) : super(const FeedLoading());

  Future<void> getFeed() async {
    try {
      final response = await http.read(Uri.parse(feedUrl));
      if (response.isNotEmpty) {
        state =  FeedLoaded(feed: RssFeed.parse(response));
      }
    } on SocketException catch (e) {
      state = FeedError(message: e.message);
    }on Exception catch (e) {
      state = const FeedError(message: "Something went wrong");
    }
  }
}