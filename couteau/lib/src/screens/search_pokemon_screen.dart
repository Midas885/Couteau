








import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:couteau/src/models/pokemon_model.dart';
import 'package:couteau/src/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPokemonScreen extends StatefulWidget {
  const SearchPokemonScreen({super.key});

  @override
  State<SearchPokemonScreen> createState() => _SearchPokemonScreenState();
}

class _SearchPokemonScreenState extends State<SearchPokemonScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }



  
  PokemonModel? pokemon;
  bool isPredicted = false;
  final nombreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Buscar Pokemon'),
      ),

      body: Center( 
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              if (isPredicted)
                if (pokemon != null)
                  _pokemonInfo(pokemon!),

              SizedBox(height: 15,),

              textFiled(
                controller: nombreController, 
                icon: Icons.abc, 
                labelText: 'Pokemon', 
                hintText: 'Ingresa el nombre del pokemon', 
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
      child: Text('Bucar'),
      onPressed: () async {
        if (nombreController.text.isNotEmpty) {
          final exito = await _buscarPokemon(nombreController.text);
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

  Widget _pokemonInfo(PokemonModel model) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(model.imagen, height: 200),
        const SizedBox(height: 10),
        infoRow(Icons.abc, 'Nombre', model.nombre.toUpperCase()),
        infoRow(Icons.flash_on, 'Experiencia', '${model.experienciaBase} XP'),
        infoRow(Icons.auto_awesome, 'Habilidades', model.habilidades.join(', ')),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            _audioPlayer = AudioPlayer();
            await _audioPlayer.play(UrlSource(model.sonido));
          },
          icon: Icon(Icons.volume_up),
          label: Text('Reproducir sonido'),
        )
      ],
    );
  }

  Future<bool> _buscarPokemon(String nombre) async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/${nombre.toLowerCase()}');
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);

        pokemon = PokemonModel(
          nombre: data['name'],
          imagen: data['sprites']['other']['official-artwork']['front_default'],
          experienciaBase: data['base_experience'],
          habilidades: (data['abilities'] as List)
            .map((a) => a['ability']['name'] as String)
            .toList(),
          sonido: data['cries']['latest'],
        );

        if (respuesta.statusCode == 200 && pokemon == null) {
          if (mounted) {
            showSnackBar(context, 'No se encontro el pokemon: $pokemon');
            return false;
          }
        }

        return true;
      } else {
        if (mounted) {
          showSnackBar(context, 'Pokemon no encontrado: ${respuesta.statusCode}', isError: true);
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error al buscar Pokémon: $e', isError: true);
      }
      return false;
    }
  }
}