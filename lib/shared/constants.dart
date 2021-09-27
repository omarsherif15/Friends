import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
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
  height: 1,
  width: double.infinity,
);

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
String time = TimeOfDay.fromDateTime(dateTime).toString();
String date =  DateFormat.yMMMd().format(dateTime);
return date;
}
void dateTime () {
  DateTime dateTime = DateTime.now();
  String date = DateFormat.yMMMd().format(dateTime);
  print(date);
  print(time);
}
String time = DateTime.now().toString().split(' ').elementAt(1);

Color defaultColor  = Colors.blueAccent;

String? uId = '';

int cartLength = 0;

var scroll = ScrollController();

String sinceWhen(String dateTime){
  return GetTimeAgo.parse(DateTime.parse(dateTime));
}

// Container(
// height: 250,
// width: double.infinity,
// alignment: AlignmentDirectional.topCenter,
// child: Stack(
// alignment: AlignmentDirectional.bottomCenter,
// children: [
// Align(
// alignment: AlignmentDirectional.topCenter,
// child: Container(
// height: 190,
// width: double.infinity,
// decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
// clipBehavior: Clip.antiAliasWithSaveLayer,
// child: Image.network('${friendsModel!.coverPic}', fit: BoxFit.fill, width: double.infinity,height: 190, alignment: AlignmentDirectional.topCenter,),
// ),
// ),
// CircleAvatar(
// radius: 75,
// backgroundColor: Colors.white,
// child: CircleAvatar(
// radius: 70,
// backgroundImage:NetworkImage('${friendsModel.profilePic}'),
// ),
// )
// ],
// ),
// ),
