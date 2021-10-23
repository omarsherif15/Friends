import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class EditProfileScreen extends StatelessWidget {

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var profileFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){},
        builder: (context,state) {
          UserModel? userModel = SocialCubit.get(context).model;
          nameController.text = userModel!.name!;
          phoneController.text = userModel.phone!;
          bioController.text = userModel.bio!;
          dynamic coverPic = SocialCubit.get(context).coverImage;
          dynamic upProfilePic = SocialCubit.get(context).profileImage;
          dynamic profilePic;
          if (upProfilePic == null)
            profilePic = NetworkImage('${userModel.profilePic}');
          else
            profilePic = FileImage(upProfilePic);


          return WillPopScope(
            onWillPop: () async {
              pop(context);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(LocaleKeys.editprofile.tr().toLowerCase()),
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                titleSpacing: 0,
                actions: [
                  TextButton(
                      onPressed: (){
                        SocialCubit.get(context).updateUserData(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                          email: userModel.email,
                          profileImage: userModel.profilePic,
                          coverImage: userModel.coverPic
                        );
                        if(state is UserSuccessState) {
                          pop(context);
                      }
                    },
                      child: Row(
                        children: [
                          Icon(Icons.save_rounded),
                          SizedBox(width: 5,),
                          Text(LocaleKeys.save.tr()),
                        ],
                      )
                  ),
                  SizedBox(width: 5,)
                ],
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: profileFormKey,
                    child: Column(
                        children:
                        [
                          if(state is UpdateUserLoadingState)
                            Column(
                              children: [
                                LinearProgressIndicator(),
                                SizedBox(height: 10,),
                              ],
                            ),
                          Container(
                            height: 250,
                            width: double.infinity,
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Align(
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      Container(
                                        height: 190,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Conditional.single(
                                            context: context,
                                            conditionBuilder: (context) =>
                                            coverPic == null,
                                            widgetBuilder: (context) => Image.network(
                                              '${userModel.coverPic}',
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              height: 190,
                                              alignment:
                                              AlignmentDirectional.topCenter,
                                            ),
                                            fallbackBuilder: (context) => Image(
                                              image: FileImage(coverPic!),
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              height: 190,
                                              alignment: AlignmentDirectional
                                                  .bottomCenter,
                                            )),
                                        alignment: AlignmentDirectional.topCenter,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(
                                            bottom: 10, end: 10),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[300],
                                          child: IconButton(
                                              onPressed: () {
                                                SocialCubit.get(context)
                                                    .getCoverImage()
                                                    .then((value) {
                                                  SocialCubit.get(context)
                                                      .uploadCoverPic(
                                                    userModel.name,
                                                    userModel.phone,
                                                    userModel.bio,
                                                    userModel.email,
                                                    userModel.profilePic,
                                                  );
                                                });
                                              },
                                              icon: Icon(IconBroken.Camera)),
                                        ),
                                      )
                                    ],
                                  ),
                                  alignment: AlignmentDirectional.topCenter,
                                ),
                                Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: SocialCubit.get(context).backgroundColor,
                                        radius: 75,
                                        child: CircleAvatar(
                                            radius: 70,
                                            backgroundImage: profilePic)),
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      child: IconButton(
                                          onPressed: () {
                                            SocialCubit.get(context)
                                                .getProfileImage()!
                                                .then((value) {
                                              SocialCubit.get(context)
                                                  .uploadProfilePic(
                                                userModel.name,
                                                userModel.phone,
                                                userModel.bio,
                                                userModel.email,
                                                userModel.coverPic,
                                              );
                                            });
                                          },
                                          icon: Icon(IconBroken.Camera)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          defaultFormField(
                            context: context,
                            controller:nameController ,
                            keyboardType: TextInputType.text,
                            labelText: LocaleKeys.userName.tr(),
                            prefix: Icons.person,
                            validate: (value)
                            {
                            if(value!.isEmpty)
                            return 'Email Address must be filled';
                            }
                          ),
                          SizedBox(height: 20),
                          defaultFormField(
                            context: context,
                            controller: phoneController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: LocaleKeys.phoneNumber.tr(),
                            prefix: Icons.phone,
                            validate: (value)
                            {
                            if(value!.isEmpty)
                            return 'Email Address must be filled';
                            }
                      ),
                      SizedBox(height: 20),
                      defaultFormField(
                        context: context,
                        controller: bioController,
                        keyboardType: TextInputType.text,
                        labelText: LocaleKeys.bio.tr(),
                        prefix: Icons.notes ,
                        validate: (value)
                        {
                        if(value!.isEmpty)
                        return 'Email Address must be filled';
                        }
                        ),
            ]
            )
            ),
                ),
              ),
            ),
          );
      },
    );
  }
}
