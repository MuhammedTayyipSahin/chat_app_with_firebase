

import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/pages/my_custom_buttom_navi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}): super(key: key);

  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    
  }

  TabItem _currentTab = TabItem.users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorMap = {
    TabItem.profile : GlobalKey<NavigatorState>(), 
    TabItem.myChatting : GlobalKey<NavigatorState>(), 
    TabItem.users : GlobalKey<NavigatorState>(), 
  };
  

   @override
  Widget build(BuildContext context) {

    return  WillPopScope(
      onWillPop: () async {
        return !await navigatorMap[_currentTab]!.currentState!.maybePop();
      },
      child: MyCustomButtomNavigator(
          navigatorMap: navigatorMap,
          currentTab: _currentTab, 
          onSelectedTab: (selectedTab){
            if(selectedTab == _currentTab){
              navigatorMap[selectedTab]!.currentState!.popUntil((route) => route.isFirst);
            }else{
            setState(() {
              _currentTab = selectedTab;
            });

            }

          }
      ),
    );
  }
}



/* 
  TextButton(onPressed: ()async{
            showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),),);
            await ref.read(userProvider.notifier).signOut();
            Navigator.pop(context);
          }, child: const Text("Çıkış Yap", style: TextStyle(color: Colors.white),)) */