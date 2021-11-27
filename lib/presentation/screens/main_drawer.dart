import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joel_osteen_sermons/presentation/screens/youtube_screen.dart';

import 'settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/drawer_blue.jpg'),fit: BoxFit.cover)
            ),
              currentAccountPicture: const CircleAvatar(backgroundImage: AssetImage('assets/images/joel_osteen.jpg'),),
              accountName: Text("Joel Osteen Sermons",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),),
              accountEmail: Text("pradeepsthapa@gmail.com",style: TextStyle(color: Colors.grey[500],fontSize: 10),),),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text("Videos"),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const YouTubeHome()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const SettingsScreen()));
              },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Exit"),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=>SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
