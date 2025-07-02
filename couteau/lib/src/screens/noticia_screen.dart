





/*
    Carlos Perez Divair
    Mat: 2023-1200
 */



import 'dart:convert';

import 'package:couteau/src/models/noticia_model.dart';
import 'package:couteau/src/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Tablon de Noticias'),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder<List<NoticiaModel>>(
                future: _obtenerNoticias(), 
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator.adaptive();
                  } else if (snapshot.hasError) {
                    showSnackBar(context, 'Error al cargar noticias: ${snapshot.error}', isError: true);
                    return Text('No se pudieron cargar noticias');
                  } else {
                    return _noticiasWidget(snapshot.data!);
                  }
                }
              )
            ],
          ),
        )
      ),
    );
  }



  Future<List<NoticiaModel>> _obtenerNoticias() async {
    final url = Uri.parse('https://kinsta.com/wp-json/wp/v2/posts?per_page=3&_embed');

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final data = jsonDecode(respuesta.body);
      return (data as List).map((item) {
        return NoticiaModel(
          titulo: item['title']['rendered'],
          resumen: item['excerpt']['rendered']
            .replaceAll(RegExp(r'<[^>]*>'), '') // limpia etiquetas HTML
            .trim(),
          url: item['link'],
        );
      }).toList();
    } else {
      if (mounted) {
        showSnackBar(context, 'Error al obtener noticias: ${respuesta.statusCode}', isError: true);
      }
      return [];
    }
  }





  Widget _noticiasWidget(List<NoticiaModel> noticias) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.network(
            'https://kinsta.com/wp-content/uploads/2023/12/kinsta-logo.jpeg',
            height: 60,
          ),
        ),
        SizedBox(height: 20),
        ...noticias.map((n) => Card(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(n.resumen),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => launchUrl(Uri.parse(n.url)),
                    child: Text('Visitar noticia'),
                  ),
                )
              ],
            ),
          ),
        ))
      ],
    );
  }
}