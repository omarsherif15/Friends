import 'package:flutter/material.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/CommentsScreen.dart';
import 'package:socialapp/modules/LikesScreen.dart';
import 'package:socialapp/modules/friendsProfileScreen.dart';
import 'package:socialapp/modules/newPostScreen.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';

import 'constants.dart';

Widget defaultFormField({
  required context,
  TextEditingController? controller,
  dynamic hintText,
  dynamic labelText,
  IconData? prefix,
  int maxLines = 1,
  String? initialValue,
  TextInputType? keyboardType,
  Function(String)? onSubmit,
  onChange,
  onTap,
  required String? Function(String?) validate,
  bool isPassword = false,
  bool enabled = true,
  IconData? suffix,
  suffixPressed,
}) =>
    Container(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        textAlign: TextAlign.start,
        onFieldSubmitted: onSubmit,
        enabled: enabled,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        textCapitalization: TextCapitalization.words,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyText1,
        initialValue: initialValue,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          prefixIcon: Icon(
            prefix,
            color: Colors.blueAccent,
          ),
          prefixStyle: TextStyle(color: Colors.blueAccent),
          suffixStyle: TextStyle(color: Colors.blueAccent),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(suffix, color: Colors.blueAccent))
              : null,
        ),
      ),
    );

Widget defaultButton({
  required VoidCallback onTap,
  required String text,
  double? width = 400,
}) =>
    Container(
      height: 50,
      width: width,
      child: MaterialButton(
        color: Colors.blueAccent,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: onTap,
        child: Text(
          '$text',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );

Widget buildPost(context,state, PostModel postModel, UserModel model, index) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 8,
    margin: EdgeInsets.zero,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (postModel.uId != SocialCubit.get(context).model!.uID)
                    navigateTo(context, FriendsProfileScreen(postModel.uId));
                  else
                    navigateTo(context, SocialLayout(3));
                },
                child: CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        NetworkImage('${postModel.profilePicture}')),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      if (postModel.uId != SocialCubit.get(context).model!.uID)
                        navigateTo(context, FriendsProfileScreen(postModel.uId));
                      else
                        navigateTo(context, SocialLayout(3));
                    },
                      child: Text('${postModel.name}')),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${postModel.date} at ${postModel.time}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              if(SocialCubit.get(context).model!.uID == postModel.uId)
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'Delete post')
                      SocialCubit.get(context)
                          .deletePost(SocialCubit.get(context).postsId[index]);
                    else if (value == 'Edit post')
                      navigateTo(
                          context,
                          NewPostScreen(
                            isEdit: true,
                            postId:SocialCubit.get(context).postsId[index],
                            postModel: postModel,
                          ));
                  },
                  child: Icon(Icons.more_horiz_outlined),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 'Delete post',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Delete post')
                              ],
                            )), // delete post
                        PopupMenuItem(
                            value: 'Edit post',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Edit post')
                              ],
                            )), // editPost
                      ]),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          postModel.postImage != null ?Text('${postModel.postText}',style: TextStyle(fontSize: 15),)
          : Text('${postModel.postText}',style: TextStyle(fontSize: 20),),
          if (postModel.postImage != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 10),
              child: Image(image: NetworkImage('${postModel.postImage}')),
            ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                if(postModel.likes != 0)
                  InkWell(
                    onTap: () => navigateTo(context, WhoLikedScreen(SocialCubit.get(context).postsId[index])),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        IconBroken.Heart,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${postModel.likes}'),
                    ],
                ),
                  ),
                Spacer(),
                if(postModel.comments != 0)
                  InkWell(
                  onTap: () {
                    navigateTo(
                        context,
                        CommentsScreen(
                            index, SocialCubit.get(context).postsId[index]));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        IconBroken.Chat,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${postModel.comments} Comments'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: myDivider(),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  navigateTo(
                      context,
                      CommentsScreen(
                          index, SocialCubit.get(context).postsId[index]));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('${model.profilePic}')),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Write a comment...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  if(SocialCubit.get(context).isLiked == false)
                    SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                  if(SocialCubit.get(context).isLiked == true)
                    SocialCubit.get(context).disLikePost(SocialCubit.get(context).postsId[index]);
                },
                child: Row(
                  children: [
                    Icon(
                      IconBroken.Heart,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Like'),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              PopupMenuButton(
                onSelected: (value) {
                  if(value == 'Share')
                    {
                      SocialCubit.get(context).createNewPost(
                         name: SocialCubit.get(context).model!.name,
                          profileImage: SocialCubit.get(context).model!.profilePic,
                          postText: postModel.postText,
                          postImage: postModel.postImage,
                          date: getDate() ,
                          time: TimeOfDay.now().format(context).toString()
                      ) ;
                    }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'Share',
                      child: Row(children: [
                        Icon(Icons.share),
                        SizedBox(width: 5,),
                        Text('Share Now'),
                  ],))
                ],
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.green,),
                    SizedBox(width: 5,),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}



// Widget bottomSheet (){
//   return BottomSheet(
//       onClosing: (){},
//       builder: (context){
//         return Column(
//           children: [
//             Row(
//               children: [
//                 Icon(IconBroken.Heart,color: Colors.red,),
//                 SizedBox(width: 5,),
//                 Text('${SocialCubit.get(context).likes[index]}'),
//                 Spacer(),
//                 InkWell(
//                   onTap: (){
//                     SocialCubit.get(context).likePost(SocialCubit.get(context).postId[index]);
//                   },
//                   child: Icon(IconBroken.Heart,color: Colors.red,),
//                 ),
//               ],
//             ),
//             myDivider(),
//             Row(
//               children:
//               [
//                 CircleAvatar(
//                     radius: 25,
//                     backgroundImage:NetworkImage('${model.profilePic}')
//                 ),
//                 SizedBox(width: 15,),
//                 Container(
//                   color: Colors.grey[300],
//                   decoration: BoxDecoration(),
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('${model.name}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
//                       SizedBox(height: 5,),
//                       Text('public',style: TextStyle(color: Colors.grey),)
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],);
//       }
//   );
// }