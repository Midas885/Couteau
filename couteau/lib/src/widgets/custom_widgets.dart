



import 'package:couteau/src/screens/acercade_screen.dart';
import 'package:couteau/src/screens/age_predictor_screen.dart';
import 'package:couteau/src/screens/clima_screen.dart';
import 'package:couteau/src/screens/gender_predictor_screen.dart';
import 'package:couteau/src/screens/noticia_screen.dart';
import 'package:couteau/src/screens/search_pokemon_screen.dart';
import 'package:couteau/src/screens/university_in_country.dart';
import 'package:flutter/material.dart';

Widget appBarTitle(String title){
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold
    ),
  );
}

Widget infoRow(IconData icon, String title, String subtitle) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );
}

Widget homeCard({
  required BuildContext context,
  required IconData icon, 
  required String title, 
  required int onNavigate}) {
  return Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios
      ),
      onTap: () {
        Navigator.push(
        context, 
          MaterialPageRoute(builder: (context) =>  navigateTo(onNavigate))
        );
        
      },
    ),
  );
}


void showSnackBar(BuildContext context, String message,{ bool isError = false }) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
    )
  );
}

void showStatus(BuildContext context, String title){ 

}


Widget navigateTo(int value) {
  switch (value) {
    case 1:
      return const GenderPredictorScreen();
    case 2:
      return const AgePredictorScreen();
    case 3:
      return const UniversityInCountry();
    case 4:
      return const ClimaScreen();
    case 5:
      return const SearchPokemonScreen();
    case 6:
      return const NoticiaScreen();
    case 7:
      return const AcercadeScreen();
    default:
      return SnackBar(content: Text('Esta direccion no es valida'));
  }
}

Widget textFiled({
  required TextEditingController controller,
  required IconData icon, 
  required String labelText, 
  required String hintText,
  required TextInputType textInputType,
  required ValueChanged onChanged }) {

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        label: Text(labelText),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)
        )
      ),
      autocorrect: true,
      onChanged: onChanged,
    );
}