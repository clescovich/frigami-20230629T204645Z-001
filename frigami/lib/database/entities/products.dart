import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@Entity(tableName: 'products') //opens up the possibility to use a custom name for
                              //that specific entity instead of using the class name
class Products {
  //id will be the primary key of the table. Moreover, it will be autogenerated.
  //id is nullable since it is autogenerated.
  @PrimaryKey(autoGenerate: true)
  final int? code; 

  final String name;
 
  final DateTime bestBefore;


  //Default constructor
  Products(this.code, this.name, this.bestBefore);
  
}