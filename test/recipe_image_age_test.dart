import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wawa_kalu/features/health/data/ecuador_recipe_catalog.dart';

void main() {
  test('Cada receta tiene una fotografía válida para sus edades', () {
    expect(ecuadorRecipeCatalog, hasLength(10));

    for (final recipe in ecuadorRecipeCatalog) {
      for (int months = recipe.minAgeMonths;
          months <= recipe.maxAgeMonths;
          months++) {
        final photo = recipe.photoForAgeMonths(months);
        final imageUri = Uri.tryParse(photo.url);
        final sourceUri = Uri.tryParse(photo.sourceUrl);

        expect(imageUri?.scheme, 'https', reason: recipe.id);
        expect(imageUri?.host.isNotEmpty, isTrue, reason: recipe.id);
        expect(sourceUri?.scheme, 'https', reason: recipe.id);
      }
    }
  });

  test('La foto cambia al pasar de bebé a niño mayor', () {
    final recipe = ecuadorRecipeCatalog.singleWhere(
      (element) => element.id == 'majado_verde_pollo',
    );
    expect(recipe.photoForAgeMonths(10).url,
        isNot(recipe.photoForAgeMonths(14).url));
  });

  test('Recetas para varias etapas muestran una foto diferente', () {
    final recipe = ecuadorRecipeCatalog.singleWhere(
      (element) => element.id == 'sopa_quinua_pollo',
    );
    final toddler = recipe.photoForAgeMonths(18).url;
    final older = recipe.photoForAgeMonths(48).url;
    expect(toddler, isNot(older));
  });

  test('La selección de imagen respeta los límites de la receta', () {
    final recipe = ecuadorRecipeCatalog.singleWhere(
      (element) => element.id == 'locro_suave_papa_queso',
    );
    expect(recipe.photoForAgeMonths(6).url,
        recipe.photoForAgeMonths(12).url);
    expect(recipe.photoForAgeMonths(48).url,
        recipe.photoForAgeMonths(35).url);
  });
  testWidgets('El majado de 9-11 meses incluye una foto local real',
      (tester) async {
    final recipe = ecuadorRecipeCatalog.singleWhere(
      (element) => element.id == 'majado_verde_pollo',
    );
    final photo = recipe.photoForAgeMonths(10);
    expect(photo.assetPath, 'assets/images/recipes/majado_verde_9_11.webp');

    // Comprueba que la fotografía realmente está empaquetada en Flutter.
    final bytes = await rootBundle.load(photo.assetPath!);
    expect(bytes.lengthInBytes, greaterThan(10000));

    // La presentación de niños mayores sigue siendo independiente.
    expect(recipe.photoForAgeMonths(14).assetPath, isNull);
  });

}
