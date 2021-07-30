import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final _peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'Spiderman',
    'Batman',
    'Superman',
    'Ironman',
    'Hulk',
    'Thor',
    'Thor 2',
    'Thor 3',
    'Thor 4',
  ];
  final peliculasRecientes = [
    'Batman',
    'Superman',
    'Ironman',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: Acciones del AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: Icono a la izq del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: Crea los resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Las sugerencias al escribir

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: _peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
              children: peliculas.map((pelicula) {
            return ListTile(
              onTap: () {
                close(context, null);
                pelicula.uniqueId = '';
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.originalTitle),
            );
          }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

/*     final listaBusqueda = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((pelicula) =>
                pelicula.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaBusqueda.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaBusqueda[index]),
          onTap: () {
            showResults(context);
          },
        );
      }, 
    );*/
  }
}
