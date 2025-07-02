





import 'package:couteau/src/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: appBarTitle('Inicio')
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                Image.asset(
                'assets/images/caja-de-herramientas.png',
                scale: 2.5,
                ),
              
                homeCard(
                  context: context,
                  icon: Icons.wc, 
                  title: 'Predecir Genero', 
                  onNavigate: 1 
                ),
                homeCard(
                  context: context,
                  icon: Icons.numbers, 
                  title: 'Predecir Edad', 
                  onNavigate: 2
                ),
                homeCard(
                  context: context,
                  icon: Icons.search, 
                  title: 'Buscar Universidad', 
                  onNavigate: 3 
                ),
                homeCard(
                  context: context,
                  icon: Icons.water_drop_outlined, 
                  title: 'Situacion Climatica', 
                  onNavigate: 4 
                ),
                homeCard(
                  context: context,
                  icon: Icons.catching_pokemon, 
                  title: 'Buscar Pokemon', 
                  onNavigate: 5 
                ),
                homeCard(
                  context: context,
                  icon: Icons.newspaper, 
                  title: 'Tablon de Noticias', 
                  onNavigate: 6 
                ),
                homeCard(
                  context: context,
                  icon: Icons.verified_user, 
                  title: 'Contratame', 
                  onNavigate: 7 
                ),
                SizedBox(height: 30)
            ],
          )
        )
      ),
    );
  }
}