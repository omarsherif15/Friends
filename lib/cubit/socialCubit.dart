import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/commentModel.dart';
import 'package:socialapp/models/likesModel.dart';
import 'package:socialapp/models/messageModel.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/recentMessagesModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/recentMessages.dart';
import 'package:socialapp/modules/homeScreen.dart';
import 'package:socialapp/modules/loginScreen.dart';
import 'package:socialapp/modules/profileScreen.dart';
import 'package:socialapp/modules/usersScreen.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates>
{
  SocialCubit() : super(InitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? model;
  void getUserData(){
    emit(UserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId!).get().
    then((value) {
      model = UserModel.fromJson(value.data());
      print(model!.uID);
      emit(UserSuccessState());
    }).catchError((error){
      emit(UserErrorState());
    });
  }

  List<UserModel> users = [];
  List<UserModel> peopleYouMayKnow = [];
  void getAllUsers(){
    emit(GetAllUsersLoadingState());
      FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((value){
          users = [];
          peopleYouMayKnow = [];
      value.docs.forEach((element) {
        if(element.id != model!.uID) {
          users.add(UserModel.fromJson(element.data()));
        }
      });

      print(peopleYouMayKnow.length);
      print(users.length);
      emit(GetAllUsersSuccessState());
      });
  }

  List<UserModel>  searchList = [];
  Map<String,dynamic>?search;
  void searchUser(String? searchText){
    emit(SearchLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('name',isEqualTo: searchText)
        .get()
        .then((value) {
          search = value.docs[0].data();
          emit(SearchSuccessState());
    })
        .catchError((error){
          print(error.toString());
          emit(SearchErrorState());
    });
  }


  UserModel? friendsProfile;
  void getFriendsProfile(String? friendsUid) {
    emit(GetFriendProfileLoadingState());
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .listen((value){
        value.docs.forEach((element) {
          if(element.data()['uId'] == friendsUid)
            friendsProfile = UserModel.fromJson(element.data());
        });
        emit(GetFriendProfileSuccessState());
      });
  }

  void addFriend({
    required String? friendsUid ,
    required String? friendName,
    required String? friendProfilePic
  }){
    emit(AddFriendLoadingState());
    UserModel myFriendModel = UserModel(
      uID: friendsUid,
      name: friendName,
      profilePic: friendProfilePic,
    );
    UserModel myModel = UserModel(
      uID: model!.uID,
      name: model!.name,
      profilePic: model!.profilePic,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friends')
        .doc(friendsUid)
        .set(myFriendModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(AddFriendErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friends')
        .doc(model!.uID)
        .set(myModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(AddFriendErrorState());
    });
  }

  List<UserModel> friends = [];
  void getFriends(String? userUid){
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends')
        .snapshots()
        .listen((value) {
      friends = [];
      value.docs.forEach((element){
        friends.add(UserModel.fromJson(element.data()));
      });
      emit(GetFriendSuccessState());
    });
  }

  bool isFriend = false;
  bool checkFriends(String? friendUid){
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friends')
        .snapshots()
        .listen((value) {
      isFriend = false;
      value.docs.forEach((element) {
        if (friendUid == element.id)
          isFriend = true;
      });
      emit(CheckFriendState());
    });
      return isFriend;
  }



  void unFriend(String? friendsUid){
    emit(UnFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friends')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(UnFriendSuccessState());
    })
        .catchError((error){
      emit(UnFriendErrorState());
      print(error.toString());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friends')
        .doc(model!.uID)
        .delete()
        .then((value) {
      emit(UnFriendSuccessState());
    })
        .catchError((error){
      emit(UnFriendErrorState());
      print(error.toString());
    });
  }


  void sendFriendRequest({
    required String? friendsUid ,
    required String? friendName,
    required String? friendProfilePic
  }) {
    emit(FriendRequestLoadingState());
    UserModel friendRequestModel = UserModel(
      uID: model!.uID,
      name: model!.name,
      profilePic: model!.profilePic,
      bio: model!.bio,
      dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friendRequests')
        .doc(model!.uID)
        .set(friendRequestModel.toMap())
        .then((value) {
      emit(FriendRequestSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(FriendRequestErrorState());
    });
  }

  List<UserModel> friendRequests = [];
  void getFriendRequest(String? userUid){
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friendRequests')
        .snapshots()
        .listen((value) {
      friendRequests = [];
      value.docs.forEach((element){
        friendRequests.add(UserModel.fromJson(element.data()));
        emit(GetFriendSuccessState());
      });
    });
  }

  bool request = false;
  bool checkFriendRequest(String? friendUid){
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection('friendRequests')
        .get()
        .then((value){
      value.docs.forEach((element) {
        if(element.data()['uId'] == model!.uID)
           request = true;
        else
          request = false;
      });
      emit(CheckFriendRequestState());
    });
    return request;
  }

  void deleteFriendRequest(String? friendsUid){
    emit(DeleteFriendRequestLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friendRequests')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(DeleteFriendRequestSuccessState());
    })
        .catchError((error){
      emit(DeleteFriendRequestErrorState());
      print(error.toString());
    });
  }

  void updateUserData({
     String? name,
     String? phone,
     String? email,
     String? bio,
     String? coverImage,
     String? profileImage,
  }){
    emit(UpdateUserLoadingState());

    UserModel model = UserModel(
        uID: uId,
        name: name,
        phone: phone,
        bio: bio,
        email: email,
        coverPic: coverImage,
        profilePic: profileImage
    );
    FirebaseFirestore.instance.collection('users').doc(uId).update(model.toMap())
        .then((value) {
          getUserData();
          emit(UpdateUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(UpdateUserErrorState());
    });
  }

  void signOut(context){
    emit(SignOutLoadingState());
    FirebaseAuth.instance.signOut().
    then((value) {
      CacheHelper.removeData('uId');
      navigateAndKill(context, LoginScreen());
      emit(SignOutSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SignOutErrorState());
    });
  }

  void popPostImage(){
    postImage = null;
    emit(DeletePostPicState());
  }

  File? postImage;
  Future getPostImage() async {
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(GetPostPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetPostPicErrorState());
    }
  }

  String? postPic;
  void uploadPostPic(
      String? name,
      String? profilePicture,
      String? postText,
      String? date,
      String? time
      )
  {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(postImage!.path).pathSegments.last)
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
            createNewPost(
              name: name,
              profileImage: profilePicture,
              postImage: value,
              postText: postText,
              time: time,
              date: date
            );
        emit(UploadPostPicSuccessState());
      })
          .catchError((error){
        print(error.toString());
        emit(UploadPostPicErrorState());
      });
      emit(UploadPostPicSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(UploadPostPicErrorState());
    });
  }

  void createNewPost({
    String? name,
    String? profileImage,
    String? postText,
    String? postImage,
    String? date,
    String? time
  }){
    emit(CreatePostLoadingState());

    PostModel postModel = PostModel(
      name: name,
      uId: model!.uID,
      profilePicture: profileImage,
      postText: postText,
      postImage: postImage,
      likes: 0,
      comments: 0,
      date: date,
      time: time,
      dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance.collection('posts')
        .add(postModel.toMap())
        .then((value) {
          getPosts();
      emit(CreatePostSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(CreatePostErrorState());
    });
  }

  void setPostId(){
    FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .listen((value){
          value.docs.forEach((element) {
            element.reference.update({
              'postId' : element.id
            });
          });
    });
  }

  List<PostModel> posts = [];
  void getPosts(){
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          posts = [];
          event.docs.forEach((element) {
            posts.add(PostModel.fromJson(element.data()));
          });
          setPostId();
          emit(GetPostSuccessState());
    });
  }

  List<PostModel> userPosts = [];
  void getUserPosts(String ? userId){
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      userPosts = [];
      event.docs.forEach((element) {
        if(element.data()['uId'] == userId) {
          userPosts.add(PostModel.fromJson(element.data()));
        }
      });
      emit(GetPostSuccessState());
    });
  }

  void deletePost(String? postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete().then((value) {
          getPosts();
          emit(DeletePostSuccessState());
    });
  }

  void editPost({
    required postId,
    String? name,
    String? profileImage,
    String? postText,
    String? postImage,
    int? likes,
    int? comments,
    String? date,
    String? time,
    FieldValue? dateTime,
  }){
    emit(UpdatePostLoadingState());

    PostModel updatedPostModel = PostModel(
        name: name,
        uId: model!.uID,
        profilePicture: profileImage,
        postText: postText,
        postImage: postImage,
        likes: likes,
        comments: comments,
        date: date,
        time: time,
        dateTime: dateTime
    );
    FirebaseFirestore.instance.collection('posts')
        .doc(postId).update(updatedPostModel.toMap())
        .then((value) {
          getPosts();
      emit(UpdatePostSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(UpdatePostErrorState());
    });
  }

  void editPostPic({
    required postId,
    String? name,
    String? profilePicture,
    String? postText,
    int? likes,
    int? comments,
    String? date,
    String? time,
    FieldValue? dateTime,

  }
      )
  {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(postImage!.path).pathSegments.last)
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        editPost(
            postId: postId,
            name: name,
            profileImage: profilePicture,
            postImage: value,
            postText: postText,
            likes: likes,
            comments: comments,
            time: time,
            date: date,
            dateTime: dateTime
        );
        emit(UploadPostPicSuccessState());
      })
          .catchError((error){
        print(error.toString());
        emit(UploadPostPicErrorState());
      });
      getPosts();
      emit(UploadPostPicSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(UploadPostPicErrorState());
    });
  }

  bool isLiked = false;
  void likePost(String? postId){
    LikesModel likesModel = LikesModel(
      uId: model!.uID,
      name: model!.name,
      profilePicture: model!.profilePic,
      dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uID)
        .set(likesModel.toMap()).then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({
        'likes' : FieldValue.increment(1),
      });
      getPosts();
      isLiked = true;
      emit(LikePostSuccessState());
    })
        .catchError((error){
          print(error.toString());
      emit(LikePostErrorState());
    });

  }

  void disLikePost(String? postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uID)
        .delete().then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({
        'likes': FieldValue.increment(-1)
      });
      getPosts();
      isLiked = false;
      emit(DisLikePostSuccessState());
    }).catchError((error){
      emit(DisLikePostErrorState());
      print(error.toString());
    });
  }


  List<LikesModel> peopleReacted = [];
  void getLikes(String? postId){
      FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .listen((value){
          peopleReacted = [];
          value.docs.forEach((element) {
            peopleReacted.add(LikesModel.fromJson(element.data()));
          });
          emit(GetLikesSuccessState());
    });
  }

  void commentPost({
    required String? postId,
    String? comment,
    String? commentImage,
    required String time,
  }){
    CommentModel commentModel = CommentModel(
      name: model!.name,
      profilePicture: model!.profilePic,
      commentText: comment,
      commentImage: commentImage,
      time: time,
      dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({
        'comments' : FieldValue.increment(1),
      }).then((value){emit(PlusCommentSuccessState());});
      getPosts();
      emit(CommentPostSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(CommentPostErrorState());

    });
  }



  List<CommentModel> comments = [];
  void getComments(postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments.clear();
      event.docs.forEach((element){
            comments.add(CommentModel.fromJson(element.data()));
            emit(GetCommentsSuccessState());
          });
    });

  }

  File? profileImage;
  ImagePicker? picker = ImagePicker();

  Future? getProfileImage() async {
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetProfilePicSuccessState());
    } else
    {print('No Image Selected');
    emit(GetProfilePicErrorState());}
  }

  File? coverImage;
  Future getCoverImage() async {
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(GetCoverPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCoverPicErrorState());
    }
  }

  String ?profilePicURL;
  void uploadProfilePic(
      String? name,
      String? phone,
      String? bio,
      String? email,
      String? coverImage,
      )
  {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(profileImage!.path).pathSegments.last)
        .putFile(profileImage!)
        .then((value) {
          value.ref.getDownloadURL()
              .then((value) {
                updateUserData(
                  name: name,
                  phone: phone,
                  bio: bio,
                  coverImage: coverImage,
                  profileImage: value
                );
            emit(UploadProfilePicSuccessState());
          })
              .catchError((error){
                print(error.toString());
            emit(UploadProfilePicErrorState());
          });
          emit(UploadProfilePicSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(UploadProfilePicErrorState());
    });
  }

  String? coverPic;
  void uploadCoverPic(
      String? name,
      String? phone,
      String? bio,
      String? email,
      String? profile
      )
  {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(coverImage!.path).pathSegments.last)
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          email: email,
          profileImage: profile,
          coverImage: value,
        );
        emit(UploadCoverPicSuccessState());
      })
          .catchError((error){
        print(error.toString());
        emit(UploadCoverPicErrorState());
      });
      emit(UploadCoverPicSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(UploadCoverPicErrorState());
    });
  }

  void sendMessage({
    required String ? receiverId,
    required String ? messageText,
    String ? messageImage,
    required String ? date,
    required String ? time,
  }){
    MessageModel messageModel = MessageModel(
        senderId: model!.uID,
        receiverId: receiverId,
        messageText: messageText,
        messageImage: messageImage,
        date: date,
        time: time,
        dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
    .collection('chats')
    .doc(receiverId)
    .collection('message')
    .add(messageModel.toMap())
    .then((value) {
      emit(SendMessageSuccessState());
    })
    .catchError((error){
      print(error.toString());
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model!.uID)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(SendMessageErrorState());
    });
  }

  void setRecentMessage({
    required String ? receiverName,
    required String ? senderId,
    required String ? receiverId,
    required String ? recentMessageText,
    required String ? profilePic,
    required String ? time,
  }){
    RecentMessagesModel recentMessagesModel = RecentMessagesModel(
        uID: receiverId,
        receiverName: model!.name,
        senderId: senderId,
        receiverId: receiverId,
        recentMessageText: recentMessageText,
        profilePic: model!.profilePic,
        time: time,
        dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('recentMsg')
        .doc(receiverId)
        .set(recentMessagesModel.toMap())
        .then((value) {
      emit(SetRecentMessageSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(SetRecentMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('recentMsg')
        .doc(model!.uID)
        .set(recentMessagesModel.toMap())
        .then((value) {
      emit(SetRecentMessageSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(SetRecentMessageErrorState());
    });
  }

  bool showTime = false;
  void time(){
    showTime = !showTime;
    emit(ShowTimeState());
  }

  List<MessageModel> chat = [];
  void getChat(String? receiverId){
    FirebaseFirestore.instance
        .collection("users")
        .doc(model!.uID)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      chat = [];
      event.docs.forEach((element) {
          chat.add(MessageModel.fromJson(element.data()));
       });
          emit(GetChatSuccessState());
    });
  }

  List<RecentMessagesModel> recentMessages = [];
  void getRecentMessages(){
    FirebaseFirestore.instance
        .collection("users")
        .doc(model!.uID)
        .collection('recentMsg')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      recentMessages = [];
      event.docs.forEach((element) {
        recentMessages.add(RecentMessagesModel.fromJson(element.data()));
      });
      emit(GetRecentMsgSuccessState());
    });
  }

  List<Widget> tabBar =
  [
    Tab(
      icon:Icon(Icons.home_outlined) ,
    ),
    Tab(
      icon: Icon(Icons.group),
    ),
    Tab(
      icon:Icon(IconBroken.Chat) ,
    ),
    Tab(
      icon:Icon(IconBroken.Profile) ,
    )
  ];

  int currentIndex = 0;
  changeBottomNav(index) {
    if(index == 0)
      getPosts();
   else if(index == 1)
      getAllUsers();
    else if(index == 2)
      getRecentMessages();
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  List<Widget> screens =
  [
    HomeScreen(),
    UsersScreen(),
    RecentMessages(),
    ProfileScreen(),
  ];
  List<Widget> appBarTitle =
  [
    Text('News Feed',),
    Text('Users'),
    Text('Chats'),
    Text('My Account'),
  ];

}