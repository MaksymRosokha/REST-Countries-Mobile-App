import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/country.dart';

class DetailScreen extends StatelessWidget {
  final String name;

  DetailScreen({required this.name});

  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: FutureBuilder<Country>(
        future: api.fetchDetails(name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Data loading error",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final country = snapshot.data!;

          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141E30), Color(0xFF243B55)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country.flag + " " + country.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      Text("Official: ${country.officialName}"),
                      const SizedBox(height: 10),

                      Text("🏛 Capital: ${country.capital}"),
                      Text("🌍 Region: ${country.region}"),
                      Text("🗺 Subregion: ${country.subregion}"),

                      const SizedBox(height: 10),

                      Text("👥 Population: ${country.population}"),
                      Text("📏 Area: ${country.area} km²"),

                      const SizedBox(height: 10),

                      Text("💰 Currency: ${country.currency}"),
                      Text("🗣 Language: ${country.language}"),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}