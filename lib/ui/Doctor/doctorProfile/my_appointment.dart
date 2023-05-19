import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constant/constant.dart';
import '../../../widget/search_bar.dart';
import '../../../widget/viewProfileButton.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({Key? key}) : super(key: key);
  static const id = 'MyAppointments';

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  late TextEditingController _searchController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          AppLocalizations.of(context)!.appointments,
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 39.h),
            child: SearchBarWidget(
                type: TextInputType.text,
                controller: _searchController,
                hint: AppLocalizations.of(context)!.search_patient,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
          ),
          SizedBox(
            height: 8.h,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                child: Container(
                  height: 176.h,
                  width: 375.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300, width: .5),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 21.w, bottom: 38.h, top: 21.h, right: 0.w),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3yzFkTNxyZB4QJgRQOmk66iKQr969vG-cWg&usqp=CAU',
                              height: 120.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 18.w, bottom: 16.h, top: 16.h, right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Richard Wilson',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.access_time_outlined,
                                      color: Color(0xff757575),
                                      size: 12,
                                    ),
                                    Text(
                                      ' 14 Nov 2019, 10.00 AM',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Color(0xff757575),
                                      size: 12,
                                    ),
                                    Text(
                                      ' Newyork, United States',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: Color(0xff757575),
                                      size: 12,
                                    ),
                                    Text(
                                      ' richard@example.com',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  height: 29.5.h,
                                  width: 66.w,
                                  decoration: BoxDecoration(
                                      color: Constant.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(2.r)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 13,
                                        color: Constant.primaryColor,
                                      ),
                                      Text(
                                        'View',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.sp,
                                          color: Constant.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
