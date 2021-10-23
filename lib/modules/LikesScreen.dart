import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/likesModel.dart';
import 'package:socialapp/modules/friendsProfileScreen.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class WhoLikedScreen extends StatelessWidget {
String ?postId;
WhoLikedScreen(this.postId);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      SocialCubit.get(context).getLikes(postId);
      return BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){},
          builder: (context,state) {
            List<LikesModel> peopleReacted = SocialCubit.get(context).peopleReacted;
            return Scaffold(
              appBar: AppBar(
                title: Text(LocaleKeys.Peoplewhoreacted.tr()),
                titleSpacing: 0,
                elevation: 8,
              ),
              body: ListView.separated(
                  itemBuilder: (context,index) => userLikeItem(context, peopleReacted[index]),
                  separatorBuilder:(context,index) => SizedBox(height: 0,),
                  itemCount: peopleReacted.length
              ),
            );
      },
      );
    });
  }
  Widget userLikeItem (context,LikesModel userModel) {
    return Builder(
      builder:(context) {
        return InkWell(
        onTap: (){
          if (SocialCubit.get(context).model!.uID == userModel.uId)
            navigateTo(context, SocialLayout(3));
        else
            navigateTo(context, FriendsProfileScreen(userModel.uId));
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:NetworkImage('${userModel.profilePicture}'),
                radius: 20,
              ),
              SizedBox(width: 10,),
              Text('${userModel.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: SocialCubit.get(context).textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),),
              Spacer(),
              if (SocialCubit.get(context).model!.uID != userModel.uId)
                Container(
                width: 120,
                child: ElevatedButton(
                  style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
                  onPressed: (){
                    SocialCubit.get(context).addFriend(
                      friendName: userModel.name,
                      friendProfilePic: userModel.profilePicture,
                      friendsUid: userModel.uId
                    );
                    SocialCubit.get(context).getFriends(userModel.uId);
                  },
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_1_rounded,size: 15,),
                      SizedBox(width: 5,),
                      Text(LocaleKeys.addFriend.tr(),style: TextStyle(color: Colors.white,fontSize: 12)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),);
      },
    );
  }

}
