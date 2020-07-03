class Batch {
  final String event, distance, temperature, humidity, rain, flowlevel;

  Batch({
    this.event,
    this.distance,
    this.temperature,
    this.humidity,
    this.rain,
    this.flowlevel,
  });
  factory Batch.fromJson(Map<String, dynamic> jsonData) {
    return Batch(
        event: jsonData['event'],
        distance: jsonData['distance'],
        temperature: jsonData['temperature'],
        humidity: jsonData['humidity'],
        rain: jsonData['rain'],
        flowlevel: jsonData['flowlevel']);
  }
}
