import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class NewPostScreen extends StatelessWidget {
TextEditingController postTextController = TextEditingController();
String? postId;
PostModel? postModel;
bool isEdit;
NewPostScreen({required this.isEdit,this.postId,this.postModel});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){
          if(state is CreatePostLoadingState) {
            navigateAndKill(context, SocialLayout(0));
            showToast(LocaleKeys.posting.tr());
          }
          else if(state is CreatePostSuccessState) {
            navigateAndKill(context, SocialLayout(0));
          showToast(LocaleKeys.postedSuccess.tr());
        }
          else if(state is UpdatePostLoadingState) {
            navigateAndKill(context, SocialLayout(0));
            showToast(LocaleKeys.editing.tr());
          }
          else if(state is UpdatePostSuccessState) {
            navigateAndKill(context, SocialLayout(0));
            showToast(LocaleKeys.EditSuccess.tr());
          }
      },
      builder: (context,state){
          print(postId);
        dynamic postPic = SocialCubit.get(context).postImage;
        isEdit && postModel!.postText != null ? postTextController.text = postModel!.postText! : print('post text = null');
        UserModel? userModel = SocialCubit.get(context).model;
        return  Scaffold(
          backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
            appBar: AppBar(
              toolbarHeight: 50,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: (){
                postTextController.clear();
                pop(context);
                  if(postPic != null) {
                    SocialCubit.get(context).popPostImage();
                    pop(context);
                  } else if(postModel!.postImage != null) {
                    postModel!.postImage = null;
                    SocialCubit.get(context).emit(HomeSuccessState());
                    pop(context);
                  }
                },
                  icon: Icon(IconBroken.Arrow___Left_2,textDirection: Directionality.of(context),)),
              titleSpacing: 0,
              title: Text(LocaleKeys.createPost.tr()),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    //padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: SocialCubit.get(context).textFieldColor
                    ),
                    child: TextButton(
                        onPressed: (){
                          if(isEdit == false) {
                          if (SocialCubit.get(context).postImage == null) {
                            SocialCubit.get(context).createNewPost(
                              name: userModel!.name,
                              postText: postTextController.text,
                              profileImage: userModel.profilePic,
                              date: getDate(),
                              time: DateFormat.jm().format(DateTime.now()),
                            );
                          } else {
                            SocialCubit.get(context).uploadPostPic(
                                userModel!.name,
                                userModel.profilePic,
                                postTextController.text,
                                getDate(),
                              DateFormat.jm().format(DateTime.now()),);
                          }
                        }
                          else {
                          if (SocialCubit.get(context).postImage == null) {
                            SocialCubit.get(context).editPost(
                              postId: postId,
                              postImage: postModel!.postImage,
                              name: userModel!.name,
                              profileImage: userModel.profilePic,
                              postText: postTextController.text,
                              likes: postModel!.likes,
                              comments: postModel!.comments,
                              date: postModel!.date,
                              time: postModel!.time,
                            );
                          } else {
                            SocialCubit.get(context).editPostPic(
                                postId: postId,
                                name: userModel!.name,
                                profilePicture :userModel.profilePic,
                                postText: postTextController.text,
                                likes: postModel!.likes,
                                comments: postModel!.comments,
                                date: postModel!.date,
                                time: postModel!.time,
                            );
                          }
                        }
                      },
                        child: isEdit?Text(LocaleKeys.save.tr()):Text(LocaleKeys.post.tr())
                    ),
                  ),
                ),
                SizedBox(width: 10,)
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children:
                  [
                    if(state is CreatePostLoadingState || state is UpdatePostLoadingState)
                      Column(
                        children: [
                          LinearProgressIndicator(),
                          SizedBox(height:10),
                        ],
                      ),
                    Row(
                      children:
                      [
                        CircleAvatar(
                            radius: 25,
                            backgroundImage:NetworkImage('${userModel!.profilePic}')
                        ),
                        SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${userModel.name}',style: TextStyle(fontSize: 15,color: SocialCubit.get(context).textColor),),
                            SizedBox(height: 5,),
                            Text(LocaleKeys.public.tr(),style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12,),
                    TextFormField(
                      controller: postTextController,
                      maxLines: 10,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.whatOnYourMind.tr(),
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 18),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,

                      ),
                    ),
                   if(SocialCubit.get(context).postImage != null)
                     Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: SocialCubit.get(context).backgroundColor,
                                borderRadius: BorderRadius.circular(15)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child:Image.file(postPic,fit: BoxFit.cover,width: double.infinity),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 10,end: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: IconButton(
                                  onPressed: (){
                                    SocialCubit.get(context).popPostImage();
                                  },
                                  icon: Icon(Icons.close)),
                            ),
                          )
                        ],
                      ),
                    if(isEdit && postModel!.postImage != null)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: SocialCubit.get(context).backgroundColor,
                                borderRadius: BorderRadius.circular(15)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child:Image.network(postModel!.postImage!,fit: BoxFit.cover,width: double.infinity),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 10,end: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: IconButton(
                                  onPressed: (){
                                    postModel!.postImage = null;
                                    SocialCubit.get(context).popPostImage();
                                  },
                                  icon: Icon(Icons.close)),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          bottomSheet:
          Container(
            color: SocialCubit.get(context).backgroundColor.withOpacity(1),
            child: Row(
              children:
              [
                SizedBox(width: 5,),
                Expanded(
                  child: TextButton(
                      onPressed: (){
                        SocialCubit.get(context).getPostImage();
                      },
                      child: Row(
                        children:
                        [
                          Icon(IconBroken.Image),
                          SizedBox(width: 5,),
                          Text(LocaleKeys.image.tr(),style: TextStyle(color: Colors.grey)),
                        ],
                      )
                  ),
                ),
                Container(height: 30,width: 1,color: Colors.grey[300],),
                SizedBox(width: 5,),
                Expanded(
                  child: TextButton(
                      onPressed: (){},
                      child: Row(
                        children:
                        [
                          Icon(Icons.tag,color: Colors.red,),
                          SizedBox(width: 5,),
                          Text(LocaleKeys.tags.tr(),style: TextStyle(color: Colors.grey),),
                        ],
                      )
                  ),
                ),
                Container(height: 30,width: 1,color: Colors.grey[300],),
                SizedBox(width: 5,),
                Expanded(
                  child: TextButton(
                      onPressed: (){},
                      child: Row(
                        children:
                        [
                          Icon(IconBroken.Document,color: Colors.green,),
                          SizedBox(width: 5,),
                          Text(LocaleKeys.docs.tr(),style: TextStyle(color: Colors.grey)),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
          );
      },
    );
  }
}
