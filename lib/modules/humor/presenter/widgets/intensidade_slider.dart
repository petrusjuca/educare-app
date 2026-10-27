import 'package:flutter/material.dart';

/// Widget para ajustar a intensidade do humor
class IntensidadeSlider extends StatelessWidget {
  final double intensidade;
  final Function(double) onIntensidadeChanged;

  const IntensidadeSlider({
    super.key,
    required this.intensidade,
    required this.onIntensidadeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Quão intenso é esse sentimento?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Pouco'),
            Expanded(
              child: Slider(
                value: intensidade,
                onChanged: onIntensidadeChanged,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.grey.shade300,
              ),
            ),
            const Text('Muito'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${(intensidade * 100).round()}%',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}