import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/mcp_gateway_service.dart';
import 'services/profile_service.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MCPPhoneApp());
}

class MCPPhoneApp extends StatelessWidget {
  const MCPPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProfileService()),
        ChangeNotifierProvider(create: (_) => MCPGatewayService()),
      ],
      child: MaterialApp(
        title: 'MCP Phone',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
