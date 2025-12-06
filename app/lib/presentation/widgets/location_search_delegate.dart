import 'package:flutter/material.dart';
import '../../data/city_data.dart';

class LocationSearchDelegate extends SearchDelegate<City?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    final results = majorCities.where((city) =>
        city.name.toLowerCase().contains(query.toLowerCase()) ||
        city.country.toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results.elementAt(index);
        return ListTile(
          title: Text(city.name),
          subtitle: Text(city.country),
          onTap: () {
            close(context, city);
          },
        );
      },
    );
  }
}
