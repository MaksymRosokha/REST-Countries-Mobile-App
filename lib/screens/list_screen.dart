import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/local_db.dart';
import '../models/country.dart';
import '../screens/detail_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final api = ApiService();
  final db = LocalDb();

  List<Country> countries = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final cached = db.get();
      if (cached.isNotEmpty && mounted) {
        setState(() {
          countries = cached;
          loading = false;
        });
      }

      if (cached.isEmpty) {
        final data = await api.fetchAll();
        if (mounted) {
          setState(() {
            countries = data;
            loading = false;
          });
          db.save(data);
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          error = "The data could not be retrieved";
          loading = false;
        });
      }
    }
  }

  void _checkIfEmptyAndReload() {
    if (countries.isEmpty) {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌍 REST Countries", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white, size: 28),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Confirmation"),
                    content: const Text("Are you sure you want to delete all countries? They will be reloaded from the API."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await db.deleteAll();
                          setState(() {
                            countries.clear();
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("All countries were deleted!")),
                          );

                          Navigator.pop(context);
                          _checkIfEmptyAndReload();
                        },
                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "Countries available: ${countries.length}",
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Builder(
                  builder: (_) {
                    if (loading && countries.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (error != null && countries.isEmpty) {
                      return Center(
                        child: Text(error!, style: const TextStyle(color: Colors.red, fontSize: 18)),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        final c = countries[index];

                        return Dismissible(
                          key: Key(c.name),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white, size: 30),
                          ),
                          onDismissed: (direction) {
                            final deletedName = c.name;

                            setState(() {
                              countries.removeAt(index);
                            });

                            db.deleteOne(deletedName);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Country "$deletedName" was deleted')),
                            );

                            _checkIfEmptyAndReload();
                          },
                          child: Card(
                            elevation: 6,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: const Text("🏳️", style: TextStyle(fontSize: 24)),
                              title: Text(
                                c.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("🏛 ${c.capital}"),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(name: c.name),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}