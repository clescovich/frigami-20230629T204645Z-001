import 'package:flutter/material.dart';
import 'package:frigami/database/entities/products.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:frigami/utils/formats.dart';

class FridgePage extends StatelessWidget {
  const FridgePage({Key? key}) :
    super(key: key);
    static const routename = '    FRIDGE    ';
  
  @override
  Widget build(BuildContext context) {
      //Print the route display name for debugging
    print('${FridgePage.routename} built');

    return Scaffold(
      appBar: AppBar(
      title: Text(FridgePage.routename),
      ),

      body: Center(
        //faccio vedere la lista dei prodotti con una lista. Uso il consumer del database
        // per aggiornare la lista  
        child: Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            
            //Chiedo tutta la lista di prodotti nel frigo usando dbr.findAllProducts()
            //(il medoto ritorna un tipo Future quindi uso FutureBuilder) 
            
            //Il futureBuilder ritorna un CircularProgressIndicator 
            //mentre "inserisce" tutti i dati la cui "sorgente" è 
            //il metodo async findAllProducts.
            //Context contiene l'albero dei Widget usati nell'app, mentre 
            //l'altro è async e mi collega in qualche modo alla sorgente; 
            //Il tutto restituirà un widget (es.: CircularProgressIndicator)
            
            return FutureBuilder(
              initialData: null,
              future: dbr.findAllProducts(), // devo inserire un metodo async
              builder:(context, snapshot) {
                if(snapshot.hasData){
                  final data = snapshot.data as List<Products>;
                  //Se la tabella è vuota fornisco un messaggio
                  return data.isEmpty ? Text('The list is currently empty') : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //Sfrutto l'oggeto Card per visualizzare i prodotti
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(MdiIcons.pasta),
                          trailing: Icon(MdiIcons.noteEdit),
                          title:
                              Text('Name : ${data[index].name}'), //fornisco il nome dell'elemento (su entities)
                          subtitle: Text('${Formats.fullDateFormatNoSeconds.format(data[index].bestBefore)}'),
                          //When a ListTile is tapped, the user is redirected to the MealPage, where it will be able to edit it.
                          //onTap: () => _toMealPage(context, data[index]),
                        ),
                      );
                    });
                }//if
                else{
                  return CircularProgressIndicator();
                }//else
              },//FutureBuilder builder 
            );
          }//Consumer-builder
        ),
      ),
      //Here, I'm using a FAB to let the user add new meals.
      //Rationale: I'm using null as meal to let MealPage know that we want to add a new meal.
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.plus),
        onPressed: (){} //=> _toMealPage(context, null),
      ),
      
      
    
    );
  } //build
} //FridgePage