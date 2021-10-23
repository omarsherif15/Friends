import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/modules/friendsProfileScreen.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class SearchScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        //List<UserModel> searchList = SocialCubit.get(context).searchList;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 60,
            title: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 20,
                child: TextFormField(
                  controller: searchController,
                  style: TextStyle(color: SocialCubit.get(context).textColor),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  onFieldSubmitted: (value) {
                    SocialCubit.get(context).searchUser(value);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: SocialCubit.get(context).textFieldColor,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    hintText: LocaleKeys.search.tr(),
                    hintStyle: TextStyle(fontSize: 15,color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Conditional.single(
            context: context,
            conditionBuilder:(context) => SocialCubit.get(context).search != null,
              widgetBuilder:(context) => chatBuildItem(context, SocialCubit.get(context).search),
            fallbackBuilder: (context) => Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_outlined,size: 60,color: Colors.grey,),
                  SizedBox(height: 30,),
                  Text(LocaleKeys.NoSearchResults.tr(),style: TextStyle(fontSize: 25,color: SocialCubit.get(context).textColor),)
                ],
              ),
            )
          ),
          // body: ListView.separated(
          //   physics: BouncingScrollPhysics(),
          //   itemBuilder: (context,index) =>chatBuildItem(context,SocialCubit.get(context).search![index]) ,
          //   separatorBuilder:(context,index) => myDivider(),
          //   itemCount: 1
          // )
        );
      },
    );
  }

  Widget chatBuildItem(context, Map<String, dynamic>? userModel) {
    return InkWell(
      onTap: () {
        navigateTo(context, FriendsProfileScreen(userModel!['uId']));
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('${userModel!['profilePic']}'),
              radius: 27,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${userModel['name']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: SocialCubit.get(context).textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
