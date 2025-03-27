import 'package:flutter/material.dart';


class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class StatefulWidget {
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {

  static const String userNameKey = 'username';
  static const String userAgeKey = 'user_age';
  static const String userPaisKey = 'user_pais';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();

  String? _countryFlag;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString(userNameKey) ?? "";
      _ageController.text = prefs.getInt(userAgeKey).toString();
      _paisController.text = prefs.getString(userPaisKey) ?? "";
      _updateFlag(_paisController.text); // Carrega a bandeira ao carregar os dados
    });
  }

  void _saveUserData() async {
    String username = _nameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;
    String user_pais = _paisController.text;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setInt(userAgeKey, age);
    await preferences.setString(userNameKey, username);
    await preferences.setString(userPaisKey, user_pais);
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nameController.clear();
      _ageController.clear();
      _paisController.clear();
      _countryFlag = null; // Limpa a bandeira
    });
  }

  // Função para atualizar a bandeira com base no país digitado
  void _updateFlag(String countryName) {
    String flagUrl = _getFlagUrl(countryName);
    setState(() {
      _countryFlag = flagUrl;
    });
  }

  // Função para mapear o nome do país para o código da bandeira (ISO 3166-1 alpha-2)
  String _getFlagUrl(String countryName) {
    // Um mapeamento básico de países para o código de bandeira.
    // Esse mapeamento pode ser ampliado conforme necessário.
    final Map<String, String> countryFlags = {
      "Brasil": "assets/flags/br.svg",
      "Estados Unidos": "assets/flags/us.svg",
      "França": "assets/flags/fr.svg",
      "Alemanha": "assets/flags/de.svg",
      "Argentina": "assets/flags/ar.svg",
    };

    // Retorna a URL da bandeira baseada no país, ou uma bandeira padrão caso não encontre
    return countryFlags[countryName] ?? "assets/flags/default.svg";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações do Usuário')),
      body: _buildUserSettingScreenBody(),
    );
  }
  
  _buildUserSettingScreenBody() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Idade'),
              ),
              TextField(
                controller: _paisController,
                decoration: InputDecoration(labelText: 'Pais Favorito'),
                onChanged: _updateFlag, // Atualiza a bandeira ao digitar
              ),
              SizedBox(height: 20),
              // Exibe a bandeira do país
              _countryFlag != null
                  ? SvgPicture.asset(_countryFlag!, width: 50, height: 30)
                  : Container(),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(onPressed: _saveUserData, child: Text("Salvar")),
                  SizedBox(width: 40),
                  ElevatedButton(onPressed: _loadUserData, child: Text("Carregar")),
                  SizedBox(width: 40),
                  ElevatedButton(onPressed: _clearUserData, child: Text("Limpar Dados")),
                  SizedBox(width: 40),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
  
 
class SharedPreferences {
}

class SvgPicture {
  static asset(String s, {required int width, required int height}) {}
}
