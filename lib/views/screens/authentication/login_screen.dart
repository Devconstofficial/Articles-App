import 'package:articles_app/custom_navbar.dart';
import 'package:articles_app/firebase/user_methods.dart';
import 'package:articles_app/generated/locale_keys.g.dart';
import 'package:articles_app/providers/user.dart';
import 'package:articles_app/utils/app_colors.dart';
import 'package:articles_app/utils/app_images.dart';
import 'package:articles_app/utils/app_strings.dart';
import 'package:articles_app/views/custom_widgets/custom_button.dart';
import 'package:articles_app/views/custom_widgets/customtextfield.dart';
import 'package:articles_app/views/screens/authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../models/user.dart';
import '../../custom_widgets/my_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool signInSuccess = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  bool _validateFields() {
    return (_validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Future<void> signIn() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (userCredential.user != null) {
          setState(() {
            signInSuccess = true;
          });
          LocalUser? user =
              await UserMethods().getUserByEmail(_emailController.text);
          if (user != null) {
            String id = user.id;
            userProvider.setEmail(_emailController.text);
            userProvider.setId(id);
            userProvider.setName(user.name);
            userProvider.setProfile(user.profile);
            userProvider.setLoggedIn(true);
          }
        }
        SnackBarHelper.showSnackbar(context, LocaleKeys.signInSuccess.tr());
      } catch (e) {
        print("Sign in failed $e");
        SnackBarHelper.showSnackbar(context, LocaleKeys.signInFail.tr());
      }
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 430.w,
              height: 323.h,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [kGradientColor1, kGradientColor2],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 62.h,
                  ),
                  Image.asset(kAppLogo),
                  SizedBox(
                    height: 34.h,
                  ),
                  Text(
                    LocaleKeys.signIn.tr(),
                    style: TextStyle(
                      color: kPrimaryTextColor,
                      fontSize: 24.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 91.h,
            ),
            CustomTextField(
              label: LocaleKeys.email.tr(),
              controller: _emailController,
            ),
            SizedBox(
              height: 26.h,
            ),
            CustomTextField(
              label: LocaleKeys.password.tr(),
              controller: _passwordController,
              isPassword: true,
            ),
            SizedBox(
              height: 160.h,
            ),
            InkWell(
                onTap: () async {
                  if (_validateFields()) {
                    await signIn();
                    if (signInSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomNavBar(),
                        ),
                      );
                    }
                  } else {
                    SnackBarHelper.showSnackbar(
                        context, LocaleKeys.signInFail.tr());
                  }
                },
                child: CustomButton(
                  text: LocaleKeys.signIn.tr().toUpperCase(),
                )),
            SizedBox(
              height: 19.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.haveAccount.tr(),
                  style: TextStyle(
                    color: kHintTextColor,
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    LocaleKeys.signUp.tr(),
                    style: TextStyle(
                      color: kPrimaryMainColor,
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
