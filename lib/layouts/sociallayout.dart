import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/modules/searchScreen.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';

class SocialLayout extends StatefulWidget {
  int initialIndex = 0;
  SocialLayout(this.initialIndex);

  @override
  SocialLayoutState createState() => SocialLayoutState();
}
 class SocialLayoutState extends State<SocialLayout> with SingleTickerProviderStateMixin {
  static late TabController tabController;
  static ScrollController scrollController = ScrollController();
  late int initialIndex;

  @override
  void initState() {
    initialIndex = widget.initialIndex;
    tabController = TabController(
        length: SocialCubit.get(context).tabBar.length, vsync: this);
    tabController.index = initialIndex;
    tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: tabController.index == 0?
            AppBar(
                      title: Text('News Feeds',),
                      automaticallyImplyLeading: false,
                      elevation: 8,
                      actions: [
                        IconButton(
                            onPressed: () {
                              navigateTo(context, SearchScreen());
                            },
                            icon: Icon(Icons.search)),
                      ],
              bottom: TabBar(
                controller: tabController,
                labelColor: Colors.blueAccent,
                tabs: SocialCubit.get(context).tabBar,
                onTap: (index) {
                  SocialCubit.get(context).changeBottomNav(index);
                },
                labelStyle: TextStyle(fontSize: 20),
                indicatorColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey,
              ),
                    ) :
            AppBar(
              automaticallyImplyLeading: false,
              elevation: 8,
              title: TabBar(
                controller: tabController,
                labelColor: Colors.blueAccent,
                tabs: SocialCubit.get(context).tabBar,
                onTap: (index) {
                  SocialCubit.get(context).changeBottomNav(index);
                },
                labelStyle: TextStyle(fontSize: 20),
                indicatorColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey,
              ),
            ) ,
            body: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: tabController,
              children: SocialCubit.get(context).screens
            ),

            );
        });
  }
}
