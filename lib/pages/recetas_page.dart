import 'package:flutter/material.dart';


import 'app_config.dart';
import 'app_texts.dart';

class RecetasPage extends StatelessWidget {
  const RecetasPage({super.key});

  List<RecetaItem> _recetas() {
    return [
      RecetaItem(
        tituloKey: 'recipe1Title',
        emoji: '🍲',
        edadKey: 'recipe1Age',
        momentoKey: 'recipe1Moment',
        color: const Color(0xFFFF8C42),
        descripcionKey: 'recipe1Desc',
        ingredientesKeys: const [
          'recipe1Ing1',
          'recipe1Ing2',
          'recipe1Ing3',
          'recipe1Ing4',
        ],
        preparacionKeys: const [
          'recipe1Step1',
          'recipe1Step2',
          'recipe1Step3',
          'recipe1Step4',
        ],
        recomendacionKey: 'recipe1Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe2Title',
        emoji: '🥣',
        edadKey: 'recipe2Age',
        momentoKey: 'recipe2Moment',
        color: const Color(0xFF7B2CBF),
        descripcionKey: 'recipe2Desc',
        ingredientesKeys: const [
          'recipe2Ing1',
          'recipe2Ing2',
          'recipe2Ing3',
          'recipe2Ing4',
        ],
        preparacionKeys: const [
          'recipe2Step1',
          'recipe2Step2',
          'recipe2Step3',
          'recipe2Step4',
        ],
        recomendacionKey: 'recipe2Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe3Title',
        emoji: '🍳',
        edadKey: 'recipe3Age',
        momentoKey: 'recipe3Moment',
        color: const Color(0xFF00A896),
        descripcionKey: 'recipe3Desc',
        ingredientesKeys: const [
          'recipe3Ing1',
          'recipe3Ing2',
          'recipe3Ing3',
          'recipe3Ing4',
        ],
        preparacionKeys: const [
          'recipe3Step1',
          'recipe3Step2',
          'recipe3Step3',
          'recipe3Step4',
        ],
        recomendacionKey: 'recipe3Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe4Title',
        emoji: '🍚',
        edadKey: 'recipe4Age',
        momentoKey: 'recipe4Moment',
        color: const Color(0xFF4361EE),
        descripcionKey: 'recipe4Desc',
        ingredientesKeys: const [
          'recipe4Ing1',
          'recipe4Ing2',
          'recipe4Ing3',
          'recipe4Ing4',
        ],
        preparacionKeys: const [
          'recipe4Step1',
          'recipe4Step2',
          'recipe4Step3',
          'recipe4Step4',
        ],
        recomendacionKey: 'recipe4Rec',
      ),
      RecetaItem(
        tituloKey: 'recipe5Title',
        emoji: '🍓',
        edadKey: 'recipe5Age',
        momentoKey: 'recipe5Moment',
        color: const Color(0xFFFF006E),
        descripcionKey: 'recipe5Desc',
        ingredientesKeys: const [
          'recipe5Ing1',
          'recipe5Ing2',
          'recipe5Ing3',
        ],
        preparacionKeys: const [
          'recipe5Step1',
          'recipe5Step2',
          'recipe5Step3',
          'recipe5Step4',
        ],
        recomendacionKey: 'recipe5Rec',
      ),
    ];
  }

  Widget _encabezado(bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.22 : 0.10),
            const Color(0xFFFF6B6B).withValues(alpha: modoOscuro ? 0.18 : 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.32 : 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.18 : 0.10),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7B2CBF).withValues(alpha: 0.24),
                  const Color(0xFFFF6B6B).withValues(alpha: 0.14),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🧸',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            T.txt('recipesHeaderTitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
  fontFamily: 'Fredoka',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF7B2CBF),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt('recipesHeaderSubtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
  fontFamily: 'Baloo2',
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF6B6B),
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF7B2CBF).withValues(alpha: modoOscuro ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              T.txt('recipesHeaderNote'),
              textAlign: TextAlign.center,
              style: TextStyle(
  fontFamily: 'Baloo2',
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: modoOscuro ? Colors.white : const Color(0xFF7B2CBF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recetaCard(RecetaItem receta, bool modoOscuro) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            receta.color.withValues(alpha: modoOscuro ? 0.18 : 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: receta.color.withValues(alpha: modoOscuro ? 0.32 : 0.23),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: receta.color.withValues(alpha: modoOscuro ? 0.16 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  receta.color.withValues(alpha: 0.25),
                  receta.color.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                receta.emoji,
                style: const TextStyle(fontSize: 43),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            T.txt(receta.tituloKey),
            textAlign: TextAlign.center,
            style: TextStyle(
  fontFamily: 'Fredoka',
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt(receta.descripcionKey),
            textAlign: TextAlign.center,
            style: TextStyle(
  fontFamily: 'Baloo2',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: modoOscuro ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _etiqueta(
                texto: T.txt(receta.edadKey),
                color: receta.color,
                icono: Icons.child_care_rounded,
                modoOscuro: modoOscuro,
              ),
              _etiqueta(
                texto: T.txt(receta.momentoKey),
                color: receta.color,
                icono: Icons.schedule_rounded,
                modoOscuro: modoOscuro,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _bloque(
            titulo: T.txt('ingredients'),
            datos: receta.ingredientesKeys.map((key) => T.txt(key)).toList(),
            icono: Icons.shopping_basket_rounded,
            color: receta.color,
            modoOscuro: modoOscuro,
          ),
          _bloque(
            titulo: T.txt('preparation'),
            datos: receta.preparacionKeys.map((key) => T.txt(key)).toList(),
            icono: Icons.soup_kitchen_rounded,
            color: receta.color,
            modoOscuro: modoOscuro,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: receta.color.withValues(alpha: modoOscuro ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: receta.color.withValues(alpha: modoOscuro ? 0.24 : 0.14),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.tips_and_updates_rounded,
                  color: receta.color,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    T.txt(receta.recomendacionKey),
                    style: TextStyle(
  fontFamily: 'Baloo2',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: modoOscuro ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _etiqueta({
    required String texto,
    required Color color,
    required IconData icono,
    required bool modoOscuro,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: modoOscuro ? 0.18 : 0.11),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
  fontFamily: 'Baloo2',
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bloque({
    required String titulo,
    required List<String> datos,
    required IconData icono,
    required Color color,
    required bool modoOscuro,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: modoOscuro
            ? const Color(0xFF15131A).withValues(alpha: 0.82)
            : Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.24 : 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: TextStyle(
  fontFamily: 'Fredoka',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: modoOscuro ? Colors.white : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...datos.map(
            (dato) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
  fontFamily: 'Baloo2',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      dato,
                      style: TextStyle(
  fontFamily: 'Baloo2',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                        color: modoOscuro ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notaFinal(bool modoOscuro) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            Colors.redAccent.withValues(alpha: modoOscuro ? 0.16 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: modoOscuro ? 0.28 : 0.16),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Colors.redAccent,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              T.txt('recipeFinalNote'),
              style: TextStyle(
  fontFamily: 'Baloo2',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: modoOscuro ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppConfig.temaApp,
          builder: (context, temaActual, _) {
            final bool modoOscuro = Theme.of(context).brightness == Brightness.dark;
            final listaRecetas = _recetas();

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('recipesAppBar'),
                  style: TextStyle(
  fontFamily: 'Fredoka',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                  ),
                ),
                centerTitle: true,
                backgroundColor:
                    modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                foregroundColor:
                    modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                elevation: 0,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _encabezado(modoOscuro),
                      const SizedBox(height: 20),
                      ...listaRecetas.map(
                        (receta) => _recetaCard(receta, modoOscuro),
                      ),
                      _notaFinal(modoOscuro),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class RecetaItem {
  final String tituloKey;
  final String emoji;
  final String edadKey;
  final String momentoKey;
  final Color color;
  final String descripcionKey;
  final List<String> ingredientesKeys;
  final List<String> preparacionKeys;
  final String recomendacionKey;

  const RecetaItem({
    required this.tituloKey,
    required this.emoji,
    required this.edadKey,
    required this.momentoKey,
    required this.color,
    required this.descripcionKey,
    required this.ingredientesKeys,
    required this.preparacionKeys,
    required this.recomendacionKey,
  });
}