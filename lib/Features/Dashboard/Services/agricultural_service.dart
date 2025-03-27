class AgriculturalAnalysis {
  // Calculate Crop Water Stress Index
  static double calculateCWSI(double evapotranspiration, double potentialET) {
    // CWSI = 1 - (ET / potential_ET)
    if (potentialET == 0) return 1.0; // Avoid division by zero
    return 1.0 - (evapotranspiration / potentialET);
  }

  // Calculate Plant Disease Risk based on temperature and humidity
  static String assessDiseaseRisk(double temperature, double humidity) {
    // High humidity and moderate temperatures often increase disease risk
    if (humidity > 80) {
      if (temperature > 15 && temperature < 30) {
        return "CRITICAL"; // High risk
      } else {
        return "WARNING"; // Moderate risk
      }
    } else if (humidity > 60) {
      if (temperature > 20 && temperature < 25) {
        return "WARNING"; // Moderate risk
      }
    }
    return "NORMAL"; // Low risk
  }

  // Predict drought conditions
  static String predictDrought(double temperature, double humidity, double evapotranspiration) {
    // High temperature, low humidity, and high evapotranspiration suggest drought
    if (temperature > 30 && humidity < 40 && evapotranspiration > 7) {
      return "CRITICAL"; // Severe drought risk
    } else if (temperature > 25 && humidity < 50 && evapotranspiration > 5) {
      return "WARNING"; // Moderate drought risk
    }
    return "NORMAL"; // Low drought risk
  }

  // Calculate dew point and assess fog/dew formation risk
  static Map<String, dynamic> calculateDewPoint(double temperature, double humidity) {
    // Dew Point = temp - ((100 - humidity) / 5)
    double dewPoint = temperature - ((100 - humidity) / 5);

    String risk;
    if (temperature - dewPoint < 2.5) {
      risk = "CRITICAL"; // High risk of fog/dew
    } else if (temperature - dewPoint < 5) {
      risk = "WARNING"; // Moderate risk of fog/dew
    } else {
      risk = "NORMAL"; // Low risk of fog/dew
    }

    return {
      "dewPoint": dewPoint,
      "risk": risk
    };
  }

  // Determine irrigation scheduling based on evapotranspiration
  static String calculateIrrigationNeeds(double evapotranspiration) {
    if (evapotranspiration > 6) {
      return "CRITICAL"; // Immediate irrigation needed
    } else if (evapotranspiration > 4) {
      return "WARNING"; // Consider irrigation soon
    }
    return "NORMAL"; // No immediate irrigation needed
  }

  // Calculate heat wave risk using temperature and humidity (heat index)
  static Map<String, dynamic> assessHeatwaveRisk(double temperature, double humidity) {
    // Simplified heat index calculation
    double humidex = temperature + (0.5555 * (humidity * 10 - 10));

    String risk;
    if (humidex > 40) {
      risk = "CRITICAL"; // Extreme heat risk
    } else if (humidex > 35) {
      risk = "WARNING"; // Moderate heat risk
    } else {
      risk = "NORMAL"; // Low heat risk
    }

    return {
      "humidex": humidex,
      "risk": risk
    };
  }

  // Combine all analyses into a comprehensive assessment
  static Map<String, dynamic> analyzeConditions(
      double temperature,
      double humidity,
      double evapotranspiration,
      double potentialET
      ) {
    // Calculate all metrics
    double cwsi = calculateCWSI(evapotranspiration, potentialET);
    String diseaseRisk = assessDiseaseRisk(temperature, humidity);
    String droughtRisk = predictDrought(temperature, humidity, evapotranspiration);
    Map<String, dynamic> dewInfo = calculateDewPoint(temperature, humidity);
    String irrigationNeeds = calculateIrrigationNeeds(evapotranspiration);
    Map<String, dynamic> heatInfo = assessHeatwaveRisk(temperature, humidity);

    // Determine overall risk level
    List<String> allRisks = [diseaseRisk, droughtRisk, dewInfo["risk"], irrigationNeeds, heatInfo["risk"]];
    String overallRisk = "NORMAL";

    if (allRisks.contains("CRITICAL")) {
      overallRisk = "CRITICAL";
    } else if (allRisks.contains("WARNING")) {
      overallRisk = "WARNING";
    }

    // Return comprehensive analysis
    return {
      "cwsi": cwsi,
      "diseaseRisk": diseaseRisk,
      "droughtRisk": droughtRisk,
      "dewPoint": dewInfo["dewPoint"],
      "dewRisk": dewInfo["risk"],
      "irrigationNeeds": irrigationNeeds,
      "humidex": heatInfo["humidex"],
      "heatRisk": heatInfo["risk"],
      "overallRisk": overallRisk,
      "recommendations": generateRecommendations(
          cwsi,
          diseaseRisk,
          droughtRisk,
          dewInfo["risk"],
          irrigationNeeds,
          heatInfo["risk"]
      )
    };
  }

  // Generate specific recommendations based on analysis
  static List<String> generateRecommendations(
      double cwsi,
      String diseaseRisk,
      String droughtRisk,
      String dewRisk,
      String irrigationNeeds,
      String heatRisk
      ) {
    List<String> recommendations = [];

    // CWSI recommendations
    if (cwsi > 0.7) {
      recommendations.add("Critical water stress detected. Immediate irrigation recommended.");
    } else if (cwsi > 0.5) {
      recommendations.add("Moderate water stress. Consider irrigation in the next 24-48 hours.");
    }

    // Disease risk recommendations
    if (diseaseRisk == "CRITICAL") {
      recommendations.add("High disease risk conditions. Consider preventative fungicide application.");
    } else if (diseaseRisk == "WARNING") {
      recommendations.add("Monitor crops closely for early signs of disease in the coming days.");
    }

    // Drought recommendations
    if (droughtRisk == "CRITICAL") {
      recommendations.add("Severe drought conditions expected. Implement water conservation strategies.");
    } else if (droughtRisk == "WARNING") {
      recommendations.add("Potential drought conditions developing. Prepare irrigation systems.");
    }

    // Dew/Fog recommendations
    if (dewRisk == "CRITICAL") {
      recommendations.add("High probability of dew/fog formation. Delay spraying operations.");
    } else if (dewRisk == "WARNING") {
      recommendations.add("Possible dew formation. Consider adjusting early morning field operations.");
    }

    // Irrigation recommendations
    if (irrigationNeeds == "CRITICAL") {
      recommendations.add("High evapotranspiration rates. Crops require immediate irrigation.");
    } else if (irrigationNeeds == "WARNING") {
      recommendations.add("Moderate water loss detected. Schedule irrigation in the next few days.");
    }

    // Heat risk recommendations
    if (heatRisk == "CRITICAL") {
      recommendations.add("Extreme heat conditions expected. Provide shade for sensitive crops and ensure adequate hydration.");
    } else if (heatRisk == "WARNING") {
      recommendations.add("Heat stress possible. Monitor sensitive crops and consider additional watering.");
    }

    return recommendations;
  }
}