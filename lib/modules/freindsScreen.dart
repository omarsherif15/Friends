import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/shared/constants.dart';

import 'friendsProfileScreen.dart';

class FriendsScreen extends StatelessWidget {
  List<UserModel>? friends;
  FriendsScreen(this.friends);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){},
        builder: (context,state){
          List<UserModel>? friends = this.friends;
          print(SocialCubit.get(context).friends.length);
          return Scaffold(
            appBar: AppBar(
              title: Text('Friends'),
              elevation: 8,
              titleSpacing: 0,
            ),
              backgroundColor: Colors.white,
              body: //state is GetFriendLoadingState
              friends!.length == 0 ?
              Center(child: CircularProgressIndicator(),) : ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => chatBuildItem(context,friends[index]),
                separatorBuilder:(context,index) =>SizedBox(height: 0,),
                itemCount:friends.length,
              )
          );
        },
      );
    });
  }

}
Widget chatBuildItem (context,UserModel userModel) {
  return InkWell(
    onTap: (){
      if (SocialCubit.get(context).model!.uID == userModel.uID) {
        navigateTo(context, SocialLayout(3));
      } else
        navigateTo(context, FriendsProfileScreen(userModel.uID));
    },
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:NetworkImage('${userModel.profilePic}'),
            radius: 27,
          ),
          SizedBox(width: 10,),
          Text('${userModel.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),),
          Spacer(),
          PopupMenuButton(
              onSelected: (value){
                if(value == 'Unfriend')
                  SocialCubit.get(context).unFriend(userModel.uID);
              },
              child: Icon(Icons.more_horiz_outlined),
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 40,
                value:'Unfriend',
                  child: Row(children: [
                    Icon(Icons.person_remove),
                    SizedBox(width: 15,),
                    Text('Unfriend'),
              ],))
            ],
          ),
        ],
      ),
    ),
  );
}
// Row(
//   children: [
//     Expanded(
//       child: Text('',
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis ,),
//     ),
//     CircleAvatar(
//       backgroundColor: Colors.black,
//       radius: 2.5,
//     ),
//     SizedBox(width: 5,),
//     Text('2:00 PM')
//   ],
// ),