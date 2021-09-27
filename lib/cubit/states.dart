abstract class SocialStates {}

///General States
class InitialState extends SocialStates{}
class ChangeModeState extends SocialStates{}
class ChangeBottomNavState extends SocialStates{}
class ChangeSuffixIconState extends SocialStates{}
class GetTokenSuccessState extends SocialStates{}
class EditPressedState extends SocialStates{}
class CloseTopSheet extends SocialStates{}
class RefreshPage extends SocialStates{}
class ShowTimeState extends SocialStates{}

///End of General states

///Login State
class LoginLoadingState extends SocialStates{}
class LoginSuccessState extends SocialStates{
  final String uId;
  LoginSuccessState(this.uId);
}
class LoginErrorState extends SocialStates{}
///End of Login State


///CreateUser State
class CreateUserLoadingState extends SocialStates{}
class CreateUserSuccessState extends SocialStates{
  final  String uId;
  CreateUserSuccessState(this.uId);
}
class CreateUserErrorState extends SocialStates{}
///End of CreateUser State

///SignUp State
class SignUpLoadingState extends SocialStates{}
class SignUpSuccessState extends SocialStates{
  final  String uId;
  SignUpSuccessState(this.uId);
}
class SignUpErrorState extends SocialStates{}
///End SignUp State

///SignOut State
class SignOutLoadingState extends SocialStates{}
class SignOutSuccessState extends SocialStates{}
class SignOutErrorState extends SocialStates{}
///End SignOut State

///Search State
class SearchLoadingState extends SocialStates{}
class SearchSuccessState extends SocialStates{}
class SearchErrorState extends SocialStates{}
///End Search State

///Home State
class HomeLoadingState extends SocialStates{}
class HomeSuccessState extends SocialStates{}
class HomeErrorState extends SocialStates{}
///End of Home State

///GetProfilePic State
class GetProfilePicSuccessState extends SocialStates {}
class GetProfilePicErrorState extends SocialStates{}
///End of GetProfilePic State

///GetCoverPic State
class GetCoverPicSuccessState extends SocialStates {}
class GetCoverPicErrorState extends SocialStates{}
///End of GetCoverPic State

///GetPostPic State
class GetPostPicSuccessState extends SocialStates {}
class GetPostPicErrorState extends SocialStates{}
class DeletePostPicState extends SocialStates {}
///End of GetPostPic State

///UploadProfilePic State
class UploadProfilePicSuccessState extends SocialStates {}
class UploadProfilePicErrorState extends SocialStates{}
///End of UploadProfilePic State

///UploadCoverPic State
class UploadCoverPicSuccessState extends SocialStates {}
class UploadCoverPicErrorState extends SocialStates{}
///End of UploadCoverPic State

///UploadPostPic State
class UploadPostPicSuccessState extends SocialStates {}
class UploadPostPicErrorState extends SocialStates{}
///End of UploadPostPic State

///User State
class UserLoadingState extends SocialStates{}
class UserSuccessState extends SocialStates {}
class UserErrorState extends SocialStates{}
///End of User State

///GetAllUsers State
class GetAllUsersLoadingState extends SocialStates{}
class GetAllUsersSuccessState extends SocialStates {}
class GetAllUsersErrorState extends SocialStates{}
///End of GetAllUsers State

///GetFriendProfile State
class GetFriendProfileLoadingState extends SocialStates{}
class GetFriendProfileSuccessState extends SocialStates {}
class GetFriendProfileErrorState extends SocialStates{}
///End of GetFriendProfile State

///AddFriend State
class AddFriendLoadingState extends SocialStates{}
class AddFriendSuccessState extends SocialStates {}
class AddFriendErrorState extends SocialStates{}
///End of AddFriend State

///FriendRequest State
class FriendRequestLoadingState extends SocialStates{}
class FriendRequestSuccessState extends SocialStates {}
class FriendRequestErrorState extends SocialStates{}
///End of Friend State

///UnFriend State
class UnFriendLoadingState extends SocialStates{}
class UnFriendSuccessState extends SocialStates {}
class UnFriendErrorState extends SocialStates{}
///End of UnFriend State

///DeleteFriendRequest State
class DeleteFriendRequestLoadingState extends SocialStates{}
class DeleteFriendRequestSuccessState extends SocialStates {}
class DeleteFriendRequestErrorState extends SocialStates{}
///End of DeleteFriendRequest State

///GetFriend State
class GetFriendLoadingState extends SocialStates{}
class GetFriendSuccessState extends SocialStates {}
class GetFriendErrorState extends SocialStates{}
class CheckFriendState extends SocialStates{}
///End of GetFriend State

///GetFriendRequest State
class GetFriendRequestLoadingState extends SocialStates{}
class GetFriendRequestSuccessState extends SocialStates {}
class GetFriendRequestErrorState extends SocialStates{}
class CheckFriendRequestState extends SocialStates{}
///End of GetFriendRequest State

///Update User State
class UpdateUserLoadingState extends SocialStates{}
class UpdateUserSuccessState extends SocialStates {}
class UpdateUserErrorState extends SocialStates{}
///End of Update User State

///CreatePost State
class CreatePostLoadingState extends SocialStates{}
class CreatePostSuccessState extends SocialStates {}
class CreatePostErrorState extends SocialStates{}
///End of CreatePost State

///UpdatePost State
class UpdatePostLoadingState extends SocialStates{}
class UpdatePostSuccessState extends SocialStates {}
class UpdatePostErrorState extends SocialStates{}
///End of UpdatePost State

///DeletePost State
class DeletePostSuccessState extends SocialStates{}

///GetPost State
class GetPostLoadingState extends SocialStates{}
class GetPostSuccessState extends SocialStates {}
class GetPostErrorState extends SocialStates{}
///End of GetPost State

///LikePost State
class LikePostSuccessState extends SocialStates {}
class LikePostErrorState extends SocialStates{}
///End of LikePost State

///GetComments State
class GetCommentsSuccessState extends SocialStates {}
///End of GetComments State

///GetChat State
class GetChatSuccessState extends SocialStates {}
///End of GetChat State

///GetRecentMsg State
class GetRecentMsgSuccessState extends SocialStates {}
///End of GetRecentMsg State

///SendMessage State
class SendMessageSuccessState extends SocialStates {}
class SendMessageErrorState extends SocialStates{}
///End of SendMessage State

///SetRecentMessage State
class SetRecentMessageSuccessState extends SocialStates {}
class SetRecentMessageErrorState extends SocialStates{}
///End of SetRecentMessage State

///CommentPost State
class CommentPostSuccessState extends SocialStates {}
class CommentPostErrorState extends SocialStates{}
///End of CommentPost State

///DisLikePost State
class DisLikePostSuccessState extends SocialStates {}
class DisLikePostErrorState extends SocialStates{}
///End of DisLikePost State

///LikePressed State
class LikePressedSuccessState extends SocialStates {}
class GetLikesSuccessState extends SocialStates {}
///End of LikePressed State

///ChangePassword State
class ChangePassLoadingState extends SocialStates{}
class ChangePassSuccessState extends SocialStates {}
class ChangePassErrorState extends SocialStates{}
///End of ChangePassword State

