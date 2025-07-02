










import 'dart:convert';

import 'package:couteau/src/models/age_predicted_model.dart';
import 'package:couteau/src/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgePredictorScreen extends StatefulWidget {
  const AgePredictorScreen({super.key});

  @override
  State<AgePredictorScreen> createState() => _AgePredictorScreenState();
}

class _AgePredictorScreenState extends State<AgePredictorScreen> {
  AgePredictedModel? predictedModel;
  bool isPredicted = false;
  final nombreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Predecir Edad'),
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
          final exito = await _predecirEdad(nombreController.text);
          if (mounted) {
            setState(() {
              isPredicted = exito;
            });
          }
        } else {
          if (mounted) {
            showSnackBar(context, 'Por favor ingrese un nombre', isError: true);
            setState(() {
              isPredicted = false;
            });
          }
        }
      }  
    );
  }

  Widget _predictedData(AgePredictedModel model) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          model.edad >= 15 && model.edad <=28  
          ? Image.network('https://i.pinimg.com/736x/ce/84/28/ce84283a7b48946f200a4e86d30844fc.jpg')
          : ( model.edad >= 29 && model.edad <= 44 
            ?
            Image.network('https://i.pinimg.com/736x/de/55/1d/de551d3efa8701e83b54ec43617d0942.jpg')
            : 
            Image.network('https://i.pinimg.com/736x/ea/01/56/ea0156635ae14c8d6105af608dca2a2e.jpg')
          ),
          SizedBox(height: 10,),
          infoRow(Icons.abc, 'Nombre', model.nombre),
          infoRow(Icons.transgender, 'Edad', model.edad.toString()),
          infoRow(Icons.numbers, 'Conteo', model.conteo.toString())
        ],
      ),
    );
  }



  Future<bool> _predecirEdad(String nombre) async {
    try {
      final url = Uri.parse('https://api.agify.io/?name=$nombre');
      final respuesta = await http.get(url);
  
      if( respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        predictedModel = AgePredictedModel(
          nombre: datos['name'], 
          edad: datos['age'], 
          conteo: datos['count']
        );

        return true;
      } else  {
        if (mounted) {
          showSnackBar(context, 'Error al predecir edad: ${respuesta.statusCode}', isError: true);
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error al predecir edad: $e', isError: true);
      }
      return false;
    }
  }
}