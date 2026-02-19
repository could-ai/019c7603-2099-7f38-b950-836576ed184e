enum Rank { MCF, PROF }

class Evaluateur {
  final String id;
  final String nom;
  final Rank rank;

  Evaluateur({required this.id, required this.nom, required this.rank});
}

class Candidature {
  final String id;
  final String nomCandidat;
  Evaluateur? evaluateurMCF;
  Evaluateur? evaluateurProf;

  Candidature({required this.id, required this.nomCandidat});
}
