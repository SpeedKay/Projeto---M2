enum ItemCategory {
  electronics('ELECTRONICS', 'Eletrônicos'),
  documents('DOCUMENTS', 'Documentos'),
  clothing('CLOTHING', 'Vestuário'),
  accessories('ACCESSORIES', 'Acessórios'),
  other('OTHER', 'Outros');

  const ItemCategory(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static ItemCategory fromApi(String value) => ItemCategory.values.firstWhere(
        (category) => category.apiValue == value,
  );
}