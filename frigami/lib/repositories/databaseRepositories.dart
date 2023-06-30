import 'package:frigami/database/database.dart';
import 'package:frigami/database/entities/products.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //This method wraps the findAllProducts() method of the DAO
  Future<List<Products>> findAllProducts() async{
    final results = await database.productsDao.findAllProducts();
    return results;
  }//findAllMeals

  //This method wraps the insertMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertProduct(Products prod)async {
    await database.productsDao.insertProduct(prod);
    notifyListeners();
  }

  //This method wraps the deleteMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> removeProducts(Products prod) async{
    await database.productsDao.deleteProducts(prod);
    notifyListeners();
  }
  
  //This method wraps the updateMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> updateProducts(Products prod) async{
    await database.productsDao.updateProducts(prod);
    notifyListeners();
  }

}