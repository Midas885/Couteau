


/*
    Carlos Perez Divair
    Mat: 2023-1200
 */


import 'dart:convert';

import 'package:couteau/src/models/gender_predicted_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:couteau/src/widgets/custom_widgets.dart';

class GenderPredictorScreen extends StatefulWidget {
  const GenderPredictorScreen({super.key});

  @override
  createState() => _GenderPredictorScreenState();
}

class _GenderPredictorScreenState extends State<GenderPredictorScreen> {
  GenderPredictedModel? predictedModel;
  bool isPredicted = false;
  final nombreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Predecir Genero'),
      ),

      body: Center( 
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              if (isPredicted)
                if (predictedModel != null)
                  _predictedData(predictedModel!),

              SizedBox(height: 15,),

              textFiled(
                controller: nombreController, 
                icon: Icons.abc, 
                labelText: 'Nombre', 
                hintText: 'Ingresa un nombre', 
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
      child: Text('Predecir'),
      onPressed: () async {
        if (nombreController.text.isNotEmpty) {
          final exito = await _predecirGenero(nombreController.text);
          setState(() {
            isPredicted = exito;
          });
            
        } else {
          setState(() {
            showSnackBar(context, 'Por favor ingrese un nombre', isError: true);
            isPredicted = false;
          });    
        }
      }
    );
  }

  Widget _predictedData(GenderPredictedModel model) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          model.genero == 'male' 
          ? Icon(
              Icons.man,
              color: Colors.blue,
              size: 50,
            ) 
          : Icon(
              Icons.woman,
              color: Colors.pink,
              size: 50,
            ),
          SizedBox(height: 10,),
          infoRow(Icons.abc, 'Nombre', model.nombre),
          infoRow(Icons.transgender, 'Genero', model.genero),
          infoRow(Icons.trending_up, 'Probabilidad', '${model.probabilidad * 100}%'),
          infoRow(Icons.numbers, 'Conteo', model.conteo.toString())
        ],
      ),
    );
  }



  Future<bool> _predecirGenero(String nombre) async {
    try {
      final url = Uri.parse('https://api.genderize.io/?name=$nombre');
      final respuesta = await http.get(url);
  
      if( respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        predictedModel = GenderPredictedModel(
          nombre: datos['name'], 
          genero: datos['gender'], 
          probabilidad: datos['probability'], 
          conteo: datos['count']
        );

        return true;
      } else  {
        if (mounted) {
          showSnackBar(context, 'Error al predecir genero: ${respuesta.statusCode}', isError: true);
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error al predecir genero: $e', isError: true);
      }
      return false;
    }
  }
}