import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/commentModel.dart';
import 'package:socialapp/models/likesModel.dart';
import 'package:socialapp/models/messageModel.dart';
import 'package:socialapp/models/notificationModel.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/recentMessagesModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/SettingScreen.dart';
import 'package:socialapp/modules/homeScreen.dart';
import 'package:socialapp/modules/loginScreen.dart';
import 'package:socialapp/modules/notificationScreen.dart';
import 'package:socialapp/modules/profileScreen.dart';
import 'package:socialapp/modules/recentMessages.dart';
import 'package:socialapp/modules/usersScreen.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';
import 'package:socialapp/remoteNetwork/dioHelper.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(InitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  void changeLocalToAr (BuildContext context)async {
    await context.setLocale(Locale('ar'));
    emit(ChangeLocalToArState());
  }
  void changeLocalToEn (BuildContext context) async {
    await context.setLocale(Locale('en'));
    emit(ChangeLocalToEnState());
  }

  UserModel? model;

  Future getMyData() async {
    emit(UserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!)
        .snapshots()
        .listen((value) async {
      model = UserModel.fromJson(value.data());
      setUserToken();
      getUnReadRecentMessagesCount();
      getUnReadNotificationsCount();
      getFriendRequest();
      print(model!.uID);
      emit(UserSuccessState());
    });
  }


  Future getHomeData(context) async{
   await getMyData();
      getPosts();
      await getUnReadRecentMessagesCount();
      await getUnReadRecentMessagesCount();
      getFriends(model!.uID);
      getFriendRequest();
      getUserPosts(model!.uID);
      getInAppNotification();

  }

  UserModel? userModel;
  void getUserData(String? uid) {
    emit(UserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      print(userModel!.uID);
      emit(UserSuccessState());
    }).catchError((error) {
      emit(UserErrorState());
    });
  }

  List<UserModel> users = [];
  List<UserModel> peopleYouMayKnow = [];

  void getAllUsers() {
    emit(GetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((value) {
      users = [];
      peopleYouMayKnow = [];
      value.docs.forEach((element) {
        if (element.id != model!.uID) {
          users.add(UserModel.fromJson(element.data()));
        }
      });
      emit(GetAllUsersSuccessState());
    });
  }

  void setUserToken() async{
    emit(SetUSerTokenLoadingState());
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('users').doc(model!.uID)
        .update({'token': token})
        .then((value) => emit(SetUSerTokenSuccessState()));
  }

  List<UserModel> searchList = [];
  Map<String, dynamic>? search;

  void searchUser(String? searchText) {
    emit(SearchLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: searchText)
        .get()
        .then((value) {
      search = value.docs[0].data();
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }

  UserModel? friendsProfile;

  void getFriendsProfile(String? friendsUid) {
    emit(GetFriendProfileLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == friendsUid)
          friendsProfile = UserModel.fromJson(element.data());
      });
      emit(GetFriendProfileSuccessState());
    });
  }

  void addFriend(
      {required String? friendsUid,
      required String? friendName,
      required String? friendProfilePic}) {
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
    }).catchError((error) {
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
    }).catchError((error) {
      print(error.toString());
      emit(AddFriendErrorState());
    });
  }

   List<UserModel> friends = [];

  void getFriends(String? userUid) {
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends')
        .snapshots()
        .listen((value) {
      friends = [];
      value.docs.forEach((element) {
        friends.add(UserModel.fromJson(element.data()));
      });
      emit(GetFriendSuccessState());
    });
  }

  bool isFriend = false;

  bool checkFriends(String? friendUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friends')
        .snapshots()
        .listen((value) {
      isFriend = false;
      value.docs.forEach((element) {
        if (friendUid == element.id) isFriend = true;
      });
      emit(CheckFriendState());
    });
    return isFriend;
  }

  void unFriend(String? friendsUid) {
    emit(UnFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friends')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(UnFriendSuccessState());
    }).catchError((error) {
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
    }).catchError((error) {
      emit(UnFriendErrorState());
      print(error.toString());
    });
  }

  void sendFriendRequest(
      {required String? friendsUid,
      required String? friendName,
      required String? friendProfilePic}) {
    emit(FriendRequestLoadingState());
    UserModel friendRequestModel = UserModel(
        uID: model!.uID,
        name: model!.name,
        profilePic: model!.profilePic,
        bio: model!.bio,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friendRequests')
        .doc(model!.uID)
        .set(friendRequestModel.toMap())
        .then((value) {
      emit(FriendRequestSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(FriendRequestErrorState());
    });
  }

  List<UserModel> friendRequests = [];
  void getFriendRequest() {
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friendRequests')
        .snapshots()
        .listen((value) {
      friendRequests = [];
      value.docs.forEach((element) {
        friendRequests.add(UserModel.fromJson(element.data()));
        emit(GetFriendSuccessState());
      });
    });
  }

  bool request = false;

  bool checkFriendRequest(String? friendUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection('friendRequests')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == model!.uID)
          request = true;
        else
          request = false;
      });
      emit(CheckFriendRequestState());
    });
    return request;
  }

  void deleteFriendRequest(String? friendsUid) {
    emit(DeleteFriendRequestLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('friendRequests')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(DeleteFriendRequestSuccessState());
    }).catchError((error) {
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
  }) {
    emit(UpdateUserLoadingState());

    UserModel model = UserModel(
        uID: uId,
        name: name,
        phone: phone,
        bio: bio,
        email: email,
        coverPic: coverImage,
        profilePic: profileImage);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      getMyData();
      emit(UpdateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserErrorState());
    });
  }
  void resetPassword({
    required String email,
  })
  {
    emit(ResetPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    ).then((value) {
      emit(ResetPasswordSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ResetPasswordErrorState());
    });
  }

  void signOut(context) {
    emit(SignOutLoadingState());
    FirebaseAuth.instance.signOut().then((value) async {
      CacheHelper.removeData('uId');
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) async {
          if (element.id == model!.uID)
            element.reference.update({'token': null});
        });
      });
      navigateAndKill(context, LoginScreen());
      emit(SignOutSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SignOutErrorState());
    });
  }

  void deleteAccount(context) async{
    await FirebaseAuth.instance.currentUser!.delete()
        .then((value) async {
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseFirestore.instance.collection('users').doc(uId!).delete();
      CacheHelper.removeData('uId');
      navigateAndKill(context, LoginScreen());
            });
  }

  void popPostImage() {
    postImage = null;
    emit(DeletePostPicState());
  }

  File? postImage;

  Future getPostImage() async {
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(GetPostPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetPostPicErrorState());
    }
  }

  String? postPic;

  void uploadPostPic(String? name, String? profilePicture, String? postText,
      String? date, String? time) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(postImage!.path).pathSegments.last)
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(
            name: name,
            profileImage: profilePicture,
            postImage: value,
            postText: postText,
            time: time,
            date: date);
        emit(UploadPostPicSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UploadPostPicErrorState());
      });
      emit(UploadPostPicSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UploadPostPicErrorState());
    });
  }

  void createNewPost(
      {String? name,
      String? profileImage,
      String? postText,
      String? postImage,
      String? date,
      String? time}) {
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
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreatePostErrorState());
    });
  }

  Future<bool> likedByMe ({
    context,
    String? postId,
    PostModel? postModel,
    UserModel? postUser
}) async{
    emit(LikedByMeCheckedLoadingState());
    bool isLikedByMe = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((event) async {
        var likes = await event.reference.collection('likes').get();
        likes.docs.forEach((element) {
          if(element.id == model!.uID) {
          isLikedByMe = true;
          disLikePost(postId);
        }
      });
        if(isLikedByMe == false)
          likePost(
              postId : postId,
            context: context,
            postModel: postModel,
            postUser: postUser
          );
       print(isLikedByMe);
      emit(LikedByMeCheckedSuccessState());
    });
    return isLikedByMe;
  }

  List<PostModel> posts = [];
  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts = [];
      event.docs.forEach((element) async{
        posts.add(PostModel.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('posts').doc(element.id)
            .update({
          'likes' : likes.docs.length,
          'comments' : comments.docs.length,
          'postId' : element.id,
        });
      });
      emit(GetPostSuccessState());
    });
  }

  List<PostModel>? userPosts = [];

  void getUserPosts(String? userId) {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      userPosts = [];
      event.docs.forEach((element) {
        if (element.data()['uId'] == userId) {
          userPosts?.add(PostModel.fromJson(element.data()));
        }
      });
      emit(GetUserPostSuccessState());
    });
  }

  PostModel? singlePost;
  void getSinglePost(String? postId){
    emit(GetPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
          singlePost = PostModel.fromJson(value.data());
          emit(GetSinglePostSuccessState());
    }).catchError((error){
      emit(GetPostErrorState());
    });
  }

  void deletePost(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      showToast('Post Deleted');
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
  }) {
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
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(updatedPostModel.toMap())
        .then((value) {
      emit(UpdatePostSuccessState());
    }).catchError((error) {
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
  }) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(postImage!.path).pathSegments.last)
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
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
        );
        emit(UploadPostPicSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UploadPostPicErrorState());
      });
      emit(UploadPostPicSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UploadPostPicErrorState());
    });
  }

  void likePost({
    context,
    String? postId,
    PostModel? postModel,
    UserModel? postUser
  }) {
    LikesModel likesModel = LikesModel(
        uId: model!.uID,
        name: model!.name,
        profilePicture: model!.profilePic,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uID)
        .set(likesModel.toMap())
        .then((value) {
          getPosts();
          if(postModel!.uId != model!.uID) {
            SocialCubit.get(context).sendInAppNotification(
                receiverName: postModel.name,
                receiverId: postModel.uId,
                contentId: postModel.postId,
                contentKey: 'likePost'
            );
            SocialCubit.get(context).sendFCMNotification(
              token: postUser!.token,
              senderName: SocialCubit.get(context).model!.name,
              messageText: '${SocialCubit.get(context).model!.name}' + ' likes a post you shared',
            );
          }
      emit(LikePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LikePostErrorState());
    });
  }

  void disLikePost(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uID)
        .delete()
        .then((value) {
        getPosts();
      emit(DisLikePostSuccessState());
    }).catchError((error) {
      emit(DisLikePostErrorState());
      print(error.toString());
    });
  }

  List<LikesModel> peopleReacted = [];

  void getLikes(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .listen((value) {
      peopleReacted = [];
      value.docs.forEach((element) {
        peopleReacted.add(LikesModel.fromJson(element.data()));
      });
      emit(GetLikesSuccessState());
    });
  }

  File? commentImage;
  int? commentImageWidth;
  int? commentImageHeight;
  Future getCommentImage() async {
    emit(UpdatePostLoadingState());
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    print('Selecting Image...');
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      print('Image Selected');
      emit(GetCommentPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCommentPicErrorState());
    }
  }

  void popCommentImage() {
    commentImage = null;
    emit(DeleteCommentPicState());
  }

  String? commentImageURL;
  bool isCommentImageLoading = false;

  void uploadCommentPic({
    required String? postId,
    String? commentText,
    required String? time,
  }) {
    isCommentImageLoading = true;
    emit(UploadCommentPicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(commentImage!.path).pathSegments.last)
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        commentImageURL = value;
        commentPost(
            postId: postId,
            comment: commentText,
            commentImage: {
              'width' : commentImageWidth,
              'image' : value,
              'height': commentImageHeight
            },
            time: time);
        emit(UploadCommentPicSuccessState());
        isCommentImageLoading = false;
      }).catchError((error) {
        print('Error While getDownload CommentImageURL ' + error);
        emit(UploadCommentPicErrorState());
      });
    }).catchError((error) {
      print('Error While putting the File ' + error);
      emit(UploadCommentPicErrorState());
    });
  }

  void commentPost({
    required String? postId,
    String? comment,
    Map<String,dynamic>? commentImage,
    required String? time,
  }) {
    CommentModel commentModel = CommentModel(
        name: model!.name,
        profilePicture: model!.profilePic,
        commentText: comment,
        commentImage: commentImage,
        time: time,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
      getPosts();
      emit(CommentPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CommentPostErrorState());
    });
  }

  List<CommentModel> comments = [];

  void getComments(postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
        emit(GetCommentsSuccessState());
      });
    });
  }

  File? profileImage;
  ImagePicker? picker = ImagePicker();

  Future? getProfileImage() async {
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetProfilePicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetProfilePicErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(GetCoverPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCoverPicErrorState());
    }
  }

  String? profilePicURL;

  void uploadProfilePic(
    String? name,
    String? phone,
    String? bio,
    String? email,
    String? coverImage,
  ) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(profileImage!.path).pathSegments.last)
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(
            name: name,
            phone: phone,
            bio: bio,
            coverImage: coverImage,
            profileImage: value);
        emit(UploadProfilePicSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UploadProfilePicErrorState());
      });
      emit(UploadProfilePicSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UploadProfilePicErrorState());
    });
  }

  String? coverPic;

  void uploadCoverPic(String? name, String? phone, String? bio, String? email,
      String? profile) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(coverImage!.path).pathSegments.last)
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          email: email,
          profileImage: profile,
          coverImage: value,
        );
        emit(UploadCoverPicSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UploadCoverPicErrorState());
      });
      emit(UploadCoverPicSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UploadCoverPicErrorState());
    });
  }

  void sendMessage({
    required messageId,
    required String? receiverId,
    String? messageText,
    Map<String,dynamic>? messageImage,
    required String? date,
    required String? time,
  }) {
    MessageModel messageModel = MessageModel(
        messageId: messageId,
        senderId: model!.uID,
        receiverId: receiverId,
        messageText: messageText,
        messageImage: messageImage,
        date: date,
        time: time,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) async {
      emit(SendMessageSuccessState());
    }).catchError((error) {
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
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorState());
    });
  }

  File? messageImage;
  int? messageImageWidth;
  int? messageImageHeight;
  Future getMessageImage() async {
    final pickedFile = await picker?.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      var decodedImage = await decodeImageFromList(messageImage!.readAsBytesSync());
      messageImageHeight = decodedImage.height;
      messageImageWidth = decodedImage.width;
      print('$messageImageHeight' + ' height');
      print('$messageImageWidth' + ' Width');
      emit(GetMessagePicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetMessagePicErrorState());
    }
  }

  void popMessageImage() {
    messageImage = null;
    emit(DeleteMessagePicState());
  }

  String? imageURL;
  bool isLoading = false;

  void uploadMessagePic({
    required messageId,
    required String? receiverId,
    String? messageText,
    required String? date,
    required String? time,
  }) {
    isLoading = true;
    emit(UploadMessagePicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(messageImage!.path).pathSegments.last)
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        imageURL = value;
        sendMessage(
            messageId:messageId ,
            receiverId: receiverId,
            messageText: messageText,
            messageImage: {
              'width' : messageImageWidth,
              'image' : value,
              'height': messageImageHeight
            },
            date: date,
            time: time);
        emit(UploadMessagePicSuccessState());
        isLoading = false;
      }).catchError((error) {
        print('Error While getDownloadURL ' + error);
        emit(UploadMessagePicErrorState());
      });
    }).catchError((error) {
      print('Error While putting the File ' + error);
      emit(UploadMessagePicErrorState());
    });
  }

  void setRecentMessage({
    required String? receiverName,
    required String? receiverId,
    String? recentMessageText,
    String? recentMessageImage,
    required String? receiverProfilePic,
    required String? time,
  }) {
    RecentMessagesModel recentMessagesModel = RecentMessagesModel(
        senderId: model!.uID,
        senderName: model!.name,
        senderProfilePic: model!.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverProfilePic: receiverProfilePic,
        recentMessageText: recentMessageText,
        recentMessageImage: recentMessageImage,
        read: false,
        time: time,
        dateTime: FieldValue.serverTimestamp());
    RecentMessagesModel myRecentMessagesModel = RecentMessagesModel(
        senderId: model!.uID,
        senderName: model!.name,
        senderProfilePic: model!.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverProfilePic: receiverProfilePic,
        recentMessageText: recentMessageText,
        recentMessageImage: recentMessageImage,
        read: true,
        time: time,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('recentMsg')
        .doc(receiverId)
        .set(myRecentMessagesModel.toMap())
        .then((value) {
      emit(SetRecentMessageSuccessState());
    }).catchError((error) {
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
    }).catchError((error) {
      print(error.toString());
      emit(SetRecentMessageErrorState());
    });
  }

  void deleteForEveryone({
    required String? messageId,
    required String? receiverId
  }) async {
     var myDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId).get();
     myDocument.docs[0].reference.delete();

     var hisDocument = await FirebaseFirestore.instance
         .collection('users')
         .doc(receiverId)
         .collection('chats')
         .doc(model!.uID)
         .collection('message')
         .limit(1)
         .where('messageId', isEqualTo: messageId).get();
     hisDocument.docs[0].reference.delete();
    }

  void deleteForMe({
    required String? messageId,
    required String? receiverId
  }) async {
    var myDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId).get();
    myDocument.docs[0].reference.delete();
  }


  List<MessageModel> chat = [];
  void getChat(String? receiverId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(model!.uID)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      chat = [];
      event.docs.forEach((element) {
        chat.add(MessageModel.fromJson(element.data()));
      });
      emit(GetChatSuccessState());
    });
  }

  List<RecentMessagesModel> recentMessages = [];

  void getRecentMessages() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(model!.uID)
        .collection('recentMsg')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      recentMessages = [];
      event.docs.forEach((element) {
        recentMessages.add(RecentMessagesModel.fromJson(element.data()));
      });
      emit(GetRecentMsgSuccessState());
    });
  }

  Future readRecentMessage(String? recentMessageId) async{
    await FirebaseFirestore.instance.collection('users')
        .doc(model!.uID)
        .collection('recentMsg')
        .doc(recentMessageId)
        .update({'read' : true}).then((value) {
      emit(ReadNotificationSuccessState());
    });
  }

  int unReadRecentMessagesCount = 0;
  Future<int> getUnReadRecentMessagesCount() async{
    FirebaseFirestore.instance.collection('users')
        .doc(model!.uID)
        .collection('recentMsg')
        .snapshots()
    .listen((event) {
      unReadRecentMessagesCount = 0;
      for(int i = 0; i < event.docs.length; i++)
      {
        if(event.docs[i]['read'] == false)
          unReadRecentMessagesCount++;
      }
      emit(ReadNotificationSuccessState());
      print("UnRead: " + '$unReadRecentMessagesCount');
    });
    return unReadRecentMessagesCount;
  }

  void sendFCMNotification({
    required String? token,
    required String? senderName,
    String? messageText,
    String? messageImage,
  }) {
    DioHelper.postData(
        data: {
          "to": "$token",
          "notification": {
            "title": "$senderName",
            "body":
            "${messageText != null ? messageText : messageImage != null ? 'Photo' : 'ERROR 404'}",
            "sound": "default"
          },
          "android": {
            "Priority": "HIGH",
          },
          "data": {
            "type": "order",
            "id": "87",
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }
        });
    emit(SendMessageSuccessState());
  }

  void sendInAppNotification({
    String? contentKey,
    String? contentId,
    String? content,
    String? receiverName,
    String? receiverId,
  }){
    emit(SendInAppNotificationLoadingState());
    NotificationModel notificationModel = NotificationModel(
      contentKey:contentKey,
      contentId:contentId,
      content:content,
      senderName: model!.name,
      receiverName:receiverName,
      senderId:model!.uID,
      receiverId:receiverId,
      senderProfilePicture:model!.profilePic,
      read: false,
      dateTime: Timestamp.now(),
      serverTimeStamp:FieldValue.serverTimestamp(),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('notifications')
        .add(notificationModel.toMap()).then((value) async{
      await setNotificationId();
      emit(SendInAppNotificationLoadingState());
    }).catchError((error) {
      emit(SendInAppNotificationLoadingState());
    });
  }

  List<NotificationModel> notifications = [];
  void getInAppNotification() async{
    emit(GetInAppNotificationLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uID)
        .collection('notifications')
        .orderBy('serverTimeStamp',descending: true)
        .snapshots()
        .listen((event) async {
      notifications = [];
      event.docs.forEach((element) async {
        notifications.add(NotificationModel.fromJson(element.data()));
      });
      emit(GetInAppNotificationSuccessState());
    });
  }

  int unReadNotificationsCount = 0;
  Future<int> getUnReadNotificationsCount() async{
    FirebaseFirestore.instance.collection('users')
        .doc(model!.uID)
        .collection('notifications')
        .snapshots()
        .listen((event) {
      unReadNotificationsCount = 0;
      for(int i = 0; i < event.docs.length; i++)
      {
        if(event.docs[i]['read'] == false)
          unReadNotificationsCount++;
      }
      emit(ReadNotificationSuccessState());
      print("UnRead: " + '$unReadNotificationsCount');
    });

    return unReadNotificationsCount;
  }

  Future setNotificationId() async{
    await FirebaseFirestore.instance.collection('users').get()
        .then((value) {
      value.docs.forEach((element) async {
        var notifications = await element.reference.collection('notifications').get();
        notifications.docs.forEach((notificationsElement) async {
          await notificationsElement.reference.update({
            'notificationId' : notificationsElement.id
          });
        });
      });
      emit(SetNotificationIdSuccessState());
    });
  }

  Future readNotification(String? notificationId) async{
    await FirebaseFirestore.instance.collection('users')
        .doc(model!.uID)
        .collection('notifications')
        .doc(notificationId)
        .update({'read' : true}).then((value) {
      emit(ReadNotificationSuccessState());
    });
  }

  void deleteNotification(String? notificationId) async{
    await FirebaseFirestore.instance.collection('users')
        .doc(model!.uID)
        .collection('notifications')
        .doc(notificationId)
        .delete().then((value) {
      emit(ReadNotificationSuccessState());
    });
  }

  String notificationContent (String? contentKey){
    if(contentKey == 'likePost')
      return LocaleKeys.likePost.tr();
    else if (contentKey == 'commentPost')
      return  LocaleKeys.commentPost.tr();
    else if (contentKey == 'friendRequestAccepted')
      return  LocaleKeys.friendRequestAccepted.tr();
    else
      return  LocaleKeys.friendRequestNotify.tr();
  }

  IconData notificationContentIcon (String? contentKey){
    if(contentKey == 'likePost')
      return IconBroken.Heart;
    else if (contentKey == 'commentPost')
      return IconBroken.Chat;
    else if (contentKey == 'friendRequestAccepted')
      return  Icons.person;
    else
      return  Icons.person;
  }


  bool isDark = false;
  String? darkModeRadio = 'Off';
  Color borderColor = Colors.grey.shade300;
  Color? textFieldColor = Colors.grey[300];
  Color? myMessageColor = Colors.blueAccent;
  Color? messageColor = Colors.grey[300];
  Color? unreadMessage = Colors.grey[300];
  Color textColor = Colors.black;
  Color backgroundColor = Colors.white;
  IconData? icon = Icons.brightness_4_outlined;

  void changeMode({fromCache}) {
    if(fromCache == null) {
      isDark = !isDark;
      //emit(ChangeModeState());
    } else {
      isDark = fromCache;
      //emit(ChangeModeState());
    }
    CacheHelper.saveData(key: 'isDark', value: isDark)
        .then((value) {
      print('cache saved');
      if(isDark)
      {
        print('dark mode');
        appMode = ThemeMode.dark;
        darkModeRadio = 'On';
        icon = Icons.brightness_7;
        textColor = Colors.white;
        backgroundColor = HexColor('#212121').withOpacity(0.8);
        textFieldColor = Colors.grey[900];
        unreadMessage = Colors.grey[800];
        borderColor = Colors.grey.shade900;
        messageColor = Colors.grey[600];
        myMessageColor = Colors.blueAccent;
        emit(ChangeModeState());
      }
      else
      {
        print('light mode');
        appMode = ThemeMode.light;
        darkModeRadio = 'Off';
        icon = Icons.brightness_4_outlined;
        backgroundColor = Colors.white;
        textColor = Colors.black;
        textFieldColor = Colors.grey[300];
        borderColor = Colors.grey.shade300  ;
        messageColor = Colors.grey[300];
        unreadMessage = Colors.grey[300];
        myMessageColor = Colors.blueAccent;
        emit(ChangeModeState());
      }
      emit(ChangeModeState());
    });
  }

  changeActiveRadio(value) {
    if(value != darkModeRadio) {
      value = darkModeRadio;
      changeMode();
    }
    emit(ChangeActiveRadio());
  }



  List<Widget> screens = [
    HomeScreen(),
    UsersScreen(),
    RecentMessages(),
    ProfileScreen(),
    NotificationScreen(),
    SettingScreen()
  ];

  int currentIndex = 0;
  changeBottomNav(index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  bool showTime = false;
  void time() {
    showTime = !showTime;
    emit(ShowTimeState());
  }
}
