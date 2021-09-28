import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/commentModel.dart';
import 'package:socialapp/modules/LikesScreen.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';

class CommentsScreen extends StatelessWidget {
  var commentTextControl = TextEditingController();
  int index;
  String? postId;
CommentsScreen(this.index,this.postId);
  @override
  Widget build(BuildContext context) {
    int index = this.index;
    String? postId = this.postId;
    return Builder(
      builder:(context)
      {
        SocialCubit.get(context).getComments(postId);
        return BlocConsumer<SocialCubit,SocialStates>(
            listener: (context,state){},
            builder: (context,state) {
              List<CommentModel> comments = SocialCubit.get(context).comments;
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: (){
                      comments.clear();
                      pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            navigateTo(context, WhoLikedScreen(postId));
                          },
                          child: Row(
                            children: [
                              Icon(IconBroken.Heart,color: Colors.red,),
                              SizedBox(width: 5,),
                              Text('${SocialCubit.get(context).posts[index].likes}'),
                              Spacer(),
                              Icon(IconBroken.Arrow___Right_2),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        myDivider(),
                        SizedBox(height: 15,),
                        comments.length > 0 ?  Expanded(
                          child: ListView.separated(
                              itemBuilder: (context,index) => buildComment(comments[index]),
                              separatorBuilder: (context,index) => SizedBox(height: 10,),
                              itemCount: SocialCubit.get(context).comments.length
                          ),
                        ) : Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  Text('No Comments yet'),
                                  Text('Type your own')
                                ],
                              ),)),
                        myDivider(),
                        SizedBox(height: 10,),
                        Container(
                          height: 50,
                          child: TextFormField(
                              controller: commentTextControl,
                              autofocus: true,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: Colors.black,
                              validator: (value){
                                if(value!.isEmpty)
                                  return null;
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide.none),
                                  //contentPadding: EdgeInsets.all(10),
                                  hintText: 'Write a comment...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){},
                                          icon: Icon(Icons.camera_alt_outlined,color: Colors.grey,)
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            SocialCubit.get(context).commentPost(
                                              postId: postId,
                                              comment: commentTextControl.text,
                                              time: TimeOfDay.now().format(context),
                                            );
                                            commentTextControl.clear();
                                          },
                                          icon: Icon(Icons.send,color: Colors.blue,)
                                      ),
                                    ],
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(40))
                              )
                          ),
                        ),
                      ],
                    )),
              );
            }
            );},
    );
  }


  Widget buildComment(CommentModel comment){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children:
          [
            CircleAvatar(
                radius: 25,
                backgroundImage:NetworkImage('${comment.profilePicture}')
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${comment.name}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text('${comment.commentText}',)
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
            child: Text('${comment.time}',style: TextStyle(color: Colors.grey),textAlign: TextAlign.end,))
      ],
    );
  }
}
