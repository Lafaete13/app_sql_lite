import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/identidade.dart';
import '../providers.dart';

class TelaSobre extends ConsumerWidget {
  const TelaSobre({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final dispositivo = ref.watch(infoDispositivoProvider);
    final bancoCriadoEm = ref.watch(bancoCriadoEmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(Identidade.nomeDoApp, style: textos.headlineSmall),
                const SizedBox(height: 8),
                Text(Identidade.descricao, style: textos.bodyLarge),
                const Divider(height: 32),
                Text('Autoria', style: textos.titleMedium),
                for (final integrante in Identidade.integrantes)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: Text(integrante.nome),
                    subtitle: Text('Matrícula ${integrante.matricula}'),
                  ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.school_outlined),
                  title: Text(Identidade.turma),
                ),
                const Divider(height: 32),
                Text(
                  'Dispositivo (canal de plataforma)',
                  style: textos.titleMedium,
                ),
                const SizedBox(height: 8),
                dispositivo.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (erro, _) => Text('Falha na consulta: $erro'),
                  data: (info) => Text(
                    info == null
                        ? 'Informação indisponível nesta plataforma.'
                        : '${info.fabricante} ${info.modelo}\n'
                              'Android ${info.versaoAndroid} · bateria em ${info.nivelBateria}%',
                  ),
                ),
                const Divider(height: 32),
                Text('Banco de dados local', style: textos.titleMedium),
                const SizedBox(height: 8),
                Text(
                  bancoCriadoEm.when(
                    loading: () => 'Consultando...',
                    error: (erro, _) => 'Falha na consulta: $erro',
                    data: (data) => data == null
                        ? 'Data de criação não registrada.'
                        : 'Criado neste aparelho em ${_formatar(data)}.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatar(DateTime data) {
  String dois(int n) => n.toString().padLeft(2, '0');
  return '${dois(data.day)}/${dois(data.month)}/${data.year} às ${dois(data.hour)}:${dois(data.minute)}';
}