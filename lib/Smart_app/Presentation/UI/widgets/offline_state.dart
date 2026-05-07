import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/smart_provider.dart';

class OfflineState extends StatelessWidget {
  const OfflineState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.smartphone_rounded,
                      size: 56,
                      color: Colors.orange.withOpacity(0.4),
                    ),
                    Positioned(
                      right: 30,
                      top: 30,
                      child: Transform.rotate(
                        angle: -0.4,
                        child: Icon(
                          Icons.signal_wifi_off_rounded,
                          size: 30,
                          color: Colors.orange.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'You\'re offline',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),

            const SizedBox(height: 10),

            Text(
              'No cached data available.\nConnect to the internet to discover amazing places.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.5),
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 28),

            ElevatedButton.icon(
              onPressed: () {
                context.read<SmartProvider>().loadPlaces();
              },
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
