import 'package:articles_app/generated/locale_keys.g.dart';
import 'package:articles_app/utils/app_colors.dart';
import 'package:articles_app/views/custom_widgets/custom_appbar.dart';
import 'package:articles_app/views/screens/account/profile_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryTextColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomappBar(
                text: LocaleKeys.account.tr(),
                showBackButton: false,
              ),
              const Profile(),
            ],
          ),
        ),
      ),
    );
  }
}
