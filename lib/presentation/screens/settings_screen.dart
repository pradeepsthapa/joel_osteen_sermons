import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joel_osteen_sermons/data/constants.dart';
import 'package:joel_osteen_sermons/data/font_model.dart';
import 'package:joel_osteen_sermons/logics/providers.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: isDark?Colors.white:Theme.of(context).primaryColor),
          elevation: 0,
          // shadowColor: Colors.black26,
          // backgroundColor: isDark?Colors.black:Theme.of(context).primaryColor.withOpacity(0.5),
          title: const Text("Settings",
            // style: TextStyle(color: isDark?Colors.white:Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildTitle("App Settings",context),
          Consumer(
            builder: (context, ref, child) {
              return SwitchListTile(
                  dense: true,
                  title: const Text("Dark Mode"),
                  value: Theme.of(context).brightness==Brightness.dark,
                  onChanged: (value){
                    ref.read(boxStorageProvider).changeDarkTheme(value);
                  });
            },
          ),
          // Consumer(
          //   builder: (context, ref, child) {
          //     return ListTile(
          //       dense: true,
          //       title: const Text("Color"),
          //       subtitle: const Text("Default background color"),
          //       trailing: DropdownButton<MaterialColor>(
          //         hint: Container(
          //           height: 30,width: 50,
          //           decoration: BoxDecoration(
          //             color: Colors.primaries[ref.watch(appColorProvider.state).state],
          //             borderRadius: BorderRadius.circular(3),
          //           ),
          //         ),
          //         underline: const SizedBox.shrink(),
          //         onChanged: (color){
          //           final int index = Colors.primaries.indexOf(color!);
          //           ref.read(boxStorageProvider).saveBackground(index);
          //         },
          //         items: Colors.primaries.map((e) {
          //           return DropdownMenuItem(
          //             value: e,
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(3),
          //                 border: ref.watch(appColorProvider.state).state==Colors.primaries.indexOf(e)?Border.all(width: 1.5):null,
          //               ),
          //               height: 30,width: 50,
          //               child: Container(
          //                 margin: const EdgeInsets.all(1),
          //                 decoration: BoxDecoration(
          //                   color: e,
          //                   borderRadius: BorderRadius.circular(3),
          //                 ),
          //               ),
          //             ),
          //           );
          //         }).toList(),),
          //     );
          //   },
          // ),
          // Consumer(
          //   builder: (context, ref, child) {
          //     return CheckboxListTile(
          //         dense: true,
          //         title: const Text("Always Show Commentary"),
          //         subtitle: const Text("Toggle on or off commentary option"),
          //         value: ref.watch(alwaysShowCommentaryProvider),
          //         onChanged: (value){
          //           ref.watch(boxStorageProvider).saveAlwaysShowCommentary(value??false);
          //         });
          //   },
          // ),

          _buildTitle("Font Settings",context),
          // Container(
          //   color: Theme.of(context).colorScheme.secondaryVariant.withOpacity(0.05),
          //   child: Column(
          //     children: [
          //       const ListTile(
          //         title: Text("Font Size"),
          //         subtitle: FontSliderWidget(),
          //       ),
          //       Consumer(
          //         builder: (context, ref, child) {
          //           return Center(
          //             child: Padding(
          //               padding: const EdgeInsets.only(bottom: 7),
          //               child: Text("This is the default text size.",
          //                 style: TextStyle(fontSize: ref.watch(fontSizeProvider)),),
          //             ),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // ),

          Consumer(builder: (context, ref, child) {
            return ListTile(
              title: const Text("Primary Font"),
              subtitle: Text(Constants.globalFonts[ref.watch(globalFontProvider.notifier).state].fontName??''),
              onTap: (){
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                  pageBuilder: (context, anim1, anim2) {
                    return AlertDialog(
                      actions: [
                        TextButton(
                            onPressed: ()=>Navigator.pop(context),
                            child: const Text("Cancel")),
                      ],
                      contentPadding: EdgeInsets.zero,
                      scrollable: true,
                      title: const Text("Primary Font"),
                      content: SingleChildScrollView(
                        child: Consumer(
                            builder: (context,ref, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: Constants.globalFonts.map((e) => RadioListTile<GlobalFontModel>(
                                  dense: true,
                                  title: Text(e.fontName??''),
                                  groupValue: Constants.globalFonts[ref.watch(globalFontProvider)],
                                  value: e,
                                  onChanged: (value){
                                    final fontIndex = Constants.globalFonts.indexOf(value!);
                                    ref.read(boxStorageProvider).saveFontStyle(fontIndex);
                                    Navigator.pop(context);
                                  },
                                )).toList(),
                              );
                            }
                        ),
                      ),
                    );
                  },);
              },
            );
          },),
          _buildTitle("Miscellaneous",context),
          ListTile(
            dense: true,
            title: const Text("Share"),
            subtitle: const Text("Share this app with friends"),
            onTap: ()async{
              const String text = 'https://play.google.com/store/apps/details?id=com.ccbc.joel_osteen_sermons';
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              Share.share(text,sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
            },
          ),
          ListTile(
            dense: true,
            title: const Text("More Apps"),
            subtitle: const Text("Explore more similar Bible apps"),
            onTap: ()async{
              const url = 'https://play.google.com/store/apps/developer?id=pTech';
              if(await canLaunch(url)){
                await launch(url);
              }
              else{
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            dense: true,
            title: const Text("Privacy Policy"),
            onTap: ()async{
              const url = 'https://thechristianposts.com/joel-osteen-sermons/';
              if(await canLaunch(url)){
                await launch(url);
              }
              else{
                throw 'Could not launch $url';
              }
            },
          ),
        ],
      ),
    );
  }
}


Widget _buildTitle(String title, BuildContext context){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
    child: Text(title,style: TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 17,
    ),
    ),
  );
}