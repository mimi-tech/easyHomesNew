class Matrix {
  //Constructor
  dynamic destination;
  dynamic origin;
  dynamic distance;
  dynamic duration;
  dynamic traffic;
  //int score;

  Matrix.fromJson(Map json) {
    this.destination = json['destination_addresses'];
    this.origin = json['origin_addresses'];
    this.distance = json['distance'];
    this.duration = json['duration'];
    this.traffic = json['duration_in_traffic'];
  }
}