import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/pages/chat_history_page.dart';
import 'package:flutter_lovers_orgin/pages/profile_page.dart';
import 'package:flutter_lovers_orgin/pages/users_page.dart';



class MyCustomButtomNavigator extends StatelessWidget {

  const MyCustomButtomNavigator({super.key, required this.currentTab, required this.onSelectedTab, required this.navigatorMap});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorMap;

  Widget selectPage(TabItem tabItem){
    switch (tabItem) {
      case TabItem.profile: return const ProfilePage();
      case TabItem.myChatting : return const ChatPage();
      case TabItem.users : return const UsersPage();
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          navItemCreator(TabItem.users),
          navItemCreator(TabItem.myChatting),
          navItemCreator(TabItem.profile),
        ],
        onTap: (value) => onSelectedTab(TabItem.values[value]),
      ), tabBuilder: (BuildContext context, int index) {

        return CupertinoTabView(
          navigatorKey: navigatorMap[TabItem.values[index]],
          builder: (context) {
            return selectPage(TabItem.values[index]);
          },
        );
      },
    );
  }

BottomNavigationBarItem navItemCreator(TabItem tabItem){
  var tabItemData = TabItemData.allTabs[tabItem]; 
  return BottomNavigationBarItem(
    icon: Icon(tabItemData!.iconData),
    label: tabItemData.title
    
    );
}


}

enum TabItem{users,myChatting, profile}

class TabItemData{
  final String title;
  final IconData iconData;

  const TabItemData({required this.iconData, required this.title});

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.users : const TabItemData(iconData: Icons.supervised_user_circle, title: "Kullanıcalar"),
    TabItem.profile : const TabItemData(iconData: Icons.person, title: "Profil"),
    TabItem.myChatting: const TabItemData(iconData: Icons.chat, title: "Profil"),
  };

}
