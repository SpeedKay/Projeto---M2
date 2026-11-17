enum ItemStatus {
  unclaimed('UNCLAIMED', 'Aguardando retirada'),
  redeemed('REDEEMED', 'Recuperado');

  const ItemStatus(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static ItemStatus fromApi(String value) => ItemStatus.values.firstWhere(
        (status) => status.apiValue == value,
  );
}