import 'package:frigami/database/entities/products.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class ProductsDao {

  //Query #1: SELECT -> per ottenere tutte le entries della tabella Products
  @Query('SELECT * FROM Products')
  Future<List<Products>> findAllProducts();

  //Query #2: INSERT -> this allows to add a Product in the table
  @insert
  Future<void> insertProduct(Products product);
  //When using the capitalized @Insert you can specify a conflict 
  //strategy. Else it just defaults to aborting the insert.
  //Example:
  //@Insert(onConflict:
  //OnConflictStrategy.rollback)
  //Future<void> insertPerson(Person person);

  //voglio una query che mi permetta di avere i prossimi in scadenza
  //@Query('SELECT * FROM Products WHERE bestBefore = : bestBefore')
  //Stream<Products?> findProductsByDate(DateTime bestBefore); //ritorna prodotti come streams

  //Query #3: DELETE -> this allows to delete a Product from the table
  @delete
  Future<void> deleteProducts(Products task);

  //Query #4: UPDATE -> this allows to update a Product entry
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateProducts(Products product);
  
}//MealDao