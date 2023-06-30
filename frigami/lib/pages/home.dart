import 'package:flutter/material.dart';
import 'package:frigami/pages/fridge.dart';
import 'package:frigami/pages/loginImpact.dart';
import 'package:frigami/pages/profile.dart';
import 'package:frigami/widgets/score_circular_progress.dart';
import 'package:frigami/utils/globals.dart';


import 'package:frigami/models/calories.dart';
import 'package:frigami/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';



class HomePage extends StatelessWidget {
  const HomePage({Key? key}) :
    super(key: key);
    static const routename = 'Homepage';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
        actions: [
          IconButton(
            onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginImpactPage()));
                  }, 
            icon: Icon(Icons.login), //aggiungere scritta login piccolo sotto
            
            //tooltip: 'Login',
            )
        ],
      ),

      drawer: Drawer(
        child: Column(mainAxisAlignment:MainAxisAlignment.center,
          children: [
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.favorite),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FridgePage()));
                  },
                ),
              title: Text('Fridge'),
              subtitle: Text('ListTile 1 subtitle'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_right),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FridgePage()));
                  },
              )  
            ),
            
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Profile'),
              subtitle: Text('ListTile 2 subtitle'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_right),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
              )
            ),
          ],
        ),
      ),
        
      body: Center(
      child: Column(mainAxisAlignment:MainAxisAlignment.center,
        children: <Widget>[

        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 150,
            height: 150,
            child:CustomPaint(
              painter: const ScoreCircularProgress(
                backColor: Color(0xFFFF5722), 
                frontColor: Color(0xFF89453C), 
                strokeWidth: 15, 
                value: 0.3 //qui chiamo la funzione di funzione!!
                ),

              child: Align(
                alignment: Alignment.center,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('Intakes:'),
                        Text('0.3 of 1'),
                        ]))))
              )
            ),
          ),
        ]
      ),
      ),
      
      floatingActionButton:FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      
      bottomNavigationBar:BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),label: 'Settings',
          )
        ],
      ),
      
    );
  } //build
} //HomePage

Future<void> _getAndStoreTokens(String username,String password) async {

  //Create the request
  final url = Impact.baseUrl + Impact.tokenEndpoint;
  final body = {'username': username, 'password': password};

  //Get the response
  //print('Calling: $url');
  final response = await http.post(Uri.parse(url), body: body);

  //If response is OK, decode it and store the tokens. Otherwise do nothing.
  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);
    final sp = await SharedPreferences.getInstance();
    await sp.setString('access', decodedResponse['access']);
    await sp.setString('refresh', decodedResponse['refresh']);
    //print(response.statusCode);
  } 

    //Just return the status code
    //return response.statusCode;
} //_getAndStoreTokens


// miserve una funzione che ritorni i dati di calorie forniti i 
// token necessari (non serve perchè ci sono negli sp con l'accesso,
// MA SE ANCORA NON HO FATTO L'ACCESSO voglio un avviso ??).

// Fornisce una lista di 'Calories'? Gli steps sono ogetti che creo in models
// formati da 'time' e 'value' di ogni dato richiesto

Future<List<Calories>?> _requestData() async {
  //Initialize the result
  List<Calories>? result;

  //Get the stored access token (this code does not work if the tokens are null)
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');

  if (access == null) {
    SnackBar snackBar = SnackBar(content: Text('Necessario autenticarsi a IMPACT per aggiornare la home'));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  //If access token is expired, refresh it
  if(JwtDecoder.isExpired(access!)){
    await _refreshTokens();
    access = sp.getString('access');
  }//if

    //Create the (representative) request
    final day = '2023-05-04';
    final url = Impact.baseUrl + Impact.caloriesEndpoint + Impact.patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      result = [];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        result.add(Calories.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]));
      }//for
      print(result);
      print(result.last);
    } //if
    else{
      result = null;
      SnackBar snackBar = SnackBar(content: Text('Accesso ai dati non eseguito'));
      snackbarKey.currentState?.showSnackBar(snackBar);
    }//else

    //Return the result
    return result;

  } //_requestData


  Future<int> _refreshTokens() async {

    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    //Get the respone
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If 200 set the tokens
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Return just the status code
    return response.statusCode;

  } //_refreshTokens



