import 'package:intl/intl.dart';

class Calories{
  late DateTime time;
  late double value;

  Calories({required this.time, required this.value});

  Calories.fromJson(String date, Map<String, dynamic> json) {
    time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}');
    value = double.parse(json["value"]);
     
  }
  //Calories.fromJson(String date, Map<String, dynamic> json) {
  //  time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}');
  //  value = double.parse(json["value"]);
  //}
  
  //void lastcal(json){
  //  List<Calories>? result = [];
  //  int i = json['data']['data'].length;
  //  result.add(json['data']['data'][i]);
  //}

  @override
  String toString() {
    return 'Calories(time: $time, value: $value)'; // vengono ritornate le calore per ogni ora
  }//toString


}//Steps

class LastCalorie{
  late double value; //voglio che sia inizializzata in seguito in base a ciò che arriva
  
  LastCalorie(double value){
    this.value = value; //this. fa riferimento all'istanza singola (nel momento in cui viene prodotto lo specifico oggetto il value avrà il valore di quella specifica istanza)
  }
  
}


class Calor {
  final DateTime time;
  final List<double> value;

  Calor({required this.time, required this.value});

  factory Calor.fromJson(Map<String, dynamic> json) {
    return Calor(
      value: json["value"] as List<double>,
      time: json["time"] 
    );
  }
}