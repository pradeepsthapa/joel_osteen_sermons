import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:joel_osteen_sermons/data/constants.dart';
import 'providers.dart';

class StorageProvider extends ChangeNotifier{
  final Reader _reader;
  StorageProvider(this._reader);

  final getStorage = GetIt.instance<GetStorage>();

  bool _isDark = false;
  bool get isDark => _isDark;

  void changeDarkTheme(bool value){
    getStorage.write(Constants.darkMode, value);
    _isDark = value;
    notifyListeners();

  }

  void saveFontSize(double size){
    getStorage.write(Constants.fontSize, size);
  }

  // void saveBackground(int color){
  //   getStorage.write(Constants.backgroundColor, color);
  //   _reader(appColorProvider.notifier).state = color;
  // }

  void saveFontStyle(int index){
    getStorage.write(Constants.fontIndex, index);
    _reader(globalFontProvider.notifier).state = index;
  }

  void saveAlwaysShowCommentary(bool value){
    // getStorage.write(Constants.s, index);
    _reader(alwaysShowCommentaryProvider.state).state = value;
  }


  void initStorage(){
    getStorage.writeIfNull(Constants.darkMode, false);
    getStorage.writeIfNull(Constants.fontSize, 17.0);
    // getStorage.writeIfNull(Constants.backgroundColor, 0);
    getStorage.writeIfNull(Constants.fontIndex, 0);
    getStorage.writeIfNull(Constants.recentPlaylist, []);
    initialDarkMode();
  }

  void initialDarkMode(){
    _isDark = getStorage.read(Constants.darkMode);
    notifyListeners();
  }

  void loadInitials() {
    _reader(fontSizeProvider.notifier).state =  getStorage.read(Constants.fontSize);
    // _reader(appColorProvider.notifier).state =  getStorage.read(Constants.backgroundColor);
    _reader(globalFontProvider.notifier).state =  getStorage.read(Constants.fontIndex);
  }
}