import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MegaShooterApp());
}

class MegaShooterApp extends StatelessWidget {
  const MegaShooterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mega Shooter: S.C.P Edition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainMenuScreen(),
    );
  }
}
class GameData {
  static int coins = 200;
  static int unlockedLevel = 1;
  static int checkpointLevel = 1;
  static int unlockedMission = 1;
  static int currentLevel = 1;
  static int currentMission = 1;
  static String currentWeapon = "1. Pistol";
  static String currentTank = "1. Scout Tank";

  static final Map<String, Map<String, dynamic>> weapons = {
    "1. Pistol": {"price": 0, "cd": 420, "dmg": 2, "bullets": 1, "color": Colors.yellow, "owned": true},
    "2. Dual Pistol": {"price": 100, "cd": 380, "dmg": 2, "bullets": 2, "color": Colors.yellowAccent, "owned": false},
    "3. Rifle": {"price": 250, "cd": 220, "dmg": 4, "bullets": 1, "color": Colors.cyan, "owned": false},
    "4. Shotgun": {"price": 450, "cd": 550, "dmg": 5, "bullets": 3, "color": Colors.orange, "owned": false},
    "5. SMG": {"price": 700, "cd": 110, "dmg": 3, "bullets": 1, "color": Colors.green, "owned": false},
    "6. Sniper": {"price": 1000, "cd": 750, "dmg": 25, "bullets": 1, "color": Colors.red, "owned": false},
    "7. Heavy Shotgun": {"price": 1500, "cd": 600, "dmg": 6, "bullets": 5, "color": Colors.deepOrange, "owned": false},
    "8. Laser Gun": {"price": 2200, "cd": 130, "dmg": 8, "bullets": 1, "color": Colors.purpleAccent, "owned": false},
    "9. Minigun": {"price": 3500, "cd": 65, "dmg": 6, "bullets": 2, "color": Colors.white, "owned": false},
    "10. Plasma Cannon": {"price": 5000, "cd": 150, "dmg": 18, "bullets": 3, "color": Colors.cyanAccent, "owned": false},
  };
  static final Map<String, Map<String, dynamic>> tanks = {
    "1. Scout Tank": {"price": 0, "hp": 100, "dmg": 0, "color": Colors.blue, "owned": true},
    "2. Light Guard": {"price": 150, "hp": 130, "dmg": 1, "color": Colors.cyan, "owned": false},
    "3. Desert Fox": {"price": 300, "hp": 160, "dmg": 1, "color": Colors.orange, "owned": false},
    "4. Iron Beetle": {"price": 500, "hp": 200, "dmg": 2, "color": Colors.grey, "owned": false},
    "5. Rapid Viper": {"price": 750, "hp": 220, "dmg": 2, "color": Colors.green, "owned": false},
    "6. Steel Rhino": {"price": 1000, "hp": 280, "dmg": 3, "color": Colors.white, "owned": false},
    "7. Shadow Tank": {"price": 1300, "hp": 310, "dmg": 3, "color": Colors.purple, "owned": false},
    "8. Flame Panzer": {"price": 1600, "hp": 350, "dmg": 4, "color": Colors.red, "owned": false},
    "9. Frost Mammoth": {"price": 2000, "hp": 420, "dmg": 4, "color": Colors.lightBlue, "owned": false},
    "10. Thunder Bolt": {"price": 2500, "hp": 460, "dmg": 5, "color": Colors.yellow, "owned": false},
    "11. Heavy Crusher": {"price": 3000, "hp": 550, "dmg": 6, "color": Colors.brown, "owned": false},
    "12. Cyber Walker": {"price": 3600, "hp": 600, "dmg": 7, "color": Colors.greenAccent, "owned": false},
    "13. Crimson Beast": {"price": 4200, "hp": 680, "dmg": 8, "color": Colors.redAccent, "owned": false},
    "14. Titanium Core": {"price": 5000, "hp": 750, "dmg": 9, "color": Colors.white70, "owned": false},
    "15. Plasma Striker": {"price": 6000, "hp": 820, "dmg": 10, "color": Colors.deepPurpleAccent, "owned": false},
    "16. Golden Eagle": {"price": 7200, "hp": 900, "dmg": 12, "color": Colors.amber, "owned": false},
    "17. Void Destroyer": {"price": 8500, "hp": 1050, "dmg": 14, "color": Colors.blueGrey, "owned": false},
    "18. Titan Fortress": {"price": 10000, "hp": 1250, "dmg": 16, "color": Colors.deepOrange, "owned": false},
    "19. Omega Warlord": {"price": 12500, "hp": 1500, "dmg": 20, "color": Colors.red, "owned": false},
    "20. Mazen Supreme": {"price": 15000, "hp": 2000, "dmg": 25, "color": Colors.cyanAccent, "owned": false},
  };

  static const List<Map<String, dynamic>> planeMaps = [
    {"name": "Deep Space", "bg": Color(0xFF0A0A1C)},
    {"name": "Blue Ocean", "bg": Color(0xFF0A2D5F)},
    {"name": "Golden Desert", "bg": Color(0xFF6E5023)},
    {"name": "Emerald Forest", "bg": Color(0xFF12411E)},
    {"name": "Sky Clouds", "bg": Color(0xFF3773A5)},
    {"name": "Volcano Lava", "bg": Color(0xFF410F0F)},
    {"name": "Cyber Night City", "bg": Color(0xFF190F2D)},
  ];

  static const List<Map<String, dynamic>> scpMaps = [
    {"name": "Site-19 Containment", "bg": Color(0xFF1C1E24)},
    {"name": "Chaos Insurgency Bunker", "bg": Color(0xFF142616)},
    {"name": "UN / GOC Orbital Base", "bg": Color(0xFF12203A)},
    {"name": "Arctic Blackout Outpost", "bg": Color(0xFF2D3C4B)},
    {"name": "Red Reality Dimension", "bg": Color(0xFF370C12)},
  ];

  static const List<Map<String, dynamic>> factions = [
    {"name": "Chaos Insurgency", "color": Color(0xFF00B43C)},
    {"name": "UN / GOC Strike Force", "color": Color(0xFF288CFF)},
    {"name": "Serpent's Hand", "color": Color(0xFFBE32DC)},
    {"name": "Church of Broken God", "color": Color(0xFFD29628)},
  ];

  static const List<String> scpObjects = [
    "SCP-173 (The Sculpture)",
    "SCP-096 (Shy Guy)",
    "SCP-106 (The Old Man)",
    "SCP-049 (Plague Doctor)",
    "SCP-682 (Hard-to-Destroy Reptile)",
    "SCP-999 (Tickle Monster)",
  ];

  static Map<String, dynamic> getMissionInfo(int mNum) {
    return {
      "faction": factions[(mNum - 1) % factions.length],
      "scp": scpObjects[(mNum - 1) % scpObjects.length],
      "map": scpMaps[((mNum - 1) ~/ 5) % scpMaps.length],
    };
  }
}
class NetworkManager {
  static Socket? socket;
  static String status = "Disconnected";
  static double remoteX = 200;
  static double remoteY = 550;
  static int remoteHp = 150;
  static bool remoteActive = false;

  static Future<String> getLocalIp() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return "127.0.0.1";
  }

  static void listenToSocket(Socket s) {
    socket = s;
    status = "CONNECTED!";
    s.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter()).listen(
      (line) {
        try {
          final data = jsonDecode(line);
          remoteX = (data['x'] as num).toDouble();
          remoteY = (data['y'] as num).toDouble();
          remoteHp = (data['hp'] as num).toInt();
          remoteActive = true;
        } catch (_) {}
      },
      onDone: () {
        remoteActive = false;
        status = "Disconnected";
      },
      onError: (_) {
        remoteActive = false;
        status = "Connection Error";
      },
    );
  }

  static void sendState(double x, double y, int hp) {
    if (socket != null) {
      try {
        socket!.writeln(jsonEncode({"x": x, "y": y, "hp": hp}));
      } catch (_) {}
    }
  }

  static void close() {
    try {
      socket?.close();
    } catch (_) {}
    socket = null;
    remoteActive = false;
  }
}
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "MEGA SHOOTER\nS.C.P EDITION",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.yellow),
                ),
                const SizedBox(height: 8),
                Text(
                  "Planes: ${GameData.unlockedLevel}/1000 | SCP: ${GameData.unlockedMission}/1000\nCoins: ${GameData.coins}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.cyanAccent),
                ),
                const SizedBox(height: 20),
                _menuBtn("S.C.P MISSIONS (1000 STORY)", Colors.purple, () async {
                  final chosen = await Navigator.push<int>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelSelectScreen(
                        title: "S.C.P MISSIONS",
                        maxUnlocked: GameData.unlockedMission,
                      ),
                    ),
                  );
                  if (chosen != null && mounted) {
                    GameData.currentMission = chosen;
                    final stealth = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (_) => StoryBriefingScreen(missionNum: chosen)),
                    );
                    if (stealth != null && mounted) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameArenaScreen(mode: "MISSION", startStealth: stealth),
                        ),
                      );
                      _refresh();
                    }
                  }
                }),
                _menuBtn("PLANES MODE (1000 LVLS)", Colors.blue, () async {
                  final chosen = await Navigator.push<int>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelSelectScreen(
                        title: "PLANES LEVELS",
                        maxUnlocked: GameData.unlockedLevel,
                      ),
                    ),
                  );
                  if (chosen != null && mounted) {
                    GameData.currentLevel = chosen;
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameArenaScreen(mode: "PLANES")),
                    );
                    _refresh();
                  }
                }),
                _menuBtn("1000 TANKS CHALLENGE", Colors.red, () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameArenaScreen(mode: "1000_TANKS")),
                  );
                  _refresh();
                }),
                _menuBtn("ONLINE & LOCAL MULTIPLAYER", Colors.teal, () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OnlineLobbyScreen()),
                  );
                  _refresh();
                }),
                _menuBtn("CHECKPOINT (Planes Lvl ${GameData.checkpointLevel})", Colors.green, () async {
                  GameData.currentLevel = GameData.checkpointLevel;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameArenaScreen(mode: "PLANES")),
                  );
                  _refresh();
                }),
                _menuBtn("WEAPON SHOP (10)", Colors.grey.shade800, () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const WeaponShopScreen()));
                  _refresh();
                }),
                _menuBtn("TANK SHOP (20 TANKS)", Colors.brown, () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const TankShopScreen()));
                  _refresh();
                }),
                _menuBtn("OWNER (MAZEN)", Colors.grey.shade900, () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.grey.shade900,
                      title: const Text("GAME DEVELOPER & OWNER", style: TextStyle(color: Colors.yellow)),
                      content: const Text(
                        "Created By: MAZEN\nMega Shooter: S.C.P Stealth, Online & 1000 Tanks (iOS Edition)",
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            GameData.coins += 2000;
                            _refresh();
                            Navigator.pop(context);
                          },
                          child: const Text("+2000 Coins"),
                        ),
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuBtn(String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.white54),
            ),
          ),
          onPressed: onTap,
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
class LevelSelectScreen extends StatefulWidget {
  final String title;
  final int maxUnlocked;
  const LevelSelectScreen({super.key, required this.title, required this.maxUnlocked});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  late int page;

  @override
  void initState() {
    super.initState();
    page = (widget.maxUnlocked - 1) ~/ 50;
  }

  @override
  Widget build(BuildContext context) {
    int startLvl = page * 50 + 1;
    return Scaffold(
      appBar: AppBar(title: Text("${widget.title} (Page ${page + 1}/20)")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: page > 0 ? () => setState(() => page--) : null,
                child: const Text("< Prev 50"),
              ),
              ElevatedButton(
                onPressed: page < 19 ? () => setState(() => page++) : null,
                child: const Text("Next 50 >"),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: 50,
              itemBuilder: (_, i) {
                int lvl = startLvl + i;
                bool unlocked = lvl <= widget.maxUnlocked;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lvl == widget.maxUnlocked
                        ? Colors.green
                        : (unlocked ? Colors.blue : Colors.grey.shade900),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: unlocked ? () => Navigator.pop(context, lvl) : null,
                  child: Text(unlocked ? "$lvl" : "🔒", style: const TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoryBriefingScreen extends StatelessWidget {
  final int missionNum;
  const StoryBriefingScreen({super.key, required this.missionNum});

  @override
  Widget build(BuildContext context) {
    final info = GameData.getMissionInfo(missionNum);
    final faction = info['faction'];
    final scp = info['scp'] as String;
    final map = info['map'];

    return Scaffold(
      appBar: AppBar(title: Text("S.C.P BRIEFING #$missionNum")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("FACTION: S.C.P FOUNDATION", style: TextStyle(fontSize: 20, color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("HOSTILE: ${faction['name']}", style: const TextStyle(fontSize: 18, color: Colors.redAccent)),
            const SizedBox(height: 12),
            Text("ANOMALY: $scp", style: const TextStyle(fontSize: 18, color: Colors.purpleAccent)),
            const SizedBox(height: 12),
            Text("SECTOR: ${map['name']}", style: const TextStyle(fontSize: 18, color: Colors.greenAccent)),
            const SizedBox(height: 20),
            Text(
              scp.contains("SCP-173")
                  ? "NOTE: An MTF Partner will watch SCP-173 while you blink!"
                  : "Hold [CONTAIN] near SCP | [GOGGLES] for 096 | [MTF] Backup",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.amber),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("STEALTH DEPLOY (DEFAULT)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, false),
                child: const Text("DIRECT ATTACK (LOUD)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class OnlineLobbyScreen extends StatefulWidget {
  const OnlineLobbyScreen({super.key});

  @override
  State<OnlineLobbyScreen> createState() => _OnlineLobbyScreenState();
}

class _OnlineLobbyScreenState extends State<OnlineLobbyScreen> {
  String myIp = "...";
  final TextEditingController ipCtrl = TextEditingController(text: "192.168.1.");

  @override
  void initState() {
    super.initState();
    NetworkManager.getLocalIp().then((ip) => setState(() => myIp = ip));
  }

  Future<void> _hostLan() async {
    try {
      setState(() => NetworkManager.status = "Waiting on $myIp:5555...");
      final server = await ServerSocket.bind(InternetAddress.anyIPv4, 5555);
      final client = await server.first;
      NetworkManager.listenToSocket(client);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameArenaScreen(mode: "ONLINE_LOCAL")));
      }
    } catch (e) {
      setState(() => NetworkManager.status = "Host Error: $e");
    }
  }

  Future<void> _joinLan() async {
    try {
      setState(() => NetworkManager.status = "Connecting to ${ipCtrl.text}...");
      final client = await Socket.connect(ipCtrl.text.trim(), 5555, timeout: const Duration(seconds: 5));
      NetworkManager.listenToSocket(client);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameArenaScreen(mode: "ONLINE_LOCAL")));
      }
    } catch (e) {
      setState(() => NetworkManager.status = "Join Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ONLINE & LOCAL MULTIPLAYER")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Your Wi-Fi IP: $myIp", style: const TextStyle(color: Colors.cyanAccent, fontSize: 16)),
            Text("Status: ${NetworkManager.status}", style: const TextStyle(color: Colors.yellow)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameArenaScreen(mode: "COOP_2P")));
                },
                child: const Text("1. SAME IPHONE 2-PLAYER CO-OP", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _hostLan,
                child: const Text("2. LOCAL WI-FI: HOST GAME"),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: ipCtrl,
              decoration: const InputDecoration(
                labelText: "Enter Host Wi-Fi IP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: _joinLan,
                child: const Text("JOIN WI-FI GAME"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeaponShopScreen extends StatefulWidget {
  const WeaponShopScreen({super.key});
  @override
  State<WeaponShopScreen> createState() => _WeaponShopScreenState();
}

class _WeaponShopScreenState extends State<WeaponShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WEAPONS - Coins: ${GameData.coins}")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: GameData.weapons.entries.map((e) {
          final name = e.key;
          final data = e.value;
          bool equipped = GameData.currentWeapon == name;
          bool owned = data['owned'];
          return Card(
            color: equipped ? Colors.green.shade800 : (owned ? Colors.blue.shade900 : Colors.grey.shade900),
            child: ListTile(
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("DMG: ${data['dmg']} x${data['bullets']}"),
              trailing: Text(equipped ? "EQUIPPED" : (owned ? "OWNED" : "${data['price']} C")),
              onTap: () {
                setState(() {
                  if (owned) {
                    GameData.currentWeapon = name;
                  } else if (GameData.coins >= data['price']) {
                    GameData.coins -= data['price'] as int;
                    data['owned'] = true;
                    GameData.currentWeapon = name;
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TankShopScreen extends StatefulWidget {
  const TankShopScreen({super.key});
  @override
  State<TankShopScreen> createState() => _TankShopScreenState();
}

class _TankShopScreenState extends State<TankShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TANKS (20) - Coins: ${GameData.coins}")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: GameData.tanks.entries.map((e) {
          final name = e.key;
          final data = e.value;
          bool equipped = GameData.currentTank == name;
          bool owned = data['owned'];
          return Card(
            color: equipped ? Colors.green.shade800 : (owned ? Colors.blue.shade900 : Colors.grey.shade900),
            child: ListTile(
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("HP: ${data['hp']} | +DMG: ${data['dmg']}"),
              trailing: Text(equipped ? "EQUIPPED" : (owned ? "OWNED" : "${data['price']} C")),
              onTap: () {
                setState(() {
                  if (owned) {
                    GameData.currentTank = name;
                  } else if (GameData.coins >= data['price']) {
                    GameData.coins -= data['price'] as int;
                    data['owned'] = true;
                    GameData.currentTank = name;
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
class _Entity {
  Rect rect;
  int hp;
  int maxHp;
  double vx;
  double vy;
  Color color;
  bool isBoss;
  int lastShot = 0;

  _Entity({
    required this.rect,
    required this.hp,
    required this.color,
    this.vx = 0,
    this.vy = 2,
    this.isBoss = false,
  }) : maxHp = hp;
}

class _Bullet {
  Rect rect;
  double vx;
  double vy;
  int dmg;
  Color color;
  bool isEnemy;

  _Bullet(this.rect, this.vx, this.vy, this.dmg, this.color, {this.isEnemy = false});
}

class GameArenaScreen extends StatefulWidget {
  final String mode;
  final bool startStealth;
  const GameArenaScreen({super.key, required this.mode, this.startStealth = true});

  @override
  State<GameArenaScreen> createState() => _GameArenaScreenState();
}

class _GameArenaScreenState extends State<GameArenaScreen> {
  Timer? _loop;
  final Random _rng = Random();

  double p1X = 160, p1Y = 560;
  int p1Hp = 150, p1MaxHp = 150;

  double p2X = 240, p2Y = 560;
  int p2Hp = 150, p2MaxHp = 150;

  List<_Entity> enemies = [];
  List<_Bullet> bullets = [];
  List<Rect> walls = [];

  bool isStealth = false;
  bool wearingGoggles = true;
  bool isBlinking = false;
  bool inPocketDimension = false;
  bool hasMtf = false;
  bool scp096Enraged = false;
  double containProgress = 0;
  String scpCode = "SCP-173";
  Rect scpRect = const Rect.fromLTWH(160, 90, 46, 46);
  Rect exitPortal = const Rect.fromLTWH(160, 80, 60, 60);

  int missionStartMs = 0;
  int lastP1ShotMs = 0;
  int lastP2ShotMs = 0;
  int tanksDestroyed = 0;
  int tanksToSpawn = 1000;
  bool gameOver = false;
  bool initialized = false;
  void _initStage(Size size) {
    enemies.clear();
    bullets.clear();
    walls.clear();
    inPocketDimension = false;
    scp096Enraged = false;
    containProgress = 0;
    missionStartMs = DateTime.now().millisecondsSinceEpoch;

    p1X = size.width * 0.4;
    p1Y = size.height - 130;
    p2X = size.width * 0.6;
    p2Y = size.height - 130;

    if (widget.mode == "1000_TANKS") {
      final t = GameData.tanks[GameData.currentTank]!;
      p1MaxHp = t['hp'];
      p1Hp = p1MaxHp;
      walls.add(Rect.fromLTWH(size.width * 0.15, size.height * 0.5, 90, 20));
      walls.add(Rect.fromLTWH(size.width * 0.60, size.height * 0.5, 90, 20));
      _spawnTanks(size);
    } else if (widget.mode == "MISSION") {
      p1MaxHp = 200;
      p1Hp = 200;
      isStealth = widget.startStealth;
      final info = GameData.getMissionInfo(GameData.currentMission);
      scpCode = (info['scp'] as String).split(" ").first;
      hasMtf = (scpCode == "SCP-173");
      scpRect = Rect.fromLTWH(size.width / 2 - 23, 95, 46, 46);

      walls.add(Rect.fromLTWH(size.width * 0.2, size.height * 0.35, 100, 20));
      walls.add(Rect.fromLTWH(size.width * 0.55, size.height * 0.55, 100, 20));

      int guards = min(8, 4 + GameData.currentMission ~/ 15);
      for (int i = 0; i < guards; i++) {
        enemies.add(_Entity(
          rect: Rect.fromLTWH(40.0 + _rng.nextInt(max(60, (size.width - 100).toInt())), 160.0 + i * 45, 34, 34),
          hp: 5 + GameData.currentMission ~/ 20,
          color: info['faction']['color'],
          vx: _rng.nextBool() ? 2.0 : -2.0,
          vy: 0,
        ));
      }
    } else {
      p1MaxHp = 150;
      p1Hp = 150;
      p2MaxHp = 150;
      p2Hp = 150;
      if (widget.mode == "PLANES" && GameData.currentLevel % 10 == 0) {
        enemies.add(_Entity(
          rect: Rect.fromLTWH(size.width / 2 - 50, 110, 100, 60),
          hp: GameData.currentLevel * 20,
          color: Colors.purple,
          vx: 3,
          vy: 0,
          isBoss: true,
        ));
      } else {
        int count = 6 + (GameData.currentLevel ~/ 15);
        for (int i = 0; i < count; i++) {
          enemies.add(_Entity(
            rect: Rect.fromLTWH(_rng.nextDouble() * (size.width - 50) + 10, -40.0 - i * 50, 34, 34),
            hp: 3 + (GameData.currentLevel ~/ 30),
            color: Colors.red,
            vy: 2.2,
          ));
        }
      }
    }
  }

  void _spawnTanks(Size size) {
    while (enemies.length < 8 && tanksToSpawn > 0) {
      enemies.add(_Entity(
        rect: Rect.fromLTWH(_rng.nextDouble() * (size.width - 50) + 10, -40.0 - _rng.nextInt(150), 36, 36),
        hp: 12,
        color: Colors.orange,
        vy: 2.5,
      ));
      tanksToSpawn--;
    }
  }

  @override
  void initState() {
    super.initState();
    _loop = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      if (!initialized) {
        initialized = true;
        _initStage(size);
      }
      if (!gameOver) {
        _updateGame(size);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _loop?.cancel();
    NetworkManager.close();
    super.dispose();
  }
  void _updateGame(Size size) {
    int now = DateTime.now().millisecondsSinceEpoch;
    bool hasP2 = (widget.mode == "COOP_2P" || widget.mode == "ONLINE_LOCAL");

    if (widget.mode == "ONLINE_LOCAL") {
      NetworkManager.sendState(p1X, p1Y, p1Hp);
      if (NetworkManager.remoteActive) {
        p2X = NetworkManager.remoteX;
        p2Y = NetworkManager.remoteY;
        p2Hp = NetworkManager.remoteHp;
      }
    }

    final wData = GameData.weapons[GameData.currentWeapon]!;
    int bonusDmg = widget.mode == "1000_TANKS" ? (GameData.tanks[GameData.currentTank]!['dmg'] as int) : 0;

    if (p1Hp > 0 && !isStealth && now - lastP1ShotMs > wData['cd']) {
      lastP1ShotMs = now;
      int bCount = wData['bullets'];
      for (int i = 0; i < bCount; i++) {
        double spread = (i - (bCount - 1) / 2) * 1.8;
        bullets.add(_Bullet(Rect.fromLTWH(p1X - 3, p1Y - 25, 6, 14), spread, -10, wData['dmg'] + bonusDmg, wData['color']));
      }
    }

    if (hasP2 && p2Hp > 0 && now - lastP2ShotMs > 280) {
      lastP2ShotMs = now;
      bullets.add(_Bullet(Rect.fromLTWH(p2X - 3, p2Y - 25, 6, 14), 0, -10, 5, Colors.orange));
    }

    for (int i = bullets.length - 1; i >= 0; i--) {
      final b = bullets[i];
      b.rect = b.rect.shift(Offset(b.vx, b.vy));
      if (b.rect.bottom < 0 || b.rect.top > size.height || walls.any((w) => w.overlaps(b.rect))) {
        bullets.removeAt(i);
        continue;
      }

      if (b.isEnemy) {
        Rect r1 = Rect.fromCenter(center: Offset(p1X, p1Y), width: 38, height: 38);
        Rect r2 = Rect.fromCenter(center: Offset(p2X, p2Y), width: 38, height: 38);
        if (p1Hp > 0 && r1.overlaps(b.rect)) {
          p1Hp = max(0, p1Hp - b.dmg);
          bullets.removeAt(i);
        } else if (hasP2 && p2Hp > 0 && r2.overlaps(b.rect)) {
          p2Hp = max(0, p2Hp - b.dmg);
          bullets.removeAt(i);
        }
      } else {
        for (int j = enemies.length - 1; j >= 0; j--) {
          if (enemies[j].rect.overlaps(b.rect)) {
            enemies[j].hp -= b.dmg;
            bullets.removeAt(i);
            if (enemies[j].hp <= 0) {
              GameData.coins += enemies[j].isBoss ? 50 : 10;
              enemies.removeAt(j);
              if (widget.mode == "1000_TANKS") tanksDestroyed++;
            }
            break;
          }
        }
      }
    }

    for (int i = enemies.length - 1; i >= 0; i--) {
      final e = enemies[i];
      if (widget.mode == "MISSION") {
        e.rect = e.rect.shift(Offset(e.vx, 0));
        if (e.rect.left < 10 || e.rect.right > size.width - 10) e.vx *= -1;
        if (isStealth && (e.rect.center - Offset(p1X, p1Y)).distance < 110) {
          isStealth = false;
        }
      } else if (e.isBoss) {
        e.rect = e.rect.shift(Offset(e.vx, 0));
        if (e.rect.left < 10 || e.rect.right > size.width - 10) e.vx *= -1;
      } else {
        e.rect = e.rect.shift(Offset(0, e.vy));
        if (e.rect.top > size.height) {
          e.rect = Rect.fromLTWH(_rng.nextDouble() * (size.width - 50) + 10, -40, e.rect.width, e.rect.height);
        }
      }

      Rect r1 = Rect.fromCenter(center: Offset(p1X, p1Y), width: 38, height: 38);
      Rect r2 = Rect.fromCenter(center: Offset(p2X, p2Y), width: 38, height: 38);
      if (!isStealth && p1Hp > 0 && e.rect.overlaps(r1)) {
        p1Hp = max(0, p1Hp - 25);
        if (!e.isBoss && widget.mode != "MISSION") enemies.removeAt(i);
        continue;
      } else if (!isStealth && hasP2 && p2Hp > 0 && e.rect.overlaps(r2)) {
        p2Hp = max(0, p2Hp - 25);
        if (!e.isBoss && widget.mode != "MISSION") enemies.removeAt(i);
        continue;
      }

      if (!isStealth && e.rect.top > 0 && now - e.lastShot > 1500) {
        e.lastShot = now;
        Offset targetPos = Offset(p1X, p1Y);
        if (hasP2 && p2Hp > 0) {
          double d1 = p1Hp > 0 ? (e.rect.center - Offset(p1X, p1Y)).distance : 99999;
          double d2 = (e.rect.center - Offset(p2X, p2Y)).distance;
          if (d2 < d1) targetPos = Offset(p2X, p2Y);
        }
        double dx = (targetPos.dx - e.rect.center.dx) / max(1, (targetPos.dy - e.rect.bottom)) * 5;
        dx = dx.clamp(-3.5, 3.5);
        bullets.add(_Bullet(Rect.fromLTWH(e.rect.center.dx, e.rect.bottom, 6, 14), dx, 6, 12, Colors.orange, isEnemy: true));
      }
    }

    if (widget.mode == "MISSION") {
      int cycle = (now - missionStartMs) % 4000;
      isBlinking = cycle > 3700;

      Offset pPos = Offset(p1X, p1Y);
      if (inPocketDimension) {
        Offset dir = pPos - scpRect.center;
        if (dir.distance > 1) scpRect = scpRect.shift(dir / dir.distance * 2.5);
        if (scpRect.contains(pPos)) gameOver = true;
        if (exitPortal.contains(pPos)) {
          inPocketDimension = false;
          p1Y = size.height - 120;
          scpRect = Rect.fromLTWH(size.width / 2 - 23, 95, 46, 46);
        }
      } else {
        if (scpCode == "SCP-173" && isBlinking && !hasMtf) {
          Offset dir = pPos - scpRect.center;
          if (dir.distance > 1) scpRect = scpRect.shift(dir / dir.distance * 18);
        } else if (scpCode == "SCP-096") {
          if (!wearingGoggles && (pPos - scpRect.center).distance < 210 && !isBlinking) {
            scp096Enraged = true;
          }
          if (scp096Enraged) {
            Offset dir = pPos - scpRect.center;
            if (dir.distance > 1) scpRect = scpRect.shift(dir / dir.distance * 6.5);
          }
        } else if (scpCode != "SCP-173") {
          Offset dir = pPos - scpRect.center;
          if (dir.distance > 1) scpRect = scpRect.shift(dir / dir.distance * 1.8);
        }

        if (scpRect.contains(pPos)) {
          if (scpCode == "SCP-173" || (scpCode == "SCP-096" && scp096Enraged)) {
            gameOver = true;
          } else if (scpCode == "SCP-106") {
            inPocketDimension = true;
            p1X = 70;
            p1Y = size.height / 2;
            scpRect = Rect.fromLTWH(size.width - 100, size.height / 2, 46, 46);
            exitPortal = Rect.fromLTWH(size.width / 2 - 30, 90, 60, 60);
          } else if (scpCode == "SCP-999") {
            p1Hp = min(p1MaxHp, p1Hp + 1);
          }
        }
      }
    } else if (widget.mode == "1000_TANKS") {
      _spawnTanks(size);
      if (tanksDestroyed >= 1000) {
        GameData.coins += 5000;
        Navigator.pop(context);
      }
    } else if (enemies.isEmpty) {
      if (widget.mode == "PLANES") {
        if (GameData.currentLevel == GameData.unlockedLevel && GameData.unlockedLevel < 1000) {
          GameData.unlockedLevel++;
        }
        if (GameData.currentLevel % 5 == 0) GameData.checkpointLevel = GameData.currentLevel;
        GameData.currentLevel = min(1000, GameData.currentLevel + 1);
      }
      _initStage(size);
    }

    if (p1Hp <= 0 && (!hasP2 || p2Hp <= 0)) {
      gameOver = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color bgColor = Colors.black;
    if (widget.mode == "PLANES" || widget.mode == "COOP_2P" || widget.mode == "ONLINE_LOCAL") {
      bgColor = GameData.planeMaps[((GameData.currentLevel - 1) ~/ 5) % GameData.planeMaps.length]['bg'];
    } else if (widget.mode == "MISSION") {
      bgColor = inPocketDimension
          ? const Color(0xFF0A0505)
          : GameData.getMissionInfo(GameData.currentMission)['map']['bg'];
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        onPanUpdate: (details) {
          if (gameOver) return;
          setState(() {
            if (widget.mode == "COOP_2P" && details.globalPosition.dy < size.height * 0.5) {
              p2X = (p2X + details.delta.dx).clamp(25.0, size.width - 25.0);
              p2Y = (p2Y + details.delta.dy).clamp(60.0, size.height - 60.0);
            } else {
              p1X = (p1X + details.delta.dx).clamp(25.0, size.width - 25.0);
              p1Y = (p1Y + details.delta.dy).clamp(60.0, size.height - 60.0);
            }
          });
        },
        child: Stack(
          children: [
            CustomPaint(
              size: size,
              painter: _GamePainter(
                mode: widget.mode,
                p1: Offset(p1X, p1Y),
                p1Hp: p1Hp,
                p2: (widget.mode == "COOP_2P" || widget.mode == "ONLINE_LOCAL") ? Offset(p2X, p2Y) : null,
                p2Hp: p2Hp,
                enemies: enemies,
                bullets: bullets,
                walls: inPocketDimension ? [] : walls,
                isStealth: isStealth,
                scpCode: scpCode,
                scpRect: scpRect,
                containProgress: containProgress,
                inPocket: inPocketDimension,
                exitPortal: exitPortal,
                hasMtf: hasMtf,
                wearingGoggles: wearingGoggles,
                scp096Enraged: scp096Enraged,
              ),
            ),

            if (widget.mode == "MISSION" && isBlinking && !inPocketDimension)
              Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text("* BLINKING *", style: TextStyle(color: Colors.grey, fontSize: 28, fontWeight: FontWeight.bold)),
              ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.mode == "MISSION"
                              ? "SCP Mission #${GameData.currentMission} (${isStealth ? 'STEALTH' : 'COMBAT'})"
                              : (widget.mode == "1000_TANKS" ? "Tanks: $tanksDestroyed/1000" : "Level: ${GameData.currentLevel}/1000"),
                          style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          (widget.mode == "COOP_2P" || widget.mode == "ONLINE_LOCAL")
                              ? "P1 HP: $p1Hp | P2 HP: $p2Hp | Coins: ${GameData.coins}"
                              : "HP: $p1Hp/$p1MaxHp | Coins: ${GameData.coins}",
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause_circle_filled, color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            if (widget.mode == "MISSION" && !gameOver)
              Positioned(
                bottom: 20,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: wearingGoggles ? Colors.cyan.shade800 : Colors.grey.shade800),
                      onPressed: () => setState(() => wearingGoggles = !wearingGoggles),
                      child: Text(wearingGoggles ? "GOGGLES: ON" : "GOGGLES: OFF", style: const TextStyle(fontSize: 12)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      onPressed: () {
                        if ((Offset(p1X, p1Y) - scpRect.center).distance < 120) {
                          setState(() {
                            isStealth = false;
                            containProgress += 25;
                            if (containProgress >= 100) {
                              int rew = 200 + GameData.currentMission * 5;
                              GameData.coins += rew;
                              if (GameData.currentMission == GameData.unlockedMission && GameData.unlockedMission < 1000) {
                                GameData.unlockedMission++;
                              }
                              GameData.currentMission = min(1000, GameData.currentMission + 1);
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      child: const Text("CONTAIN [TAP]", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800),
                      onPressed: () {
                        if (GameData.coins >= 50 && !hasMtf) {
                          setState(() {
                            GameData.coins -= 50;
                            hasMtf = true;
                            isStealth = false;
                          });
                        }
                      },
                      child: const Text("MTF (50C)", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

            if (gameOver)
              Container(
                color: Colors.black87,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("MISSION FAILED / GAME OVER", style: TextStyle(color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        setState(() {
                          gameOver = false;
                          _initStage(size);
                        });
                      },
                      child: const Text("RETRY"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("MAIN MENU", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GamePainter extends CustomPainter {
  final String mode;
  final Offset p1;
  final int p1Hp;
  final Offset? p2;
  final int p2Hp;
  final List<_Entity> enemies;
  final List<_Bullet> bullets;
  final List<Rect> walls;
  final bool isStealth;
  final String scpCode;
  final Rect scpRect;
  final double containProgress;
  final bool inPocket;
  final Rect exitPortal;
  final bool hasMtf;
  final bool wearingGoggles;
  final bool scp096Enraged;

  _GamePainter({
    required this.mode,
    required this.p1,
    required this.p1Hp,
    required this.p2,
    required this.p2Hp,
    required this.enemies,
    required this.bullets,
    required this.walls,
    required this.isStealth,
    required this.scpCode,
    required this.scpRect,
    required this.containProgress,
    required this.inPocket,
    required this.exitPortal,
    required this.hasMtf,
    required this.wearingGoggles,
    required this.scp096Enraged,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.brown;
    for (var w in walls) {
      canvas.drawRRect(RRect.fromRectAndRadius(w, const Radius.circular(4)), paint);
    }

    if (inPocket) {
      paint.color = Colors.green;
      canvas.drawRRect(RRect.fromRectAndRadius(exitPortal, const Radius.circular(10)), paint);
    }

    if (mode == "MISSION") {
      paint.color = scpCode == "SCP-173"
          ? const Color(0xFFC3B49B)
          : (scpCode == "SCP-096" ? const Color(0xFFEBE1E1) : (scpCode == "SCP-106" ? Colors.black : Colors.purple));
      canvas.drawRRect(RRect.fromRectAndRadius(scpRect, const Radius.circular(6)), paint);

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      paint.color = scp096Enraged ? Colors.red : Colors.white;
      canvas.drawRRect(RRect.fromRectAndRadius(scpRect, const Radius.circular(6)), paint);
      paint.style = PaintingStyle.fill;

      _drawText(canvas, scpCode.replaceAll("SCP-", ""), scpRect.center, scpCode == "SCP-106" ? Colors.yellow : Colors.black);

      if (containProgress > 0) {
        paint.color = Colors.cyanAccent;
        canvas.drawRect(Rect.fromLTWH(scpRect.left, scpRect.bottom + 5, (containProgress / 100) * scpRect.width, 6), paint);
      }
    }

    if (hasMtf) {
      paint.color = Colors.blue.shade800;
      canvas.drawRect(Rect.fromCenter(center: p1 + const Offset(-45, 0), width: 26, height: 26), paint);
      _drawText(canvas, "MTF", p1 + const Offset(-45, 0), Colors.white, fontSize: 10);
    }

    if (p1Hp > 0) {
      paint.color = isStealth ? Colors.blueGrey : Colors.cyanAccent;
      canvas.drawRRect(RRect.fromCenter(center: p1, width: 38, height: 38, radius: const Radius.circular(8)), paint);
      _drawText(canvas, "P1", p1, Colors.black);
    }

    if (p2 != null && p2Hp > 0) {
      paint.color = Colors.orangeAccent;
      canvas.drawRRect(RRect.fromCenter(center: p2!, width: 38, height: 38, radius: const Radius.circular(8)), paint);
      _drawText(canvas, "P2", p2!, Colors.black);
    }

    if (!inPocket) {
      for (var e in enemies) {
        if (isStealth) {
          paint.style = PaintingStyle.stroke;
          paint.color = Colors.red.withValues(alpha: 0.4);
          canvas.drawCircle(e.rect.center, 110, paint);
          paint.style = PaintingStyle.fill;
        }
        paint.color = e.color;
        canvas.drawRRect(RRect.fromRectAndRadius(e.rect, const Radius.circular(5)), paint);

        paint.color = Colors.green;
        canvas.drawRect(Rect.fromLTWH(e.rect.left, e.rect.top - 7, (e.hp / e.maxHp) * e.rect.width, 4), paint);
      }
    }

    for (var b in bullets) {
      paint.color = b.color;
      canvas.drawRect(b.rect, paint);
    }
  }

  void _drawText(Canvas canvas, String text, Offset center, Color color, {double fontSize = 12}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
