class CuentasModel {
  final String id;
  final String nombre;
  final List<int> valor;

  CuentasModel({
    required this.id,
    required this.nombre,
    required this.valor,
  });

  factory CuentasModel.fromMap(Map data) {
    return CuentasModel(
      id: data['id'],
      nombre: data['nombre'],
      valor: data['valor'].cast<int>(),
    );
  }

  CuentasModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        valor = json['valor'];

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'valor': valor,
      };
}
