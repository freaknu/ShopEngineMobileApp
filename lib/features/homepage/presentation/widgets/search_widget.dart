import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class SearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback? onMicClick;
  
  const SearchWidget({
    super.key,
    required this.searchController,
    this.onMicClick,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChanged(bool isFocused) {
    setState(() => _isFocused = isFocused);
    if (isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppcolorPallets.primaryColor.withOpacity(0.08),
                        AppcolorPallets.primaryColor.withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppcolorPallets.primaryColor.withOpacity(0.15),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppcolorPallets.primaryColor.withOpacity(
                          _isFocused ? 0.2 : 0.05,
                        ),
                        blurRadius: _isFocused ? 20 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 12,
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: _isFocused ? 1.1 : 0.8),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Image.asset(
                                "assets/images/search.png",
                                width: 20,
                                height: 20,
                                color: AppcolorPallets.primaryColor.withOpacity(0.7),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Focus(
                          onFocusChange: _onFocusChanged,
                          child: TextField(
                            controller: widget.searchController,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppcolorPallets.textPrimary,
                              letterSpacing: 0.3,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              hintStyle: TextStyle(
                                color: AppcolorPallets.textSecondary.withOpacity(0.5),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              isDense: true,
                              suffixIcon: widget.searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        widget.searchController.clear();
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: AppcolorPallets.primaryColor.withOpacity(0.6),
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: widget.onMicClick,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 1.0),
              duration: const Duration(milliseconds: 200),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppcolorPallets.primaryColor,
                              AppcolorPallets.primaryColor.withOpacity(0.85),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppcolorPallets.primaryColor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: AppcolorPallets.primaryColor.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onMicClick,
                            splashColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Image.asset(
                                "assets/images/mic.png",
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}