import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';


void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

void showToast(msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );}

Future navigateTo(BuildContext context,Widget widget) async {
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => widget, ));
}

Widget separator (double wide,double high){
  return SizedBox(width: wide,height: high,);
}

void pop (context) {
  Navigator.pop(context);
}

void navigateAndKill (context,widget) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget), (route) => false);
}

Widget myDivider() => Container(
  color: Colors.grey[300],
  height: 0.2,
  width: double.infinity,
);

double intToDouble(int num){
 double doubleNum = num.toDouble();
  return doubleNum;
}

// void sinceWhen(){
//   DateTime.now().compareTo()
// }

// void signOut (context) {
//   CacheHelper.removeData('token').then((value){
//     navigateAndKill(context, LoginScreen());
//     ShopCubit.get(context).currentIndex = 0;
//   });
// }

// bool isEdit = false;
// String editText = 'Edit';
// void editPressed({
//   required context,
//   required email,
//   required name,
//   required phone,
// })
// {
//   isEdit =! isEdit;
//   if(isEdit) {
//     editText = 'Save';
//     SocialCubit.get(context).emit(EditPressedState());
//   } else {
//     editText = 'Edit';
//     ShopCubit.get(context).updateProfileData(
//         email: email,
//         name: name,
//         phone: phone
//     );
//   }
//
// }
int messageId = 0;
int importId(){
  messageId++;
  return messageId;
}
String getDate ()
{
DateTime dateTime =  DateTime.now();
String date =  DateFormat.yMMMd().format(dateTime);
return date;
}
String getNowDateTime (Timestamp dateTime) {
  String date =DateFormat.yMd().format(dateTime.toDate()).toString();
  String time = DateFormat.Hm().format(dateTime.toDate()).toString();
  List<String> nowSeparated = [date,time];
  String nowJoined = nowSeparated.join(' at ');
  return nowJoined;
}
String time = DateTime.now().toString().split(' ').elementAt(1);

Color defaultColor  = Colors.blueAccent;

String? uId = '';


ThemeMode appMode = ThemeMode.light;

int cartLength = 0;

var scroll = ScrollController();

String sinceWhen(String dateTime){
  return GetTimeAgo.parse(DateTime.parse(dateTime));
}


Widget imagePreview(String? image){
  return FullScreenWidget(
    child: Center(
      child: Image.network(
        "$image",
        fit: BoxFit.cover,
        width: double.infinity,
        alignment: AlignmentDirectional.topCenter,
      ),
    ),
  );
}

// Card(
// clipBehavior: Clip.antiAliasWithSaveLayer,
// elevation: 8,
// margin: EdgeInsets.zero,
// color: SocialCubit.get(context).backgroundColor,
// child: Container(
// padding: EdgeInsets.symmetric(horizontal: 15),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SizedBox(
// height: 10,
// ),
// Row(
// children: [
// InkWell(
// onTap: () {
// if (singlePost.uId !=
// SocialCubit.get(context).model!.uID)
// navigateTo(
// context,
// FriendsProfileScreen(
// singlePost.uId));
// else
// navigateTo(context, SocialLayout(3));
// },
// child: CircleAvatar(
// radius: 22,
// backgroundImage: NetworkImage(
// '${singlePost.profilePicture}')),
// ),
// SizedBox(
// width: 15,
// ),
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// InkWell(
// onTap: () {
// if (singlePost.uId !=
// SocialCubit.get(context)
//     .model!
//     .uID)
// navigateTo(
// context,
// FriendsProfileScreen(
// singlePost.uId));
// else
// navigateTo(
// context, SocialLayout(3));
// },
// child: Text(
// '${singlePost.name}',
// style: TextStyle(
// color:
// SocialCubit.get(context)
// .textColor),
// )),
// SizedBox(
// height: 5,
// ),
// Text(
// '${singlePost.date} at ${singlePost.time}',
// style: TextStyle(color: Colors.grey),
// ),
// ],
// ),
// Spacer(),
// if (SocialCubit.get(context).model!.uID ==
// singlePost.uId)
// PopupMenuButton(
// color: SocialCubit.get(context)
// .backgroundColor
//     .withOpacity(1),
// onSelected: (value) {
// if (value == 'Delete post')
// SocialCubit.get(context)
//     .deletePost(singlePost.postId);
// else if (value == 'Edit post')
// navigateTo(
// context,
// NewPostScreen(
// isEdit: true,
// postId: singlePost.postId,
// postModel: singlePost,
// ));
// },
// child:
// Icon(Icons.more_horiz_outlined),
// itemBuilder: (context) => [
// PopupMenuItem(
// value: 'Delete post',
// child: Row(
// children: [
// Icon(
// Icons
//     .delete_outline_outlined,
// color: Colors.red,
// ),
// SizedBox(
// width: 5,
// ),
// Text(
// LocaleKeys.deletepost
//     .tr(),
// style: TextStyle(
// color: SocialCubit
//     .get(
// context)
// .textColor),
// )
// ],
// )), // delete post
// PopupMenuItem(
// value: 'Edit post',
// child: Row(
// children: [
// Icon(
// Icons.edit_outlined,
// color: Colors.grey,
// ),
// SizedBox(
// width: 5,
// ),
// Text(
// LocaleKeys.Editpost
//     .tr(),
// style: TextStyle(
// color: SocialCubit
//     .get(
// context)
// .textColor))
// ],
// )), // editPost
// ]),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// singlePost.postImage != null
// ? Text(
// '${singlePost.postText}',
// style: TextStyle(
// fontSize: 15,
// color: SocialCubit.get(context)
// .textColor),
// )
// : Text(
// '${singlePost.postText}',
// style: TextStyle(
// fontSize: 20,
// color: SocialCubit.get(context)
// .textColor),
// ),
// if (singlePost.postImage != null)
// Padding(
// padding: const EdgeInsetsDirectional.only(
// top: 10),
// child: imagePreview(singlePost.postImage)),
// Padding(
// padding: EdgeInsets.only(top: 10),
// child: Row(
// children: [
// if (singlePost.likes != 0)
// InkWell(
// onTap: () => navigateTo(context,
// WhoLikedScreen(singlePost.postId)),
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment.start,
// children: [
// Icon(
// IconBroken.Heart,
// color: Colors.red,
// ),
// SizedBox(
// width: 5,
// ),
// Text('${singlePost.likes}',
// style: TextStyle(
// color: SocialCubit.get(
// context)
// .textColor)),
// ],
// ),
// ),
// Spacer(),
// if (singlePost.comments != 0)
// InkWell(
// onTap: () {
// navigateTo(
// context,
// CommentsScreen(singlePost.likes,
// singlePost.postId));
// },
// child: Row(
// mainAxisSize: MainAxisSize.min,
// mainAxisAlignment:
// MainAxisAlignment.end,
// children: [
// Icon(
// IconBroken.Chat,
// color: Colors.amber,
// ),
// SizedBox(
// width: 5,
// ),
// Text(
// '${singlePost.comments} ' +
// LocaleKeys.comment.tr(),
// style: TextStyle(
// color: SocialCubit.get(
// context)
// .textColor)),
// ],
// ),
// ),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// vertical: 10.0),
// child: myDivider(),
// ),
// Row(
// children: [
// InkWell(
// onTap: () {
// navigateTo(
// context,
// CommentsScreen(singlePost.likes,
// singlePost.postId));
// },
// child: Row(
// children: [
// CircleAvatar(
// radius: 18,
// backgroundImage: NetworkImage(
// '${SocialCubit.get(context).model!.profilePic}')),
// SizedBox(
// width: 15,
// ),
// Text(
// LocaleKeys.write_comment.tr(),
// style:
// TextStyle(color: Colors.grey),
// ),
// ],
// ),
// ),
// Spacer(),
// InkWell(
// onTap: () {
// if (singlePost.likedByMe == false)
// SocialCubit.get(context)
//     .likePost(singlePost.postId);
// if (singlePost.likedByMe == true)
// SocialCubit.get(context)
//     .disLikePost(singlePost.postId);
// },
// child: Row(
// children: [
// Icon(IconBroken.Heart,
// color: singlePost.likedByMe
// ? Colors.red
//     : Colors.grey),
// SizedBox(
// width: 5,
// ),
// Text(LocaleKeys.Like.tr(),
// style: TextStyle(
// color:
// SocialCubit.get(context)
// .textColor)),
// ],
// ),
// ),
// SizedBox(
// width: 10,
// ),
// PopupMenuButton(
// color: SocialCubit.get(context)
// .backgroundColor
//     .withOpacity(1),
// onSelected: (value) {
// if (value == 'Share') {
// SocialCubit.get(context)
//     .createNewPost(
// name: SocialCubit.get(context)
//     .model!
//     .name,
// profileImage:
// SocialCubit.get(context)
//     .model!
//     .profilePic,
// postText: singlePost.postText,
// postImage:
// singlePost.postImage,
// date: getDate(),
// time: TimeOfDay.now()
//     .format(context)
//     .toString());
// }
// },
// itemBuilder: (context) => [
// PopupMenuItem(
// value: 'Share',
// child: Row(
// children: [
// Icon(Icons.share,
// color: Colors.green),
// SizedBox(
// width: 8,
// ),
// Text(LocaleKeys.shareNow.tr(),
// style: TextStyle(
// color: SocialCubit.get(
// context)
// .textColor)),
// ],
// ))
// ],
// child: Row(
// children: [
// Icon(
// Icons.share,
// color: Colors.green,
// ),
// SizedBox(
// width: 5,
// ),
// Text(LocaleKeys.share.tr(),
// style: TextStyle(
// color:
// SocialCubit.get(context)
// .textColor)),
// ],
// ),
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// ],
// ),
// ),
// )

// PopupMenuButton(
// color: SocialCubit.get(context).backgroundColor.withOpacity(1),
// onSelected: (value) {
// if (value == 'Delete post')
// SocialCubit.get(context)
//     .deletePost(postModel.postId);
// else if (value == 'Edit post')
// navigateTo(context, NewPostScreen(
// isEdit: true,
// postId:postModel.postId,
// postModel: postModel,
// ));
// },
// child: Icon(Icons.more_horiz_outlined),
// itemBuilder: (context) => [
// PopupMenuItem(
// value: 'Delete post',
// child: Row(
// children: [
// Icon(
// Icons.delete_outline_outlined,
// color: Colors.red,
// ),
// SizedBox(
// width: 5,
// ),
// Text(LocaleKeys.deletepost.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),)
// ],
// )), // delete post
// PopupMenuItem(
// value: 'Edit post',
// child: Row(
// children: [
// Icon(
// Icons.edit_outlined,
// color: Colors.grey,
// ),
// SizedBox(
// width: 5,
// ),
// Text(LocaleKeys.Editpost.tr(),style: TextStyle(color: SocialCubit.get(context).textColor))
// ],
// )), // editPost
// ]),
