import 'package:flutter/material.dart';
import 'package:frigami/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frigami/models/calories.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:frigami/utils/globals.dart';
import 'dart:io';


class LoginImpactPage extends StatefulWidget {
  LoginImpactPage({Key? key}) :
    super(key: key);
    static const routename = 'LoginImpact';

   @override
  _LoginImpactPageState createState() => _LoginImpactPageState();
}

class _LoginImpactPageState extends State<LoginImpactPage> {//implements Impact
  TextEditingController emailController = TextEditingController(); //A controller in our context is used to read the values from the input. Using a controller, you'll be able to control its associated component.
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginImpact'),
      ),

      body: 
        Padding(//The Form accepts a child. It can accept only one component.
          //DA SISTEMARE tutti i padding (causa overflow)
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
          child: Column( //This Padding widget also accepts only one child.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) { //If the user’s input isn’t valid, the validator function returns a String containing an error message.
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email'; //B0ifxQL4W5
                    }
                    return null; //If there are no errors, the validator must return null
                  },
                ),
              ),
              
              
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password'; //12345678!
                    }
                    return null;
                  },
                ),
              ),


              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await _isImpactUp();
                      final message = result
                          ? 'IMPACT backend is up!'
                          : 'IMPACT backend is down!';
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                      
                      await _getAndStoreTokens(emailController.text, passwordController.text);
                      await _requestData(); 
                    // da gestire i refresh token 
                    //mando subito alla home che dovrebbe aggiornare i grafici
                    Navigator.pop(context);// NON VA? Voglio che vada immediatamente alla home (e che cambi l'app bar icon di acesso?)
                    //potrei metterci sopra una icona "eseguito con successo" che con padding 
                    //copra tutto il resto e sotto un bottone di ritorno alla home?
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
  
}


// volendo, per alcune info ...
// https://www.freecodecamp.org/news/how-to-build-a-simple-login-app-with-flutter/


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
    print(response.statusCode);
  } 

    //Just return the status code
    //return response.statusCode;
} //_getAndStoreTokens

//This method allows to check if the IMPACT backend is up
//Si potrebbe usare come metodo da mandare appena si accede all'app
//e fornire una notifica se la backend è down
Future<bool> _isImpactUp() async {

  //Create the request
  final url = Impact.baseUrl + Impact.pingEndpoint; // TUTTI I Impact. ... sarebbero da cambire perchè sta tutto nella stessa classe

  //Get the response
  //print('Calling: $url');
  final response = await http.get(Uri.parse(url));

  //Just return if the status code is OK
  return response.statusCode == 200;
} //_isImpactUp






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
      //var lastC = Calories.fromJson(decodedResponse['data']['date'], decodedResponse);
      //lastC.lastcal(decodedResponse);
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
