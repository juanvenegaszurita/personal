class CuentasModel {
  final String id;
  final String nombre;
  final List<int> montos;

  CuentasModel({
    required this.id,
    required this.nombre,
    required this.montos,
  });

  factory CuentasModel.fromMap(Map data) {
    return CuentasModel(
      id: data['id'],
      nombre: data['nombre'],
      montos: data['montos'].cast<int>(),
    );
  }

  CuentasModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        montos = json['montos'];

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'montos': montos,
      };
}
