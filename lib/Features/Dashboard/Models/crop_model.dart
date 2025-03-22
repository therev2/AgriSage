class Crop {
  final String id;
  final String name;
  final String variety;
  final String fieldLocation;
  final DateTime plantingDate;
  final DateTime expectedHarvestDate;
  final double estimatedYield;
  final String yieldUnit;
  final String healthStatus;
  final List<String>? treatments;
  final Map<String, dynamic>? additionalData;

  Crop({
    required this.id,
    required this.name,
    required this.variety,
    required this.fieldLocation,
    required this.plantingDate,
    required this.expectedHarvestDate,
    required this.estimatedYield,
    required this.yieldUnit,
    required this.healthStatus,
    this.treatments,
    this.additionalData,
  });

  Crop copyWith({
    String? id,
    String? name,
    String? variety,
    String? fieldLocation,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    double? estimatedYield,
    String? yieldUnit,
    String? healthStatus,
    List<String>? treatments,
    Map<String, dynamic>? additionalData,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      fieldLocation: fieldLocation ?? this.fieldLocation,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      estimatedYield: estimatedYield ?? this.estimatedYield,
      yieldUnit: yieldUnit ?? this.yieldUnit,
      healthStatus: healthStatus ?? this.healthStatus,
      treatments: treatments ?? this.treatments,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
