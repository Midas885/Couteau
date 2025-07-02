






import 'dart:convert';

import 'package:couteau/src/models/clima_model.dart';
import 'package:couteau/src/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Situacion climatica del dia'),
      ),

      body: Center (
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [ 
              FutureBuilder<ClimaModel?>(
                future: _obtenerClima(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Text('No se pudo obtener el clima');
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: _climaWidget(snapshot.data!),
                    );
                  }
                }, 
              ),
            ]
          )
        )
      )
    );
  }



  Future<ClimaModel?> _obtenerClima() async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=18.48&longitude=-69.9&current=temperature_2m,weathercode&timezone=auto',
      );

      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);
        final current = data['current'];

        return ClimaModel(
          temperatura: current['temperature_2m'].toDouble(),
          weatherCode: current['weathercode'],
        );
      } else {
        if (mounted) {    
          showSnackBar(context, 'Error al obtener clima: ${respuesta.statusCode}', isError: true);
        }
        return null;
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error al obtener clima: $e', isError: true);
      }
      return null;
    }
  }

  
  Widget _climaWidget(ClimaModel clima) {
    final info = weatherMap[clima.weatherCode] ??
    {'desc': 'Desconocido', 'icon': '❓'};

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Clima en Santo Domingo',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 20),
        Text(
          info['icon']!,
          style: TextStyle(fontSize: 64),
        ),
        SizedBox(height: 10),
        Text(
          info['desc']!,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${clima.temperatura.toStringAsFixed(1)} °C',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}