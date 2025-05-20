// blood_sugar_prediction_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/models/chat_model.dart';
import 'package:foreglyc/data/models/home_model.dart';
import 'package:foreglyc/presentation/blocs/chat/chat_bloc.dart';
import 'package:foreglyc/presentation/blocs/chat/chat_event.dart';
import 'package:foreglyc/presentation/blocs/chat/chat_state.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class BloodSugarPredictionScreen extends StatefulWidget {
  final List<GlucoseMonitoringGraph> glucoseData;

  const BloodSugarPredictionScreen({super.key, required this.glucoseData});

  @override
  State<BloodSugarPredictionScreen> createState() =>
      _BloodSugarPredictionScreenState();
}

class _BloodSugarPredictionScreenState
    extends State<BloodSugarPredictionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetGlucosePredictionEvent());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBloodSugarChart(
    List<GlucoseMonitoringGraph> glucoseData,
    List<Scenario>? scenarios,
  ) {
    if (glucoseData.isEmpty) {
      return Center(child: Text('No data available'));
    }

    // Sort glucose data by time (newest first)
    glucoseData.sort((a, b) => b.label.compareTo(a.label));

    final spots =
        glucoseData
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
            .toList();

    // Prepare spots for scenario predictions if available
    List<FlSpot>? goodScenarioSpots;
    List<FlSpot>? badScenarioSpots;

    if (scenarios != null && scenarios.isNotEmpty) {
      final goodScenario = scenarios.firstWhere(
        (s) => s.type == 'goodScenario',
        orElse: () => scenarios.first,
      );

      final badScenario = scenarios.firstWhere(
        (s) => s.type == 'badScenario',
        orElse: () => scenarios.first,
      );

      final lastIndex = glucoseData.length - 1;
      final lastXValue = lastIndex.toDouble();

      goodScenarioSpots = [
        FlSpot(lastXValue, glucoseData[lastIndex].value.toDouble()),
        ...goodScenario.predictions.asMap().entries.map(
          (entry) =>
              FlSpot(lastXValue + entry.key + 1, entry.value.value.toDouble()),
        ),
      ];

      badScenarioSpots = [
        FlSpot(lastXValue, glucoseData[lastIndex].value.toDouble()),
        ...badScenario.predictions.asMap().entries.map(
          (entry) =>
              FlSpot(lastXValue + entry.key + 1, entry.value.value.toDouble()),
        ),
      ];
    }

    return LineChart(
      LineChartData(
        // [Konfigurasi grafik tetap sama seperti sebelumnya...]
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 70,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < glucoseData.length) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      glucoseData[index].label,
                      style: TextStyles.body3(
                        fontSize: 11.38,
                        color: ColorStyles.neutral600,
                      ),
                    ),
                  );
                } else if (scenarios != null && scenarios.isNotEmpty) {
                  final predictionIndex = index - glucoseData.length;
                  if (predictionIndex >= 0 &&
                      predictionIndex < scenarios.first.predictions.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        scenarios.first.predictions[predictionIndex].time,
                        style: TextStyles.body3(
                          fontSize: 11.38,
                          color: ColorStyles.neutral600,
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 70,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyles.body3(
                    fontSize: 9.5,
                    color: ColorStyles.neutral600,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX:
            (glucoseData.length +
                    (scenarios?.isNotEmpty == true
                        ? scenarios!.first.predictions.length
                        : 0) -
                    1)
                .toDouble(),
        minY: 0,
        maxY: 350,

        lineBarsData: [
          // Main glucose line
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: ColorStyles.primary500,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
          ),
          // Good scenario line
          if (goodScenarioSpots != null)
            LineChartBarData(
              spots: goodScenarioSpots,
              isCurved: true,
              color: ColorStyles.success500,
              barWidth: 2,
              dashArray: [5, 5],
            ),
          // Bad scenario line
          if (badScenarioSpots != null)
            LineChartBarData(
              spots: badScenarioSpots,
              isCurved: true,
              color: ColorStyles.error500,
              barWidth: 2,
              dashArray: [5, 5],
            ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                Color color;
                String label;

                if (barSpot.barIndex == 0) {
                  color = ColorStyles.primary500;
                  label = 'Current: ${barSpot.y.toInt()} mg/dL';
                } else if (barSpot.barIndex == 1) {
                  color = ColorStyles.success500;
                  label = 'Good Scenario: ${barSpot.y.toInt()} mg/dL';
                } else {
                  color = ColorStyles.error500;
                  label = 'Bad Scenario: ${barSpot.y.toInt()} mg/dL';
                }

                return LineTooltipItem(
                  label,
                  TextStyles.body3(
                    color: ColorStyles.white,
                    weight: FontWeightOption.semiBold,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '\n${_getTimeLabel(barSpot, glucoseData, scenarios)}',
                      style: TextStyles.body3(color: ColorStyles.white),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 70,
              color: Colors.red.withOpacity(0.3),
              strokeWidth: 2,
            ),
            HorizontalLine(
              y: 140,
              color: Colors.green.withOpacity(0.3),
              strokeWidth: 2,
            ),
            HorizontalLine(
              y: 210,
              color: Colors.red.withOpacity(0.3),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionSummary(List<Scenario> scenarios) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blood Sugar Level Report',
          style: TextStyles.heading4(weight: FontWeightOption.bold),
        ),
        SizedBox(height: 16.h),

        SizedBox(
          height: 200.h,
          child: _buildBloodSugarChart(widget.glucoseData, scenarios),
        ),
        SizedBox(height: 24.h),

        // Prediksi
        Text(
          'Blood Sugar',
          style: TextStyles.body1(weight: FontWeightOption.semiBold),
        ),
        SizedBox(height: 8.h),

        Column(
          children:
              scenarios
                  .map(
                    (scenario) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.type == 'goodScenario'
                              ? '🌟 Normal Prediction'
                              : '🚨 Upnormal Prediction',
                          style: TextStyles.body1(
                            weight: FontWeightOption.semiBold,
                            color: ColorStyles.primary500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(scenario.reason, style: TextStyles.body2()),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  )
                  .toList(),
        ),

        Text(
          '💡 Langkah',
          style: TextStyles.body1(
            weight: FontWeightOption.semiBold,
            color: ColorStyles.primary500,
          ),
        ),
        SizedBox(height: 8.h),
        Column(
          children:
              scenarios.first.recommendations
                  .map(
                    (recommendation) => Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyles.body2()),
                          Expanded(
                            child: Text(
                              recommendation,
                              style: TextStyles.body2(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
        SizedBox(height: 16.h),

        Text(
          'How are these blood sugar predictions generated?',
          style: TextStyles.body2(),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {},
          child: Text(
            'View Prediction Feature Standards →',
            style: TextStyles.body2(
              color: ColorStyles.primary500,
              weight: FontWeightOption.semiBold,
            ),
          ),
        ),
      ],
    );
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
      final currentState = context.read<ChatBloc>().state;

      if (currentState is GlucosePredictionLoaded ||
          currentState is ChatWithPredictionLoaded) {
        final response =
            currentState is GlucosePredictionLoaded
                ? currentState.response
                : (currentState as ChatWithPredictionLoaded).response;

        // Pastikan scenarios tidak null
        if (response.scenarios.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No prediction data available')),
          );
          return;
        }

        final request = ChatWithPredictionRequest(
          scenarios: response.scenarios,
          chats: [
            ...response.chats,
            ChatModel(
              role: 'user',
              message: _messageController.text.trim(),
              fileUrl: _selectedImage != null ? 'placeholder_url' : '',
            ),
          ],
        );

        context.read<ChatBloc>().add(
          ChatWithGlucosePredictionEvent(request: request),
        );

        _messageController.clear();
        setState(() {
          _selectedImage = null;
        });
      }
    }
  }

  String _getTimeLabel(
    LineBarSpot barSpot,
    List<GlucoseMonitoringGraph> glucoseData,
    List<Scenario>? scenarios,
  ) {
    final index = barSpot.x.toInt();
    if (index < glucoseData.length) {
      return glucoseData[index].label;
    } else if (scenarios != null && scenarios.isNotEmpty) {
      final predictionIndex = index - glucoseData.length;
      if (predictionIndex >= 0 &&
          predictionIndex < scenarios.first.predictions.length) {
        return scenarios.first.predictions[predictionIndex].time;
      }
    }
    return '';
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
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ChatLoading || state is ChatInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GlucosePredictionLoaded ||
              state is ChatWithPredictionLoaded) {
            final response =
                state is GlucosePredictionLoaded
                    ? state.response
                    : (state as ChatWithPredictionLoaded).response;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        _buildPredictionSummary(response.scenarios),
                        SizedBox(height: 16.h),
                        ...response.chats
                            .map((chat) => _buildChatMessage(chat))
                            .toList(),
                      ],
                    ),
                  ),
                ),
                if (_selectedImage != null)
                  Container(
                    height: 80.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
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
                                      color: ColorStyles.neutral800.withOpacity(
                                        0.7,
                                      ),
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
                // Input area
                _buildInputArea(),
              ],
            );
          }
          return Center(child: Text('Something went wrong\n Error'));
        },
      ),
    );
  }

  Widget _buildChatMessage(ChatModel chat) {
    final isUser = chat.role == 'user';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 32.w,
              height: 32.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: ColorStyles.primary500,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Robot.svg',
                  width: 16.w,
                  height: 16.h,
                  color: Colors.white,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color:
                        isUser
                            ? ColorStyles.neutral100
                            : ColorStyles.primary100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isUser ? 12.r : 0),
                      topRight: Radius.circular(isUser ? 0 : 12.r),
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: MarkdownBody(
                    data: chat.message,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyles.body2(),
                      strong: TextStyles.body2(weight: FontWeightOption.bold),
                      listBullet: TextStyles.body2(),
                      h1: TextStyles.heading1(),
                      h2: TextStyles.heading2(),
                      h3: TextStyles.heading3(),
                      h4: TextStyles.heading4(),
                      h5: TextStyles.body1(),
                      h6: TextStyles.body2(),
                      blockquote: TextStyles.body2(
                        color: ColorStyles.neutral600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser)
            Container(
              width: 32.w,
              height: 32.w,
              margin: EdgeInsets.only(left: 8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/default_profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
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
                  hintStyle: TextStyles.body1(color: ColorStyles.neutral500),
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
    );
  }
}
