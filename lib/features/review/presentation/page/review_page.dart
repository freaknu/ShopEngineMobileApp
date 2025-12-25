import 'package:ecommerce_app/core/constants/widgets/app_dialogs.dart';
import 'package:ecommerce_app/core/constants/widgets/app_loading.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/widgets/button_widget.dart';
import 'package:ecommerce_app/features/review/domain/entity/review.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_bloc.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_event.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_state.dart';
import 'package:ecommerce_app/features/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/features/userdetails/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  // Default rating: 2.0
  double _rating = 2.0;
  bool _isHandlingSuccess = false;

  @override
  Widget build(BuildContext context) {
    final int productId = Get.arguments['product_id'] as int;

    Future<void> submitReview() async {
      // Validate fields
      if (_nameEditingController.text.trim().isEmpty) {
        await AppDialogs.showErrorDialog(
          context: context,
          title: 'Name Required',
          message: 'Please enter your name before submitting the review.',
          buttonText: 'OK',
        );
        return;
      }

      if (_descriptionController.text.trim().isEmpty) {
        await AppDialogs.showErrorDialog(
          context: context,
          title: 'Description Required',
          message: 'Please describe your experience before submitting.',
          buttonText: 'OK',
        );
        return;
      }

      // Show confirmation dialog
      final confirm = await AppDialogs.showConfirmationDialog(
        context: context,
        title: 'Submit Review',
        message: 'Are you sure you want to submit this review with ${_rating.toStringAsFixed(1)} stars?',
        confirmText: 'Submit',
        cancelText: 'Cancel',
        icon: Icons.rate_review_rounded,
      );

      if (confirm == true && mounted) {
        // Show loading dialog before adding event
        AppLoading.show(context, message: 'Submitting your review...');
        
        // Add a slight delay to ensure loading is shown
        await Future.delayed(const Duration(milliseconds: 200));
        
        if (mounted) {
          context.read<ReviewBloc>().add(
            ReviewAddEvent(
              productId,
              Review(
                id: 0,
                userName: _nameEditingController.text.trim(),
                description: _descriptionController.text.trim(),
                rating: _rating.toInt(),
                createdAt: DateTime.now(),
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: customAppBar('Add Review', context),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listenWhen: (previous, current) {
          // Only listen to state changes, not rebuilds of the same state
          return previous.runtimeType != current.runtimeType;
        },
        listener: (context, state) async {
          // Only handle success and failure states, not loading
          if (state is ReviewCreatedState) {
            if (_isHandlingSuccess) return; // Already handling success, skip
            _isHandlingSuccess = true;
            
            // Make sure any loading dialogs are completely gone
            AppLoading.hide();
            
            if (!mounted) {
              _isHandlingSuccess = false;
              return;
            }
            
            // Show success dialog
            await AppDialogs.showSuccessDialog(
              context: context,
              title: 'Review Submitted!',
              message: 'Thank you for sharing your experience. Your review has been submitted successfully.',
              buttonText: 'Great!',
            );
            
            if (mounted) {
              _isHandlingSuccess = false; // Reset flag before navigation
              Get.back(); 
            }
          } else if (state is ReviewFailureState) {
            AppLoading.hide();
            
            if (!mounted) return;
            
            await AppDialogs.showErrorDialog(
              context: context,
              title: 'Submission Failed',
              message: 'Unable to submit your review. Please try again later.',
              buttonText: 'OK',
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  textEditingController: _nameEditingController,
                  fieldName: 'Name',
                  placeHolder: 'Enter Your Name',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  textEditingController: _titleController,
                  fieldName: 'Title',
                  placeHolder: 'About Which?',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  textEditingController: _descriptionController,
                  fieldName: 'How was your experience?',
                  placeHolder: 'Describe your experience',
                  maxLines: 7,
                ),
                const SizedBox(height: 40),

                // Rating Section
                const Text(
                  'Your Rating',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Single Thumb Slider with Thickening Track
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double trackWidth = constraints.maxWidth;
                    final double thumbSize = 16.0;
                    final double maxThumbOffset = trackWidth - thumbSize;

                    final double thumbLeft = maxThumbOffset * (_rating / 5.0);

                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final localPosition = renderBox.globalToLocal(
                          details.globalPosition,
                        );

                        double newOffset = localPosition.dx - thumbSize / 2;
                        newOffset = newOffset.clamp(0.0, maxThumbOffset);

                        setState(() {
                          _rating = (newOffset / maxThumbOffset) * 5.0;
                        });
                      },
                      onTapDown: (details) {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final localPosition = renderBox.globalToLocal(
                          details.globalPosition,
                        );

                        double newOffset = localPosition.dx - thumbSize / 2;
                        newOffset = newOffset.clamp(0.0, maxThumbOffset);

                        setState(() {
                          _rating = (newOffset / maxThumbOffset) * 5.0;
                        });
                      },
                      child: SizedBox(
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Thickening Track (entire track drawn with varying thickness)
                            CustomPaint(
                              size: Size(trackWidth, 60),
                              painter: ThickeningTrackPainter(
                                color: AppcolorPallets.primaryColor.withOpacity(
                                  0.05,
                                ),
                              ),
                            ),

                            // Single Moving Circular Thumb
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              left: thumbLeft,
                              child: Container(
                                width: thumbSize,
                                height: thumbSize,
                                decoration: BoxDecoration(
                                  color: AppcolorPallets.primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Current Rating Display
                const SizedBox(height: 1),
                Center(
                  child: Text(
                    'You rated ${_rating.toStringAsFixed(1)} out of 5',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ButtonWidget(
            buttonText: 'Submit Review',
            buttonBackGroundColor: AppcolorPallets.primaryColor,
            buttonTextColor: Colors.white,
            onClick: submitReview,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isHandlingSuccess = false;
    _nameEditingController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// Custom Painter for the single thickening track line
class ThickeningTrackPainter extends CustomPainter {
  final Color color;

  ThickeningTrackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;

    // Thickness starts thin (4.0) on left, increases to thick (20.0) on right
    const double minThickness = 3.0;
    const double maxThickness = 6.0;

    // Draw many small vertical lines to simulate continuous varying thickness
    for (double x = 0; x <= size.width; x += 2) {
      double progress = x / size.width;
      double thickness =
          minThickness + (maxThickness - minThickness) * progress;
      paint.strokeWidth = thickness;

      canvas.drawLine(
        Offset(x, centerY - thickness / 2),
        Offset(x, centerY + thickness / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ThickeningTrackPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
