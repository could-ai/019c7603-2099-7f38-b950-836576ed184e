import '../models/data_models.dart';

class AssignmentService {
  /// Affecte automatiquement un MCF et un Prof à chaque candidature.
  /// Utilise une distribution circulaire (round-robin) pour équilibrer la charge.
  void affecterCandidatures(List<Candidature> candidatures, List<Evaluateur> evaluateurs) {
    // 1. Séparer les évaluateurs par rang
    final mcfList = evaluateurs.where((e) => e.rank == Rank.MCF).toList();
    final profList = evaluateurs.where((e) => e.rank == Rank.PROF).toList();

    // Vérification basique
    if (mcfList.isEmpty || profList.isEmpty) {
      // Dans une vraie app, on pourrait lever une exception ou retourner un résultat d'erreur
      print("Attention: Liste d'évaluateurs incomplète (besoin de MCF et de Profs)");
      return;
    }

    // 2. Parcourir les candidatures et assigner
    for (var i = 0; i < candidatures.length; i++) {
      final candidature = candidatures[i];
      
      // Distribution équitable (modulo)
      candidature.evaluateurMCF = mcfList[i % mcfList.length];
      candidature.evaluateurProf = profList[i % profList.length];
    }
  }
}
