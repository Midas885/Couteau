







class ClimaModel {
  final double temperatura;
  final int weatherCode;

  ClimaModel({required this.temperatura, required this.weatherCode});
}


Map<int, Map<String, String>> weatherMap = {
  0: {'desc': 'Despejado', 'icon': '☀️'},
  1: {'desc': 'Mayormente despejado', 'icon': '🌤️'},
  2: {'desc': 'Parcialmente nublado', 'icon': '⛅'},
  3: {'desc': 'Nublado', 'icon': '☁️'},
  45: {'desc': 'Niebla', 'icon': '🌫️'},
  51: {'desc': 'Llovizna ligera', 'icon': '🌦️'},
  61: {'desc': 'Lluvia ligera', 'icon': '🌧️'},
  71: {'desc': 'Nieve ligera', 'icon': '🌨️'},
  95: {'desc': 'Tormenta', 'icon': '⛈️'},
};

