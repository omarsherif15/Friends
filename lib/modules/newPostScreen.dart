import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';

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
          if(state is CreatePostSuccessState) {
          navigateAndKill(context, SocialLayout(0));
          showToast('Post Created Successfully');
        }
          else if(state is UpdatePostSuccessState) {
            navigateAndKill(context, SocialLayout(0));
            showToast('Post Updated Successfully');
          }
      },
      builder: (context,state){
          print(postId);
        dynamic postPic = SocialCubit.get(context).postImage;
        isEdit && postModel!.postText != null ? postTextController.text = postModel!.postText! : print('post text = null');
        UserModel? userModel = SocialCubit.get(context).model;
        return  Scaffold(
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
                  icon: Icon(IconBroken.Arrow___Left_2)),
              titleSpacing: 0,
              title: Text('Create Post'),
              actions: [
                TextButton(
                    onPressed: (){
                      if(isEdit == false) {
                      if (SocialCubit.get(context).postImage == null) {
                        SocialCubit.get(context).createNewPost(
                          name: userModel!.name,
                          postText: postTextController.text,
                          profileImage: userModel.profilePic,
                          date: getDate(),
                          time: TimeOfDay.now().format(context),
                        );
                      } else {
                        SocialCubit.get(context).uploadPostPic(
                            userModel!.name,
                            userModel.profilePic,
                            postTextController.text,
                            getDate(),
                            TimeOfDay.now().toString());
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
                    child: isEdit?Text('SAVE'):Text('POST')
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
                            Text('${userModel.name}',style: TextStyle(fontSize: 15),),
                            SizedBox(height: 5,),
                            Text('public',style: TextStyle(color: Colors.grey),)
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
                        hintText: 'What is on your mind...',
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
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
          bottomSheet: Row(
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
                        Text('Image',style: TextStyle(color: Colors.grey)),
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
                        Text('Tags',style: TextStyle(color: Colors.grey),),
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
                        Text('Docs',style: TextStyle(color: Colors.grey)),
                      ],
                    )
                ),
              ),
            ],
          ),
          );
      },
    );
  }
}
