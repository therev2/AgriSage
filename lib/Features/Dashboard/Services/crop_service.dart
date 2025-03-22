import 'package:agrisage/Features/Dashboard/Models/crop_model.dart';

class CropService {
  // In-memory storage for crops
  final List<Crop> _crops = [];

  // Get all crops
  List<Crop> getAllCrops() {
    return List.from(_crops);
  }

  // Add a new crop
  void addCrop(Crop crop) {
    _crops.add(crop);
  }

  // Update an existing crop
  void updateCrop(String id, Crop updatedCrop) {
    final index = _crops.indexWhere((crop) => crop.id == id);
    if (index != -1) {
      _crops[index] = updatedCrop;
    }
  }

  // Delete a crop
  void deleteCrop(String id) {
    _crops.removeWhere((crop) => crop.id == id);
  }

  // Get upcoming harvests within days
  List<Crop> getUpcomingHarvests(int days) {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    return _crops.where((crop) {
      return crop.expectedHarvestDate.isAfter(now) &&
          crop.expectedHarvestDate.isBefore(futureDate);
    }).toList();
  }

  // Get crops by field location
  List<Crop> getCropsByField(String fieldLocation) {
    return _crops.where((crop) => crop.fieldLocation == fieldLocation).toList();
  }

  // Get crops by name
  List<Crop> getCropsByName(String name) {
    return _crops.where((crop) => crop.name == name).toList();
  }

  // Get crops planted in a specific time period
  List<Crop> getCropsPlantedInPeriod(DateTime start, DateTime end) {
    return _crops.where((crop) {
      return crop.plantingDate.isAfter(start) &&
          crop.plantingDate.isBefore(end);
    }).toList();
  }

  // Get estimated total yield by crop name
  Map<String, double> getEstimatedYieldByCrop() {
    final Map<String, double> yields = {};
    for (var crop in _crops) {
      yields[crop.name] = (yields[crop.name] ?? 0) + crop.estimatedYield;
    }
    return yields;
  }

  // Update crop health status
  void updateCropHealth(String id, String newHealthStatus) {
    final index = _crops.indexWhere((crop) => crop.id == id);
    if (index != -1) {
      _crops[index] = _crops[index].copyWith(healthStatus: newHealthStatus);
    }
  }
}
