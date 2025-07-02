



import 'package:couteau/src/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class AcercadeScreen extends StatelessWidget {
  const AcercadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: appBarTitle('Contratame'),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/watashi.jpg'),
                radius: 100,
              ),
              SizedBox(height: 10,),
              Text(
                'Datos Personales',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              infoRow(Icons.abc, 'Nombre', 'Carlos'),
              infoRow(Icons.abc_sharp, 'Apellidos', 'Perez Divair'),
              infoRow(Icons.numbers, 'Matricula', '2023-1200'),
              infoRow(Icons.phone_callback, 'Telefono', '(809) 789-6182'),
              infoRow(Icons.email, 'Correo', '20231200@itla.edu.do'),
              infoRow(Icons.school, 'Carrera', 'Desarrollo de Software')
            ],
          )
        ),
      ),
    );
  }
}