import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation/utiles/context_extention.dart';

import '../../constant/constant.dart';
import '../../controller/new_pass_api_controller.dart';
import '../../models/api_response.dart';
import '../../utiles/helpers.dart';
import '../../widget/customPrimaryButton.dart';
import '../../widget/custom_text_filed.dart';
import '../../widget/loading_custom_button.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);
  static const id = 'NewPassword';

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> with Helpers {
  late TextEditingController _pass;

  late TextEditingController _confirmpass;
  late TextEditingController _oldpass;
  bool _passobsecure = true;
  bool _oldpassobsecure = true;
  bool _copassobsecure = true;
  String? _NewErorr;
  String? _ConfNewErorr;
  String? _oldErorr;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pass = TextEditingController();

    _confirmpass = TextEditingController();
    _oldpass = TextEditingController();
  }

  bool agree = false;

  @override
  void dispose() {
    _pass.dispose();
    _oldpass.dispose();
    _confirmpass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ListView(
          children: [
            SizedBox(
              height: 24.h,
            ),
            //create new pass
            Text(
              AppLocalizations.of(context)!.create_new,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 24.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            //sub title
            Center(
              child: Text(
                AppLocalizations.of(context)!.create_new_sub_title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            //old pass
            Text(
              AppLocalizations.of(context)!.old_pass,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            CustomTextFiled(
              controller: _oldpass,
              type: TextInputType.text,
              errorText: _oldErorr,
              hint: '● ● ● ● ● ●',
              prefixIcon: const Icon(
                Icons.lock_outlined,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _oldpassobsecure = !_oldpassobsecure;
                  });
                },
                icon: Icon(
                    _oldpassobsecure ? Icons.visibility_off : Icons.visibility),
                color: Color(0xffb4b4b4),
              ),
              obscureText: _oldpassobsecure,
            ),
            SizedBox(
              height: 24.h,
            ),
            //new
            Text(
              AppLocalizations.of(context)!.new_pass,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            CustomTextFiled(
              hint: '● ● ● ● ● ●',
              controller: _pass,
              type: TextInputType.text,
              errorText: _NewErorr,
              prefixIcon: const Icon(
                Icons.lock_outlined,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passobsecure = !_passobsecure;
                  });
                },
                icon: Icon(
                    _passobsecure ? Icons.visibility_off : Icons.visibility),
                color: Color(0xffb4b4b4),
              ),
              obscureText: _passobsecure,
            ),
            SizedBox(
              height: 24.h,
            ),
            //confirm
            Text(
              AppLocalizations.of(context)!.confirm_new,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            CustomTextFiled(
              hint: '● ● ● ● ● ●',
              controller: _confirmpass,
              type: TextInputType.text,
              errorText: _ConfNewErorr,
              prefixIcon: const Icon(
                Icons.lock_outlined,
                color: Color(0xffb4b4b4),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _copassobsecure = !_copassobsecure;
                  });
                },
                icon: Icon(
                    _copassobsecure ? Icons.visibility_off : Icons.visibility),
                color: Color(0xffb4b4b4),
              ),
              obscureText: _copassobsecure,
            ),
            SizedBox(
              height: 24.h,
            ),
            loading
                ? loadingCustomButton()
                : CustomPrimaryButton(
                    text: AppLocalizations.of(context)!.submit,
                    onPressed: () {
                      performSubmit();
                    }),
            SizedBox(
              height: 66.h,
            ),
          ],
        ),
      ),
    );
  }

  void performSubmit() {
    if (checkData()) {
      setState(() {
        loading = true;
      });
      login();
    }
  }

  bool checkData() {
    if (_confirmpass.text.isNotEmpty && _pass.text.isNotEmpty) {
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
        _ConfNewErorr = _confirmpass.text.isEmpty
            ? AppLocalizations.of(context)!.enter_pass
            : null;
        _NewErorr = _pass.text.isEmpty
            ? AppLocalizations.of(context)!.enter_pass
            : null;
        _oldErorr = _oldpass.text.isEmpty
            ? AppLocalizations.of(context)!.enter_pass
            : null;
        if (_pass.text != _confirmpass.text) {
          _NewErorr = AppLocalizations.of(context)!.not_match;
          _ConfNewErorr = AppLocalizations.of(context)!.not_match;
        }
        if (_oldpass.text == _pass.text) {
          showSnackBar(context,
              message: AppLocalizations.of(context)!.create_new_sub_title,
              erorr: true);
        }
      },
    );
  }

  void login() async {
    ApiResponse processResponse = await NewPassApiController().NewPass(
        old: _oldpass.text, newPass: _pass.text, confirmNew: _confirmpass.text);
    if (processResponse.sucess) {
      Navigator.pop(context);
    }
    context.showSnakBar(
      message: processResponse.msg,
      error: !processResponse.sucess,
    );
  }
}
