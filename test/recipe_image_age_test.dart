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
}
