import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:joel_osteen_sermons/presentation/screens/audio_screen.dart';
import 'audio/audio_hander.dart';
import 'data/constants.dart';
import 'logics/providers.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await startService();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> startService() async {
  await GetStorage.init();
  final box = GetStorage();
  GetIt.instance.registerSingleton<GetStorage>(box);
  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ccbc.joel_osteen_sermons',
      androidNotificationChannelName: 'Joel Osteen Sermons',
      androidNotificationOngoing: true,
      // androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidShowNotificationBadge: true,
    ),
  );
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final font = ref.watch(globalFontProvider);
    return MaterialApp(
      title: 'Joel Osteen Sermons',
      themeMode: ref.watch(boxStorageProvider).isDark?ThemeMode.dark:ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
          primaryTextTheme: Constants.globalFonts[font].textTheme.copyWith(
            headline6: TextStyle(
                color: Colors.white,
                fontFamily: Constants.globalFonts[font].fontFamily),
            bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: Constants.globalFonts[font].fontFamily),
          ),
          textTheme: Constants.globalFonts[font].textTheme.copyWith(
            overline: TextStyle(
                color: Colors.white,
                fontFamily: Constants.globalFonts[font].fontFamily),
            bodyText2: TextStyle(
                color: Colors.white,
                fontFamily: Constants.globalFonts[font].fontFamily),
            bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: Constants.globalFonts[font].fontFamily),
            subtitle1: TextStyle(
                color: Colors.white,
                fontFamily: Constants.globalFonts[font].fontFamily),
            caption: TextStyle(
              color: Colors.white70,
              fontFamily: Constants.globalFonts[font].fontFamily,
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled),
          })),
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue.shade900,
          useMaterial3: true,
          fontFamily: Constants.globalFonts[font].fontFamily,
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18),
              color: Colors.blue.shade900),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled),
          }),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boxStorageProvider).loadInitials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        ref.read(interstitialAdProvider).showExitAd();
        return false;
      },
      child: const Material(
        child: AudioScreen(),
      ),
    );
  }
}
