import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) :
    super(key: key);
    static const routename = 'Profile';
    
    

  @override
  Widget build(BuildContext context) {
    return Scaffold( //se ritorno solo body, appBar rimane invariato?
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: const Center(
        child: ProfileData(), //classe che mi permette di fare solo il "Center" statefull
      ),
    );
  }
}

class ProfileData extends StatefulWidget{
  const ProfileData({Key? key}) : super(key: key);
  
  @override
  _ProfileDataState createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData>{
  List<String> listSex = <String>['Male', 'Female'];
  String? _selectedValue; //variabile privata?

  @override
  void initState() {
    _selectedValue = null;
    super.initState();
  }//initState

  @override
  Widget build(BuildContext buildContext) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // foto profilo circolare da fare
          children: [
            FutureBuilder(
              future: SharedPreferences.getInstance(), // devo inserire un metodo async(getInstance)  
              builder: (context, snapshot) { //context contiene l'albero dei Widget usati nell'app, mentre 
              // l'altro è async e mi collega a getInstance; Il tutto restituirà un widget (es.: CircularProgressIndicator)
              if (snapshot.hasData){
                final sp = snapshot.data as SharedPreferences;
                if (sp.getString('sex') == null){//se la chiave corrispondente a sex ha valore nullo 
                  return DropdownButton(
                    hint: Text('Select'),
                    items: listSex.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(value: value, child: Text(value),); }).toList(),
                    onChanged: (String? newValue) {_changeItem(newValue);} );
                } else { //altrimenti metto come hint il valore di sp già scelto
                  return DropdownButton(
                    value: sp.getString('sex'),
                    items: listSex.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(value: value, child: Text(value),); }).toList(), 
                    onChanged: (String? newValue) {_changeItem(newValue);} );
                }

                





              } else {
                return CircularProgressIndicator();
              }

              }
              
            )
        ],
    );    
  }//build 

  //Private method to set a _changeItem
  //con questo metodo prima setto il nuovo valore selezionato della corrispettiva chiave
  //e poi modifico lo stato della variabile privata in modo da aggiornare la tendina
  Future<void> _changeItem(newValue) async{ // void = funzione che non ritorna nulla
    final sp = await SharedPreferences.getInstance();
    await sp.setString('sex', newValue!);
    setState(() {
      _selectedValue = newValue; // setState notifies the Flutter framework that the state might be changed
    });
  }//_changeItem



}//_ProfileDataState






//https://api.flutter.dev/flutter/material/DropdownButton-class.html
//https://m2.material.io/components/menus#exposed-dropdown-menu
//https://pub.dev/packages/dropdown_button2


