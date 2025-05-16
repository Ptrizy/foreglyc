import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/datasources/local/home_preference.dart';
import 'package:foreglyc/presentation/blocs/auth/auth_bloc.dart';
import 'package:foreglyc/presentation/blocs/profile/profile_bloc.dart';
import 'package:foreglyc/presentation/widgets/loading%20copy.dart';
import 'package:foreglyc/presentation/widgets/popup_out.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Loading();
            },
          );
        } else if (state is AuthError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthSignedOut) {
          Navigator.pop(context);
          context.go(RoutePath.loginPage);
        }
      },

      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: ColorStyles.gradient1,
                ),
              ),
              Positioned(
                left: 65.5.w,
                top: 70.h,
                child: BlocBuilder<ProfileBloc, Map<String, String?>>(
                  builder: (context, profileData) {
                    final name = profileData[HomePreferences.nameKey] ?? 'null';
                    final photoUrl = profileData[HomePreferences.urlPhotoKey];
                    final level =
                        profileData[HomePreferences.levelKey] ?? 'Glu-Master';

                    return Row(
                      children: [
                        photoUrl != null && photoUrl.isNotEmpty
                            ? CircleAvatar(
                              radius: 26.r,
                              backgroundImage: NetworkImage(photoUrl),
                            )
                            : Image.asset(
                              'assets/default_profile.png',
                              width: 52.w,
                              height: 52.h,
                            ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.length > 10
                                  ? '${name.substring(0, 10)}...'
                                  : name,
                              style: TextStyles.heading2(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFD1E3FF),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🏆 $level',
                                    style: TextStyles.body3(
                                      fontSize: 12,
                                      color: ColorStyles.primary500,
                                      weight: FontWeightOption.semiBold,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  SvgPicture.asset(
                                    'assets/icons/CaretLeft.svg',
                                    width: 16.w,
                                    height: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                top: 165.h,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  width: 360.w,
                  height: 860.h,
                  padding: EdgeInsets.only(
                    top: 24.h,
                    left: 16.w,
                    right: 16.w,
                    bottom: 80.h,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                            border: Border.all(
                              width: 2.w,
                              color: Color(0xFF1976FF),
                            ),
                            color: Color(0xFFD1E3FF),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 16.h,
                              left: 16.w,
                              bottom: 16.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/AddressBook.svg',
                                  width: 24.w,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Complete Your Personal Data',
                                  style: TextStyles.body1(
                                    weight: FontWeightOption.semiBold,
                                    color: Color(0xFF1976FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text('ACCOUNT', style: TextStyles.body3()),
                        Padding(
                          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                          child: ProfileMenu(
                            assetsPath: 'assets/icons/NotePencil.svg',
                            label: 'Edit Profile',
                          ),
                        ),
                        ProfileMenu(
                          assetsPath: 'assets/icons/Lock.svg',
                          label: 'Change Password',
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
                          child: Text('GENERAL', style: TextStyles.body3()),
                        ),
                        ProfileMenu(
                          assetsPath: 'assets/icons/Question.svg',
                          label: 'Help Center',
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: ProfileMenu(
                            assetsPath: 'assets/icons/ShieldWarning.svg',
                            label: 'Security and Privacy',
                          ),
                        ),
                        ProfileMenu(
                          assetsPath: 'assets/icons/Info.svg',
                          label: 'About ForeGlyc',
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.h, bottom: 80.h),
                          child: GestureDetector(
                            onTap:
                                () => showPopupOutBottomSheet(
                                  context,
                                  title: 'Log Out Account',
                                  content:
                                      'Are you sure you want to log out from ForeGlyc?',
                                  onClicked:
                                      () => context.read<AuthBloc>().add(
                                        SignOutEvent(),
                                      ),
                                ),
                            child: const ProfileMenu(
                              assetsPath: 'assets/icons/SignOut.svg',
                              label: 'Log Out',
                              color: ColorStyles.error500,
                              borderColor: ColorStyles.error100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final String assetsPath;
  final String label;

  final Color? color;
  final Color? borderColor;
  const ProfileMenu({
    super.key,
    required this.assetsPath,
    required this.label,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Color colors = color ?? ColorStyles.black;
    Color bordersColor = borderColor ?? ColorStyles.neutral300;
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(width: 1.w, color: bordersColor),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 16.h, left: 16.w, bottom: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(assetsPath),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyles.body1(
                weight: FontWeightOption.semiBold,
                color: colors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
