import 'package:flutter/material.dart';
import '../../models/humor_model.dart';

/// Widget para seleção de humor com emojis
class HumorSelector extends StatelessWidget {
  final Humor? humorSelecionado;
  final Function(Humor) onHumorSelecionado;

  const HumorSelector({
    super.key,
    required this.humorSelecionado,
    required this.onHumorSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Como você está se sentindo?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: Humor.values.map((humor) {
            final estaSelecionado = humorSelecionado == humor;
            return _HumorButton(
              humor: humor,
              estaSelecionado: estaSelecionado,
              onTap: () => onHumorSelecionado(humor),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Botão individual para um humor
class _HumorButton extends StatelessWidget {
  final Humor humor;
  final bool estaSelecionado;
  final VoidCallback onTap;

  const _HumorButton({
    required this.humor,
    required this.estaSelecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: estaSelecionado
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: estaSelecionado
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              humor.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              humor.descricao,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: estaSelecionado ? FontWeight.bold : FontWeight.normal,
                    color: estaSelecionado
                        ? Theme.of(context).primaryColor
                        : Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}