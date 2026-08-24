import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LessonVideoPlayerWidget extends StatelessWidget {
  final bool isPlaying;
  final double videoProgress;
  final String currentTime;
  final String totalTime;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSeek;

  const LessonVideoPlayerWidget({
    super.key,
    required this.isPlaying,
    required this.videoProgress,
    this.currentTime = '06:45',
    this.totalTime = '14:30',
    required this.onTogglePlay,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                iconSize: 40,
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
                onPressed: onTogglePlay,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      value: videoProgress,
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.white24,
                      onChanged: onSeek,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentTime, style: const TextStyle(color: Colors.white, fontSize: 11)),
                      Text(totalTime, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
