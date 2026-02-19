import 'package:flutter/material.dart';
import 'models/data_models.dart';
import 'services/assignment_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Candidatures',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AssignmentPage(),
      },
    );
  }
}

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final AssignmentService _service = AssignmentService();
  
  // Données de test
  List<Candidature> _candidatures = [];
  List<Evaluateur> _evaluateurs = [];
  bool _isAssigned = false;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // Création de fausses données pour la démo
    _evaluateurs = [
      Evaluateur(id: '1', nom: 'Dr. Martin', rank: Rank.MCF),
      Evaluateur(id: '2', nom: 'Dr. Dubois', rank: Rank.MCF),
      Evaluateur(id: '3', nom: 'Dr. Leroy', rank: Rank.MCF),
      Evaluateur(id: '4', nom: 'Pr. Bernard', rank: Rank.PROF),
      Evaluateur(id: '5', nom: 'Pr. Petit', rank: Rank.PROF),
    ];

    _candidatures = List.generate(
      10, 
      (index) => Candidature(id: '$index', nomCandidat: 'Candidat ${index + 1}'),
    );
  }

  void _runAssignment() {
    setState(() {
      _service.affecterCandidatures(_candidatures, _evaluateurs);
      _isAssigned = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Affectation terminée avec succès !')),
    );
  }

  void _reset() {
    setState(() {
      _loadMockData(); // Recharge des données vierges
      _isAssigned = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Affectation des Dossiers'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isAssigned)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Réinitialiser',
            )
        ],
      ),
      body: Column(
        children: [
          // En-tête avec résumé
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Gestion des Évaluateurs",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Candidatures : ${_candidatures.length}"),
                    Text("Évaluateurs MCF : ${_evaluateurs.where((e) => e.rank == Rank.MCF).length}"),
                    Text("Évaluateurs Prof : ${_evaluateurs.where((e) => e.rank == Rank.PROF).length}"),
                  ],
                ),
              ),
            ),
          ),
          
          const Divider(),
          
          // Liste des candidatures
          Expanded(
            child: ListView.builder(
              itemCount: _candidatures.length,
              itemBuilder: (context, index) {
                final cand = _candidatures[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(cand.nomCandidat.substring(9)), // Numéro du candidat
                    ),
                    title: Text(cand.nomCandidat, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: _isAssigned
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text("MCF: ${cand.evaluateurMCF?.nom ?? 'N/A'}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.school, size: 16, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text("Prof: ${cand.evaluateurProf?.nom ?? 'N/A'}"),
                                ],
                              ),
                            ],
                          )
                        : const Text("En attente d'affectation...", style: TextStyle(fontStyle: FontStyle.italic)),
                    trailing: _isAssigned 
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.hourglass_empty, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isAssigned ? null : _runAssignment,
        backgroundColor: _isAssigned ? Colors.grey : Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.assignment_ind),
        label: Text(_isAssigned ? 'Affecté' : 'Lancer l\'affectation'),
      ),
    );
  }
}
