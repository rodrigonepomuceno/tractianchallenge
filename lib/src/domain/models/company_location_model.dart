class CompanyAssetsModel {
  final String id;
  final String name;
  final bool isLocal;
  final String? parentId;
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;
  final String? locationId;
  final List<CompanyAssetsModel> _children;

  CompanyAssetsModel({
    required this.id,
    required this.name,
    this.isLocal = false,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
    this.gatewayId,
    this.locationId,
    List<CompanyAssetsModel> children = const [],
  }) : _children = List.from(children);

  List<CompanyAssetsModel> get children => _children;

  void addChild(CompanyAssetsModel child) {
    _children.add(child);
  }

  factory CompanyAssetsModel.fromJson(Map<String, dynamic> json, bool isLocal) {
    return CompanyAssetsModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      status: json['status'],
      gatewayId: json['gatewayId'],
      locationId: json['locationId'],
      isLocal: isLocal,
      children: [],
    );
  }
}
