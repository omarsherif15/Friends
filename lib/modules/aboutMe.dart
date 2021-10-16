import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class AboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Me'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Summary',style: GoogleFonts.arya(color: SocialCubit.get(context).textColor,fontSize: 40,fontWeight: FontWeight.bold),),
            Text(
                'I am a 21 years old male in the last year of computer science'
                    ' with a very good English level written and spoken, and fast learner.'
                    ' My ambition is to find a position that would challenge me and give me a chance to learn,'
                    ' expand my horizons as I grow in my career path.'
                    ' I am looking for an opportunity to learn more about mobile app development and especially flutter .'
                    ' I am really interested in this topic any opportunity will be a great bonus to my experience and my CV as well.',
            style: GoogleFonts.arya(color: SocialCubit.get(context).textColor)
            ),
            Text('Contact',style: GoogleFonts.arya(color: SocialCubit.get(context).textColor,fontSize: 40,fontWeight: FontWeight.bold),),
            Text(LocaleKeys.EmailAddress.tr(),style: GoogleFonts.arya(color: Colors.grey)),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 15.0),
              child: Text('omarsherifmetwaly@gmail.com',style: GoogleFonts.arya(color: SocialCubit.get(context).textColor,fontSize: 22)),
            ),
            Text(LocaleKeys.phoneNumber.tr(),style: GoogleFonts.arya(color: Colors.grey)),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 15.0),
              child: Text('+201010387741',style: GoogleFonts.arya(color: SocialCubit.get(context).textColor,fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }
}
