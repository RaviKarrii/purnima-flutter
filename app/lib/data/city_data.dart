class City {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String timezone;

  const City({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  static City? findNearestCity(double lat, double lng) {
    if (majorCities.isEmpty) return null;

    City? nearestCity;
    double minDistance = double.infinity;

    for (final city in majorCities) {
      final distance = _calculateDistance(lat, lng, city.latitude, city.longitude);
      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city;
      }
    }
    return nearestCity;
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simple Euclidean distance for performance, as we just want the nearest one roughly.
    // For greater accuracy, Haversine can be used, but this suffices for "Near X"
    final dLat = (lat2 - lat1).abs();
    final dLon = (lon2 - lon1).abs();
    return dLat * dLat + dLon * dLon;
  }
}

const List<City> majorCities = [
  // India
  City(name: 'New Delhi', country: 'India', latitude: 28.6139, longitude: 77.2090, timezone: 'Asia/Kolkata'),
  City(name: 'Mumbai', country: 'India', latitude: 19.0760, longitude: 72.8777, timezone: 'Asia/Kolkata'),
  City(name: 'Bangalore', country: 'India', latitude: 12.9716, longitude: 77.5946, timezone: 'Asia/Kolkata'),
  City(name: 'Hyderabad', country: 'India', latitude: 17.3850, longitude: 78.4867, timezone: 'Asia/Kolkata'),
  City(name: 'Chennai', country: 'India', latitude: 13.0827, longitude: 80.2707, timezone: 'Asia/Kolkata'),
  City(name: 'Kolkata', country: 'India', latitude: 22.5726, longitude: 88.3639, timezone: 'Asia/Kolkata'),
  City(name: 'Ahmedabad', country: 'India', latitude: 23.0225, longitude: 72.5714, timezone: 'Asia/Kolkata'),
  City(name: 'Pune', country: 'India', latitude: 18.5204, longitude: 73.8567, timezone: 'Asia/Kolkata'),
  City(name: 'Jaipur', country: 'India', latitude: 26.9124, longitude: 75.7873, timezone: 'Asia/Kolkata'),
  City(name: 'Lucknow', country: 'India', latitude: 26.8467, longitude: 80.9461, timezone: 'Asia/Kolkata'),
  City(name: 'Visakhapatnam', country: 'India', latitude: 17.6868, longitude: 83.2185, timezone: 'Asia/Kolkata'),
  City(name: 'Surat', country: 'India', latitude: 21.1702, longitude: 72.8311, timezone: 'Asia/Kolkata'),
  City(name: 'Kanpur', country: 'India', latitude: 26.4499, longitude: 80.3319, timezone: 'Asia/Kolkata'),
  City(name: 'Nagpur', country: 'India', latitude: 21.1458, longitude: 79.0882, timezone: 'Asia/Kolkata'),
  City(name: 'Patna', country: 'India', latitude: 25.5941, longitude: 85.1376, timezone: 'Asia/Kolkata'),
  City(name: 'Indore', country: 'India', latitude: 22.7196, longitude: 75.8577, timezone: 'Asia/Kolkata'),
  City(name: 'Thane', country: 'India', latitude: 19.2183, longitude: 72.9781, timezone: 'Asia/Kolkata'),
  City(name: 'Bhopal', country: 'India', latitude: 23.2599, longitude: 77.4126, timezone: 'Asia/Kolkata'),
  City(name: 'Ludhiana', country: 'India', latitude: 30.9010, longitude: 75.8573, timezone: 'Asia/Kolkata'),
  City(name: 'Agra', country: 'India', latitude: 27.1767, longitude: 78.0081, timezone: 'Asia/Kolkata'),
  City(name: 'Kakinada', country: 'India', latitude: 16.9891, longitude: 82.2475, timezone: 'Asia/Kolkata'),
  City(name: 'Nashik', country: 'India', latitude: 19.9975, longitude: 73.7898, timezone: 'Asia/Kolkata'),
  City(name: 'Faridabad', country: 'India', latitude: 28.4089, longitude: 77.3178, timezone: 'Asia/Kolkata'),
  City(name: 'Meerut', country: 'India', latitude: 28.9845, longitude: 77.7064, timezone: 'Asia/Kolkata'),
  City(name: 'Rajkot', country: 'India', latitude: 22.3039, longitude: 70.8022, timezone: 'Asia/Kolkata'),
  City(name: 'Kalyan-Dombivli', country: 'India', latitude: 19.2183, longitude: 73.1331, timezone: 'Asia/Kolkata'),
  City(name: 'Vasai-Virar', country: 'India', latitude: 19.3919, longitude: 72.8397, timezone: 'Asia/Kolkata'),
  City(name: 'Varanasi', country: 'India', latitude: 25.3176, longitude: 82.9739, timezone: 'Asia/Kolkata'),
  City(name: 'Srinagar', country: 'India', latitude: 34.0837, longitude: 74.7973, timezone: 'Asia/Kolkata'),
  City(name: 'Aurangabad', country: 'India', latitude: 19.8762, longitude: 75.3433, timezone: 'Asia/Kolkata'),
  City(name: 'Dhanbad', country: 'India', latitude: 23.7957, longitude: 86.4304, timezone: 'Asia/Kolkata'),
  City(name: 'Amritsar', country: 'India', latitude: 31.6340, longitude: 74.8723, timezone: 'Asia/Kolkata'),
  City(name: 'Navi Mumbai', country: 'India', latitude: 19.0330, longitude: 73.0297, timezone: 'Asia/Kolkata'),
  City(name: 'Allahabad', country: 'India', latitude: 25.4358, longitude: 81.8463, timezone: 'Asia/Kolkata'),
  City(name: 'Howrah', country: 'India', latitude: 22.5958, longitude: 88.2636, timezone: 'Asia/Kolkata'),
  City(name: 'Ranchi', country: 'India', latitude: 23.3441, longitude: 85.3096, timezone: 'Asia/Kolkata'),
  City(name: 'Gwalior', country: 'India', latitude: 26.2183, longitude: 78.1828, timezone: 'Asia/Kolkata'),
  City(name: 'Jabalpur', country: 'India', latitude: 23.1815, longitude: 79.9864, timezone: 'Asia/Kolkata'),
  City(name: 'Coimbatore', country: 'India', latitude: 11.0168, longitude: 76.9558, timezone: 'Asia/Kolkata'),
  City(name: 'Vijayawada', country: 'India', latitude: 16.5062, longitude: 80.6480, timezone: 'Asia/Kolkata'),
  City(name: 'Jodhpur', country: 'India', latitude: 26.2389, longitude: 73.0243, timezone: 'Asia/Kolkata'),
  City(name: 'Madurai', country: 'India', latitude: 9.9252, longitude: 78.1198, timezone: 'Asia/Kolkata'),
  City(name: 'Raipur', country: 'India', latitude: 21.2514, longitude: 81.6296, timezone: 'Asia/Kolkata'),
  City(name: 'Kota', country: 'India', latitude: 25.2138, longitude: 75.8648, timezone: 'Asia/Kolkata'),
  City(name: 'Guwahati', country: 'India', latitude: 26.1445, longitude: 91.7362, timezone: 'Asia/Kolkata'),
  City(name: 'Chandigarh', country: 'India', latitude: 30.7333, longitude: 76.7794, timezone: 'Asia/Kolkata'),
  City(name: 'Solapur', country: 'India', latitude: 17.6599, longitude: 75.9064, timezone: 'Asia/Kolkata'),
  City(name: 'Hubli-Dharwad', country: 'India', latitude: 15.3647, longitude: 75.1240, timezone: 'Asia/Kolkata'),
  City(name: 'Tiruchirappalli', country: 'India', latitude: 10.7905, longitude: 78.7047, timezone: 'Asia/Kolkata'),
  City(name: 'Bareilly', country: 'India', latitude: 28.3670, longitude: 79.4304, timezone: 'Asia/Kolkata'),
  City(name: 'Moradabad', country: 'India', latitude: 28.8386, longitude: 78.7733, timezone: 'Asia/Kolkata'),
  City(name: 'Mysore', country: 'India', latitude: 12.2958, longitude: 76.6394, timezone: 'Asia/Kolkata'),
  City(name: 'Gurgaon', country: 'India', latitude: 28.4595, longitude: 77.0266, timezone: 'Asia/Kolkata'),
  City(name: 'Aligarh', country: 'India', latitude: 27.8974, longitude: 78.0880, timezone: 'Asia/Kolkata'),
  City(name: 'Jalandhar', country: 'India', latitude: 31.3260, longitude: 75.5762, timezone: 'Asia/Kolkata'),
  City(name: 'Bhubaneswar', country: 'India', latitude: 20.2961, longitude: 85.8245, timezone: 'Asia/Kolkata'),
  City(name: 'Salem', country: 'India', latitude: 11.6643, longitude: 78.1460, timezone: 'Asia/Kolkata'),
  City(name: 'Mira-Bhayandar', country: 'India', latitude: 19.2812, longitude: 72.8561, timezone: 'Asia/Kolkata'),
  City(name: 'Warangal', country: 'India', latitude: 17.9689, longitude: 79.5941, timezone: 'Asia/Kolkata'),
  City(name: 'Guntur', country: 'India', latitude: 16.3067, longitude: 80.4365, timezone: 'Asia/Kolkata'),
  City(name: 'Bhiwandi', country: 'India', latitude: 19.2812, longitude: 73.0488, timezone: 'Asia/Kolkata'),
  City(name: 'Saharanpur', country: 'India', latitude: 29.9640, longitude: 77.5460, timezone: 'Asia/Kolkata'),
  City(name: 'Gorakhpur', country: 'India', latitude: 26.7606, longitude: 83.3732, timezone: 'Asia/Kolkata'),
  City(name: 'Bikaner', country: 'India', latitude: 28.0229, longitude: 73.3119, timezone: 'Asia/Kolkata'),
  City(name: 'Amravati', country: 'India', latitude: 20.9374, longitude: 77.7796, timezone: 'Asia/Kolkata'),
  City(name: 'Noida', country: 'India', latitude: 28.5355, longitude: 77.3910, timezone: 'Asia/Kolkata'),
  City(name: 'Jamshedpur', country: 'India', latitude: 22.8046, longitude: 86.2029, timezone: 'Asia/Kolkata'),
  City(name: 'Bhilai', country: 'India', latitude: 21.1938, longitude: 81.3509, timezone: 'Asia/Kolkata'),
  City(name: 'Cuttack', country: 'India', latitude: 20.4625, longitude: 85.8830, timezone: 'Asia/Kolkata'),
  City(name: 'Firozabad', country: 'India', latitude: 27.1560, longitude: 78.4020, timezone: 'Asia/Kolkata'),
  City(name: 'Kochi', country: 'India', latitude: 9.9312, longitude: 76.2673, timezone: 'Asia/Kolkata'),
  City(name: 'Nellore', country: 'India', latitude: 14.4426, longitude: 79.9865, timezone: 'Asia/Kolkata'),
  City(name: 'Bhavnagar', country: 'India', latitude: 21.7645, longitude: 72.1519, timezone: 'Asia/Kolkata'),
  City(name: 'Dehradun', country: 'India', latitude: 30.3165, longitude: 78.0322, timezone: 'Asia/Kolkata'),
  City(name: 'Durgapur', country: 'India', latitude: 23.5126, longitude: 87.3228, timezone: 'Asia/Kolkata'),
  City(name: 'Asansol', country: 'India', latitude: 23.6739, longitude: 86.9524, timezone: 'Asia/Kolkata'),
  City(name: 'Rourkela', country: 'India', latitude: 22.2605, longitude: 84.8536, timezone: 'Asia/Kolkata'),
  City(name: 'Nanded', country: 'India', latitude: 19.1383, longitude: 77.3204, timezone: 'Asia/Kolkata'),
  City(name: 'Kolhapur', country: 'India', latitude: 16.7050, longitude: 74.2433, timezone: 'Asia/Kolkata'),
  City(name: 'Ajmer', country: 'India', latitude: 26.4499, longitude: 74.6399, timezone: 'Asia/Kolkata'),
  City(name: 'Akola', country: 'India', latitude: 20.7002, longitude: 77.0082, timezone: 'Asia/Kolkata'),
  City(name: 'Gulbarga', country: 'India', latitude: 17.3297, longitude: 76.8343, timezone: 'Asia/Kolkata'),
  City(name: 'Jamnagar', country: 'India', latitude: 22.4707, longitude: 70.0577, timezone: 'Asia/Kolkata'),
  City(name: 'Ujjain', country: 'India', latitude: 23.1765, longitude: 75.7819, timezone: 'Asia/Kolkata'),
  City(name: 'Loni', country: 'India', latitude: 28.7501, longitude: 77.2913, timezone: 'Asia/Kolkata'),
  City(name: 'Siliguri', country: 'India', latitude: 26.7271, longitude: 88.3953, timezone: 'Asia/Kolkata'),
  City(name: 'Jhansi', country: 'India', latitude: 25.4484, longitude: 78.5685, timezone: 'Asia/Kolkata'),
  City(name: 'Ulhasnagar', country: 'India', latitude: 19.2215, longitude: 73.1645, timezone: 'Asia/Kolkata'),
  City(name: 'Jammu', country: 'India', latitude: 32.7266, longitude: 74.8570, timezone: 'Asia/Kolkata'),
  City(name: 'Sangli-Miraj & Kupwad', country: 'India', latitude: 16.8524, longitude: 74.5815, timezone: 'Asia/Kolkata'),
  City(name: 'Mangalore', country: 'India', latitude: 12.9141, longitude: 74.8560, timezone: 'Asia/Kolkata'),
  City(name: 'Erode', country: 'India', latitude: 11.3410, longitude: 77.7172, timezone: 'Asia/Kolkata'),
  City(name: 'Belgaum', country: 'India', latitude: 15.8497, longitude: 74.4977, timezone: 'Asia/Kolkata'),
  City(name: 'Ambattur', country: 'India', latitude: 13.1147, longitude: 80.1481, timezone: 'Asia/Kolkata'),
  City(name: 'Tirunelveli', country: 'India', latitude: 8.7139, longitude: 77.7567, timezone: 'Asia/Kolkata'),
  City(name: 'Malegaon', country: 'India', latitude: 20.5579, longitude: 74.5089, timezone: 'Asia/Kolkata'),
  City(name: 'Gaya', country: 'India', latitude: 24.7914, longitude: 85.0002, timezone: 'Asia/Kolkata'),
  City(name: 'Jalgaon', country: 'India', latitude: 21.0077, longitude: 75.5626, timezone: 'Asia/Kolkata'),
  City(name: 'Udaipur', country: 'India', latitude: 24.5854, longitude: 73.7125, timezone: 'Asia/Kolkata'),
  City(name: 'Rajahmundry', country: 'India', latitude: 16.9891, longitude: 81.7832, timezone: 'Asia/Kolkata'),
  City(name: 'Tirupati', country: 'India', latitude: 13.6288, longitude: 79.4192, timezone: 'Asia/Kolkata'),
  
  // World Capitals
  City(name: 'London', country: 'UK', latitude: 51.5074, longitude: -0.1278, timezone: 'Europe/London'),
  City(name: 'New York', country: 'USA', latitude: 40.7128, longitude: -74.0060, timezone: 'America/New_York'),
  City(name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503, timezone: 'Asia/Tokyo'),
  City(name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522, timezone: 'Europe/Paris'),
  City(name: 'Sydney', country: 'Australia', latitude: -33.8688, longitude: 151.2093, timezone: 'Australia/Sydney'),
  City(name: 'Dubai', country: 'UAE', latitude: 25.2048, longitude: 55.2708, timezone: 'Asia/Dubai'),
  City(name: 'Singapore', country: 'Singapore', latitude: 1.3521, longitude: 103.8198, timezone: 'Asia/Singapore'),
  City(name: 'Berlin', country: 'Germany', latitude: 52.5200, longitude: 13.4050, timezone: 'Europe/Berlin'),
  City(name: 'Moscow', country: 'Russia', latitude: 55.7558, longitude: 37.6173, timezone: 'Europe/Moscow'),
  City(name: 'Beijing', country: 'China', latitude: 39.9042, longitude: 116.4074, timezone: 'Asia/Shanghai'),
  City(name: 'Toronto', country: 'Canada', latitude: 43.6510, longitude: -79.3470, timezone: 'America/Toronto'),
  City(name: 'Los Angeles', country: 'USA', latitude: 34.0522, longitude: -118.2437, timezone: 'America/Los_Angeles'),
];
