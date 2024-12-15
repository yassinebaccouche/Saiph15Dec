enum RecetteType {
  Pates,
  Soupes,
  Ragouts,
  Salades,
  Desserts,
}
extension RecetteTypeExtension on RecetteType {
  String toStringValue() {
    switch (this) {
      case RecetteType.Pates:
        return 'Pâtes';
      case RecetteType.Soupes:
        return 'Soupes';
      case RecetteType.Ragouts:
        return 'Ragoûts';
      case RecetteType.Salades:
        return 'Salades';
      case RecetteType.Desserts:
        return 'Desserts';
    }
  }
}