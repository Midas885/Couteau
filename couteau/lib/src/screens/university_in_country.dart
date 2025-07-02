




import 'dart:convert';

import 'package:couteau/src/models/university_model.dart';
import 'package:couteau/src/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UniversityInCountry extends StatefulWidget {
  const UniversityInCountry({super.key});

  @override
  State<UniversityInCountry> createState() => _UniversityInCountryState();
}

class _UniversityInCountryState extends State<UniversityInCountry> {
  List<UniversityModel> universities = [];
  bool asResults = false;
  final paisController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Buscar Universidades'),
      ),

      body: Center( 
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              if (asResults)
                if (universities.isNotEmpty)
                  _resultados(universities),

              SizedBox(height: 15,),

              textFiled(
                controller: paisController, 
                icon: Icons.abc, 
                labelText: 'Pais', 
                hintText: 'Ingresa el nombre de un pais', 
                textInputType: TextInputType.text, 
                onChanged: (value) {}
              ),

              SizedBox(height: 15,),
              _submitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (paisController.text.isNotEmpty) {
          final exito = await _buscarUniversidades(paisController.text);
          setState(() {
            asResults = exito;
          });
        } else {
          setState(() {
            showSnackBar(context, 'Por favor ingrese un nombre', isError: true);
            asResults = false;
          });
            
        }
      }, 
      child: Text('Buscar')
    );
  }

  Widget _resultados(List<UniversityModel> universities) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          for (var university in universities)
            infoRow(Icons.school, university.nombre, 'Dominio: ${university.dominio}\nWeb: ${university.webPages}'),
        ],
      ),
    );
  }



  Future<bool> _buscarUniversidades(String pais) async {
  try {
    final url = Uri.parse('http://universities.hipolabs.com/search?country=$pais');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);

      universities.clear(); 

      for (var dato in datos) {
        universities.add(
          UniversityModel(
            nombre: dato['name'],
            dominio: (dato['domains'] as List).first,
            webPages: (dato['web_pages'] as List).first,
          ),
        );
      }

      if (respuesta.statusCode == 200 && universities.isEmpty) {
        if (mounted) {
          showSnackBar(context, 'No se encontraron unibersidades en: $pais');
          return false;
        }
      }

      return true;
    } else {
      if (mounted) {
        showSnackBar(context, 'Error al buscar universidades: ${respuesta.statusCode}', isError: true);
      }
      return false;
    }
  } catch (e) {
    if (mounted) {
      showSnackBar(context, 'Error al buscar universidades: $e', isError: true);
    }
    return false;
  }
}

}