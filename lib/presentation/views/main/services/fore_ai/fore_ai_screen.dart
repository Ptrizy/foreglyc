import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/models/chat_model.dart';
import 'package:foreglyc/presentation/blocs/chat/chat_bloc.dart';
import 'package:foreglyc/presentation/blocs/chat/chat_event.dart';
import 'package:foreglyc/presentation/blocs/chat/chat_state.dart';
import 'package:foreglyc/presentation/widgets/loading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ForeAIScreen extends StatefulWidget {
  const ForeAIScreen({super.key});

  @override
  State<ForeAIScreen> createState() => _ForeAIScreenState();
}

class _ForeAIScreenState extends State<ForeAIScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatEvent());
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(
        SendMessageEvent(
          message: _messageController.text.trim(),
          file: _selectedImage,
        ),
      );
      _messageController.clear();
      setState(() {
        _selectedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 32.h),
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/arrow-left.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Fore-AI',
                      style: TextStyles.heading4(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Color(0xFFE4E4E7),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'powered by gemini',
                  style: TextStyles.body3(color: ColorStyles.neutral600),
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Loading();
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                } else {
                  List<ChatModel> messages = [];

                  if (state is ChatLoaded) {
                    messages = state.messages;
                  } else if (state is ChatSending) {
                    messages = state.currentMessages;
                  } else if (state is FileUploading) {
                    messages = state.currentMessages;
                  } else if (state is FileUploaded) {
                    messages = state.currentMessages;
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUser = message.role == 'user';

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser)
                              Container(
                                width: 48.w,
                                height: 48.w,
                                margin: EdgeInsets.only(right: 8.w),
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: ColorStyles.primary500,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/Robot.svg',
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    isUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16.r),
                                    decoration: BoxDecoration(
                                      color:
                                          isUser
                                              ? Color(0xFFF4F4F5)
                                              : Color(0xFFD1E3FF),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Text(
                                      message.message,
                                      style: TextStyles.body2(),
                                    ),
                                  ),

                                  if (message.fileUrl.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        child: Image.network(
                                          message.fileUrl,
                                          width: 200.w,
                                          height: 150.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            if (isUser)
                              Container(
                                width: 48.w,
                                height: 48.w,
                                margin: EdgeInsets.only(left: 8.w),

                                child: Image.asset(
                                  'assets/default_profile.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          if (_selectedImage != null)
            Container(
              height: 80.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Stack(
                      children: [
                        Image.file(
                          _selectedImage!,
                          width: 64.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: ColorStyles.neutral800.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 12.sp,
                                color: ColorStyles.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: ColorStyles.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorStyles.neutral300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        hintText: 'Chat with Fore-AI',
                        hintStyle: TextStyles.body1(
                          color: ColorStyles.neutral500,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      maxLines: null,
                      onSubmitted: (value) {
                        _sendMessage();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/mic_ai.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                SizedBox(width: 8.w),

                InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/camera_ai.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
