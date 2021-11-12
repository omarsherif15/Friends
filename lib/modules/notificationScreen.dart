import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/notificationModel.dart';
import 'package:socialapp/modules/SinglePostScreen.dart';
import 'package:socialapp/modules/friendsProfileScreen.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var modalKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getInAppNotification();
        SocialCubit.get(context).getUnReadRecentMessagesCount();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            List<NotificationModel> notifications =
                SocialCubit.get(context).notifications;
            return WillPopScope(
                onWillPop: willPopCallback,
                child: Scaffold(
                  key: scaffoldKey,
                  backgroundColor:
                      SocialCubit.get(context).backgroundColor.withOpacity(1),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          LocaleKeys.Notifications.tr(),
                          style: TextStyle(
                              color: SocialCubit.get(context).textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              notifications.length > 0,
                          widgetBuilder: (context) => Expanded(
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      notificationsBuilder(
                                          context, notifications[index]),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 0,
                                  ),
                                  itemCount: notifications.length,
                                ),
                              ),
                          fallbackBuilder: (context) => Expanded(
                                child: Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height -
                                        200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.notifications,
                                          color: Colors.grey,
                                          size: 60,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'No Notifications',
                                          style: TextStyle(
                                              color: SocialCubit.get(context)
                                                  .textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  Widget notificationsBuilder(context, NotificationModel notifications) {
    return InkWell(
      onTap: () {
        if (notifications.contentKey == 'friendRequestAccepted') {
          SocialCubit.get(context).readNotification(notifications.notificationId);
          navigateTo(context, FriendsProfileScreen(notifications.contentId));
        }
        else if (notifications.contentKey == 'likePost' || notifications.contentKey == 'commentPost'  ) {
          SocialCubit.get(context)
              .readNotification(notifications.notificationId);
          navigateTo(
              context, SinglePostScreen(postId: notifications.contentId));
        }
        else if (notifications.contentKey == 'friendRequest') {
          SocialCubit.get(context)
              .readNotification(notifications.notificationId);
          SocialLayoutState.tabController.animateTo(1,duration: Duration(seconds: 2),curve: Curves.fastLinearToSlowEaseIn);
        }

      },
      child: Container(
        color: notifications.read
            ? SocialCubit.get(context).backgroundColor.withOpacity(1)
            : SocialCubit.get(context).unreadMessage,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage('${notifications.senderProfilePicture}'),
                    radius: 34,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent.shade200,
                    radius: 15,
                    child: Icon(SocialCubit.get(context).notificationContentIcon(notifications.contentKey)),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                            text: '${notifications.senderName} ',
                            style: TextStyle(
                                color: SocialCubit.get(context).textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: SocialCubit.get(context).notificationContent(notifications.contentKey),
                            style: TextStyle(
                                color: SocialCubit.get(context).textColor,
                                fontSize: 15))
                      ]),
                    ),
                    Text(
                      getNowDateTime(notifications.dateTime),
                      style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    scaffoldKey.currentState!.showBodyScrim(true, 0.5);
                    scaffoldKey.currentState!.
                    showBottomSheet((context) => Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),borderSide: BorderSide.none),
                            elevation: 15,
                            color: SocialCubit.get(context)
                                .backgroundColor
                                .withOpacity(1),
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.drag_handle),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        '${notifications.senderProfilePicture}'),
                                    radius: 25,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('${notifications.senderName} ' +
                                      '${SocialCubit.get(context).notificationContent(notifications.contentKey)}',
                                    textAlign: TextAlign.center,style: TextStyle(color: SocialCubit.get(context).textColor),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Scaffold.of(context).currentBottomSheet!.close();
                                      SocialCubit.get(context).deleteNotification(notifications.notificationId);
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child:
                                              Icon(Icons.delete_outline_outlined),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Remove this notification',
                                          style: TextStyle(
                                              color: SocialCubit.get(context)
                                                  .textColor,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15)),borderSide: BorderSide.none),
                        ).closed.then((value) {
                      scaffoldKey.currentState!.showBodyScrim(false, 1);
                    });
                  },
                  icon: Icon(Icons.more_horiz_outlined))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> willPopCallback() async {
    SocialLayoutState.tabController.animateTo(0,
        duration: Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
    return false;
  }
}
