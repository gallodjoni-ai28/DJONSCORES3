import 'package:flutter/material.dart';

void main() => runApp(const DjonscoresApp());

const gold = Color(0xFFD7B45A);
const green = Color(0xFF24C77A);
const bg = Color(0xFF090D12);

class DjonscoresApp extends StatelessWidget {
  const DjonscoresApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DJONSCORES',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bg,
          colorScheme: const ColorScheme.dark(primary: gold, secondary: green),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const HomePage(),
      );
}

class MatchData {
  final String league, home, away, kickoff;
  final int homeForm, awayForm;
  const MatchData(this.league, this.home, this.away, this.kickoff,
      this.homeForm, this.awayForm);
  String get prediction {
    // Démonstration statistique locale : ce n'est pas une prédiction garantie.
    final h = (1 + (homeForm - awayForm) / 5).round().clamp(0, 4);
    final a = (1 - (homeForm - awayForm) / 6).round().clamp(0, 4);
    return '$h - $a';
  }
  int get confidence => (52 + (homeForm - awayForm).abs() * 3).clamp(52, 78);
}

const matches = <MatchData>[
  MatchData('PREMIER LEAGUE', 'Arsenal', 'Chelsea', 'Aujourd’hui · 18:30', 4, 3),
  MatchData('LIGA', 'Real Madrid', 'Sevilla', 'Aujourd’hui · 20:00', 5, 2),
  MatchData('LIGUE 1', 'Marseille', 'Lyon', 'Demain · 19:45', 3, 3),
  MatchData('SERIE A', 'Inter', 'Napoli', 'Demain · 20:00', 4, 4),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  final favourites = <String>{};
  @override
  Widget build(BuildContext context) {
    final pages = [
      _matchesPage(),
      _predictionsPage(),
      _statsPage(),
      _profilePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: Row(children: [
          Container(width: 34, height: 34,
            decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.bolt, color: Colors.black, size: 24)),
          const SizedBox(width: 10),
          const Text('DJON', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const Text('SCORES', style: TextStyle(color: gold, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        ]),
        actions: [IconButton(onPressed: () => _message('Les notifications seront activées après configuration du service.'), icon: const Icon(Icons.notifications_none))],
      ),
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF111821),
        indicatorColor: gold.withOpacity(.18),
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_soccer_outlined), selectedIcon: Icon(Icons.sports_soccer), label: 'Matchs'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Pronostics'),
          NavigationDestination(icon: Icon(Icons.query_stats), label: 'Statistiques'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Compte'),
        ],
      ),
    );
  }

  Widget _matchesPage() => ListView(padding: const EdgeInsets.all(16), children: [
    _hero(), const SizedBox(height: 22),
    _sectionTitle('MATCHS À SUIVRE', 'Données de démonstration'),
    const SizedBox(height: 10),
    ...matches.map((m) => _matchCard(m)),
    const SizedBox(height: 14),
    const Text('Important : les rencontres affichées sont des exemples. Connecter une API sportive pour obtenir les vrais calendriers et résultats.', style: TextStyle(color: Colors.white54, fontSize: 12)),
  ]);

  Widget _hero() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: const LinearGradient(colors: [Color(0xFF1D2B2B), Color(0xFF17202A), Color(0xFF352B18)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      border: Border.all(color: gold.withOpacity(.35)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('L’ANALYSE DU MATCH,\nAVANT LE COUP D’ENVOI.', style: TextStyle(fontSize: 21, height: 1.2, fontWeight: FontWeight.w900)),
      const SizedBox(height: 9),
      const Text('Pronostics • Statistiques • Scores', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 18),
      Row(children: [const Icon(Icons.insights, color: green), const SizedBox(width: 8), const Text('Moteur statistique de démonstration', style: TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.bold))]),
    ]),
  );

  Widget _sectionTitle(String title, String subtitle) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(title, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: .8)),
    Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 10)),
  ]);

  Widget _matchCard(MatchData m) => Container(
    margin: const EdgeInsets.only(bottom: 11), padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: const Color(0xFF131B24), borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white10)),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(m.league, style: const TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)), Text(m.kickoff, style: const TextStyle(color: Colors.white54, fontSize: 11))]),
      const SizedBox(height: 13),
      Row(children: [Expanded(child: Text(m.home, style: const TextStyle(fontWeight: FontWeight.bold))), const Text('VS', style: TextStyle(color: Colors.white38, fontSize: 11)), Expanded(child: Text(m.away, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold)))]),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Score estimé : ${m.prediction}', style: const TextStyle(color: green, fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => favourites.add('${m.home}-${m.away}')), child: Text(favourites.contains('${m.home}-${m.away}') ? 'Ajouté ★' : 'Favori ☆'))]),
    ]),
  );

  Widget _predictionsPage() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('PRONOSTICS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6), const Text('Estimations calculées localement à partir de données fictives.', style: TextStyle(color: Colors.white54, fontSize: 12)),
    const SizedBox(height: 16),
    ...matches.map((m) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF131B24), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m.league, style: const TextStyle(color: gold, fontSize: 11)), const SizedBox(height: 8), Text('${m.home}  –  ${m.away}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Score : ${m.prediction}', style: const TextStyle(color: green, fontSize: 20, fontWeight: FontWeight.w900)), Text('Indice indicatif ${m.confidence}%', style: const TextStyle(color: Colors.white60, fontSize: 11))])]))),
    const SizedBox(height: 12), const Text('Un pronostic comporte toujours une incertitude. Aucun résultat ni gain n’est garanti.', style: TextStyle(color: Colors.white54, fontSize: 12)),
  ]);

  Widget _statsPage() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('STATISTIQUES', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    const SizedBox(height: 14),
    _statTile('Matchs suivis', '04', Icons.sports), _statTile('Compétitions', '04', Icons.emoji_events_outlined), _statTile('Favoris', '${favourites.length}', Icons.star_outline),
    const SizedBox(height: 12), const Text('Les statistiques réelles seront alimentées après branchement d’une source de données sportive.', style: TextStyle(color: Colors.white54, fontSize: 12)),
  ]);

  Widget _statTile(String label, String value, IconData icon) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: const Color(0xFF131B24), borderRadius: BorderRadius.circular(15)), child: Row(children: [Icon(icon, color: gold), const SizedBox(width: 13), Expanded(child: Text(label)), Text(value, style: const TextStyle(color: green, fontWeight: FontWeight.w900, fontSize: 20))]));

  Widget _profilePage() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('COMPTE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFF131B24), borderRadius: BorderRadius.circular(18)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(backgroundColor: gold, child: Icon(Icons.person, color: Colors.black)), SizedBox(height: 12), Text('Bienvenue sur DJONSCORES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)), SizedBox(height: 6), Text('Créez votre compte lorsque le service d’authentification sera configuré.', style: TextStyle(color: Colors.white60, fontSize: 12))])),
    const SizedBox(height: 14), ListTile(leading: const Icon(Icons.workspace_premium, color: gold), title: const Text('Abonnement Premium'), subtitle: const Text('Paiements MTN MoMo et Orange Money à intégrer côté serveur'), onTap: () => _message('Le paiement réel sera activé après configuration du compte marchand et des notifications sécurisées.')),
    ListTile(leading: const Icon(Icons.admin_panel_settings, color: gold), title: const Text('Espace administrateur'), subtitle: const Text('Accès sécurisé à mettre en place'), onTap: () => _message('L’authentification administrateur sécurisée n’est pas encore configurée.')),
    const SizedBox(height: 16), const Text('Version prototype 0.1 • Interface de démonstration hors ligne', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 11)),
  ]);

  void _message(String value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value), backgroundColor: const Color(0xFF263342)));
}
