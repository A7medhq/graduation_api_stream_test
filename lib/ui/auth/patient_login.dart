import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graduation/constant/constant.dart';
import 'package:graduation/controller/patient_auth_api_controller.dart';
import 'package:graduation/models/LogedUser.dart';
import 'package:graduation/models/blood.dart';
import 'package:graduation/ui/auth/patient_sign_up.dart';
import 'package:graduation/utiles/context_extention.dart';
import 'package:provider/provider.dart';

import '../../models/api_response.dart';
import '../../provider/localization_provider.dart';
import '../../utiles/helpers.dart';
import '../../widget/customPrimaryButton.dart';
import '../../widget/custom_text_filed.dart';
import '../../widget/loading_custom_button.dart';
import '../../widget/mobile_text_filed.dart';
import '../../widget/social.dart';
import '../patient/PatientBtn/btn_patient.dart';
import 'doc_signup.dart';
import 'forget_pass.dart';

class PatientLoginPage extends StatefulWidget {
  PatientLoginPage({Key? key, this.data}) : super(key: key);
  static const id = 'PatientLoginPage';
  int? data;
  @override
  State<PatientLoginPage> createState() => _PatientLoginPageState(data);
}

class _PatientLoginPageState extends State<PatientLoginPage> with Helpers {
  GlobalKey<FormState> _formKey = GlobalKey();
  int? data;
  _PatientLoginPageState(this.data);
  late TapGestureRecognizer _tapGestureRecognizer;
  late TextEditingController _mobile;
  late TextEditingController _pass;
  bool loading = false;

  String? _EmailErorr;
  String? _passwordErorr;
  bool _obsecure = true;
  late TextEditingController _email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mobile = TextEditingController();
    _pass = TextEditingController();
    _email = TextEditingController();

    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = createNewAccountAction;
  }

  @override
  void dispose() {
    _mobile.dispose();
    _pass.dispose();
    _email.dispose();

    super.dispose();
  }

  void createNewAccountAction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(arguments: 2),
        builder: (context) => PatientSignUp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as int;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.login,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: FadeInLeft(
            child: ListView(
              key: _formKey,
              children: [
                Text(
                  AppLocalizations.of(context)!.email,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomTextFiled(
                  hint: 'email@example.com',
                  errorText: _EmailErorr,
                  controller: _email,
                  type: TextInputType.text,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  AppLocalizations.of(context)!.password,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomTextFiled(
                  controller: _pass,
                  type: TextInputType.text,
                  errorText: _passwordErorr,
                  hint: '● ● ● ● ● ●',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obsecure = !_obsecure;
                      });
                    },
                    icon: Icon(
                        _obsecure ? Icons.visibility_off : Icons.visibility),
                    color: Color(0xffb4b4b4),
                  ),
                  obscureText: _obsecure,
                ),
                Align(
                  alignment:
                      Provider.of<LocalizationProvider>(context, listen: true)
                                  .languages ==
                              'en'
                          ? Alignment.topRight
                          : Alignment.topLeft,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: RouteSettings(arguments: 2),
                            builder: (context) => ForgotScreen(data: 2),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgot,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Constant.primaryColor,
                        ),
                      )),
                ),
                SizedBox(
                  height: 16.h,
                ),
                loading
                    ? loadingCustomButton()
                    : CustomPrimaryButton(
                        text: AppLocalizations.of(context)!.login,
                        onPressed: () {
                          performLogin();
                        }),
                SizedBox(height: 8.h),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text:
                            AppLocalizations.of(context)!.dont_have_an_account,
                        style: GoogleFonts.poppins(
                            color: Colors.black87, fontSize: 16.sp),
                        children: [
                          TextSpan(text: '  '),
                          TextSpan(
                            text: AppLocalizations.of(context)!.sign_up,
                            recognizer: _tapGestureRecognizer,
                            style: GoogleFonts.poppins(
                              color: Constant.primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 75.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color(0xffD6D6D6),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.h),
                      child: Text(
                        AppLocalizations.of(context)!.or,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffB9B5B5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color(0xffD6D6D6),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 37.h,
                ),
                SocialMediaButton(
                  imgName: 'gmail',
                  text: AppLocalizations.of(context)!.gmail,
                ),
                SizedBox(
                  height: 16.h,
                ),
                SocialMediaButton(
                  imgName: 'facebook',
                  text: AppLocalizations.of(context)!.facebook,
                ),
                SizedBox(
                  height: 112.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void performLogin() {
    if (checkData()) {
      setState(() {
        loading = true;
      });
      login();
    }
  }

  bool checkData() {
    if (_email.text.isNotEmpty && _pass.text.isNotEmpty) {
      _controlErrorValue();
      return true;
    }
    _controlErrorValue();
    showSnackBar(context,
        message: AppLocalizations.of(context)!.error_message, erorr: true);

    return false;
  }

  void _controlErrorValue() {
    setState(
      () {
        _EmailErorr = _email.text.isEmpty
            ? AppLocalizations.of(context)!.enter_email
            : null;

        _passwordErorr = _pass.text.isEmpty
            ? AppLocalizations.of(context)!.enter_pass
            : null;
      },
    );
  }

  void login() async {
    ApiResponse processResponse =
        await PatientAuthApiController().PatLogin(user: user);

    if (processResponse.sucess) {
      // ignore: use_build_context_synchronously
      print('mais');

      Navigator.pushNamed(context, BtnPatient.id);
    }
    // ignore: use_build_context_synchronously
    setState(() {
      loading = false;
    });
    context.showSnakBar(
      message: processResponse.msg,
      error: !processResponse.sucess,
    );
  }

  LogedUser get user {
    LogedUser user = LogedUser();
    user.email = _email.text;
    user.password = _pass.text;

    return user;
  }
}
