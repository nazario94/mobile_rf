
class RFParameter {
  final String name;
  final String value;

  RFParameter({required this.name, required this.value});

  factory RFParameter.fromJson(Map<String, dynamic> json) {
    return RFParameter(
      name: json['name'],
      value: json['value'],
    );
  }
}
