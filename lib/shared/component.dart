import 'package:easy_localization/src/public_ext.dart';
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
import 'package:socialapp/modules/searchScreen.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';

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
          labelStyle: TextStyle(color: SocialCubit.get(context).textColor),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: SocialCubit.get(context).textColor)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: SocialCubit.get(context).textColor)),
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
    color: SocialCubit.get(context).backgroundColor,
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
                      child: Text('${postModel.name}',style: TextStyle(color: SocialCubit.get(context).textColor),)),
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
                          .deletePost(postModel.postId);
                    else if (value == 'Edit post')
                      navigateTo(context, NewPostScreen(
                            isEdit: true,
                            postId:postModel.postId,
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
                                Text(LocaleKeys.DeletePost.tr())
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
                                Text(LocaleKeys.editPost.tr())
                              ],
                            )), // editPost
                      ]),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          postModel.postImage != null ?Text('${postModel.postText}',style: TextStyle(fontSize: 15,color: SocialCubit.get(context).textColor),)
          : Text('${postModel.postText}',style: TextStyle(fontSize: 20,color: SocialCubit.get(context).textColor),),
          if (postModel.postImage != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 10),
              child: imagePreview(postModel.postImage)
            ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                if(postModel.likes != 0)
                  InkWell(
                    onTap: () => navigateTo(context, WhoLikedScreen(postModel.postId)),
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
                      Text('${postModel.likes}',style: TextStyle(color: SocialCubit.get(context).textColor)),
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
                            index, postModel.postId));
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
                      Text('${postModel.comments}' + LocaleKeys.comment.tr(),style: TextStyle(color: SocialCubit.get(context).textColor)),
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
                          index, postModel.postId));
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
                      LocaleKeys.write_comment.tr(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  if(SocialCubit.get(context).isLiked == false)
                    SocialCubit.get(context).likePost(postModel.postId);
                  if(SocialCubit.get(context).isLiked == true)
                    SocialCubit.get(context).disLikePost(postModel.postId);
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
                    Text(LocaleKeys.Like.tr(),style: TextStyle(color: SocialCubit.get(context).textColor)),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              PopupMenuButton(
                color: SocialCubit.get(context).backgroundColor,
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
                      child:
                      Row(children: [
                        Icon(Icons.share,color: Colors.green),
                        SizedBox(width: 8,),
                        Text(LocaleKeys.shareNow.tr(),style: TextStyle(color: SocialCubit.get(context).textColor)),
                  ],))
                ],
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.green,),
                    SizedBox(width: 5,),
                    Text(LocaleKeys.share.tr(),style: TextStyle(color: SocialCubit.get(context).textColor)),
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

Widget baseAlertDialog({
  required context,
  String? title,
  String? content,
  String? outlinedButtonText,
  String? elevatedButtonText,
  IconData? elevatedButtonIcon,
}){
  return AlertDialog(
    backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
    title: Text('$title',style: TextStyle(color: SocialCubit.get(context).textColor),),
    titlePadding: EdgeInsetsDirectional.only(start:13,top: 15 ),
    content: Text('$content',style: TextStyle(color: SocialCubit.get(context).textColor,),),
    elevation: 8,
    contentPadding: EdgeInsets.all(15),
    actions: [
      OutlinedButton(
          onPressed: (){
            Navigator.of(context).pop(false);
          },
          child: Text('$outlinedButtonText')
      ),
      Container(
        width: 100,
        child: ElevatedButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
          onPressed: (){
            Navigator.of(context).pop(true);
          },
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(elevatedButtonIcon),
              SizedBox(width: 5,),
              Text('$elevatedButtonText',style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    ],

  );
}

Widget searchBar({
  required context,
  bool readOnly = true,
  double height = 40,
  double width = double.infinity,

}){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    height: height,
    width: width,
    child: TextFormField(
      readOnly: readOnly,
      style: TextStyle(color: SocialCubit.get(context).textColor),
      onTap: () => navigateTo(context, SearchScreen()),
      decoration: InputDecoration(
        border: OutlineInputBorder( borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: SocialCubit.get(context).textFieldColor,
        disabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(15)),
        hintText: LocaleKeys.search.tr(),
        hintStyle: TextStyle(fontSize: 15,color: Colors.grey),
        prefixIcon: Icon(Icons.search,color: Colors.grey,),
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
