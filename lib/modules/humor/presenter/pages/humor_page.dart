import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/humor_provider.dart';
import '../../models/humor_model.dart';
import '../widgets/humor_selector.dart';
import '../widgets/intensidade_slider.dart';
import '../widgets/humor_historico.dart';

/// Página para entrada de humor do estudante
class HumorPage extends StatelessWidget {
  const HumorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Como você está se sentindo?'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<HumorProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título e instruções
                Text(
                  'Olá, Ana!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Conte-nos como você está se sentindo hoje.\nIsso nos ajuda a entender melhor seu aprendizado.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Seletor de humor
                HumorSelector(
                  humorSelecionado: provider.humorSelecionado,
                  onHumorSelecionado: provider.selecionarHumor,
                ),
                const SizedBox(height: 32),

                // Slider de intensidade (só aparece se humor selecionado)
                if (provider.humorSelecionado != null) ...[
                  IntensidadeSlider(
                    intensidade: provider.intensidade,
                    onIntensidadeChanged: provider.ajustarIntensidade,
                  ),
                  const SizedBox(height: 32),
                ],

                // Botão de salvar
                if (provider.humorSelecionado != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.estaSalvando
                          ? null
                          : () => _salvarHumor(context, provider),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: provider.estaSalvando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Salvar Humor',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),

                const SizedBox(height: 48),

                // Histórico de humores
                if (provider.historicoHumores.isNotEmpty) ...[
                  Text(
                    'Seu histórico',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  HumorHistorico(historico: provider.historicoHumores),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _salvarHumor(BuildContext context, HumorProvider provider) async {
    final sucesso = await provider.salvarHumor();

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Humor salvo com sucesso! Obrigado por compartilhar.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar humor. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}