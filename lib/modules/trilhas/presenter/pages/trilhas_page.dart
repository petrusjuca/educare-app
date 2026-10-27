import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trilhas_provider.dart';
import '../../../../core/models/trilha.dart';
import '../widgets/trilha_card.dart';

/// Página principal das trilhas de aprendizagem
class TrilhasPage extends StatelessWidget {
  const TrilhasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Trilhas'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<TrilhasProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, Ana! Vamos aprender juntos?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha uma trilha para continuar sua jornada de aprendizado',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.trilhasDisponiveis.length,
                    itemBuilder: (context, index) {
                      final trilha = provider.trilhasDisponiveis[index];
                      final progresso = provider.getProgressoTrilha(trilha.id);
                      final estaDesbloqueada = provider.trilhaEstaDesbloqueada(trilha.id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TrilhaCard(
                          trilha: trilha,
                          progresso: progresso,
                          estaDesbloqueada: estaDesbloqueada,
                          onTap: estaDesbloqueada
                              ? () => _navegarParaTrilha(context, trilha)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navegarParaTrilha(BuildContext context, Trilha trilha) {
    // TODO: Navegar para a página da trilha específica
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando para ${trilha.titulo}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}