import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/router/router.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlAppwrite Starter'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.goNamed(AppRoutes.profile),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Logo(basePath: 'packages/components/',),
            const SizedBox(height: 20.0),
            Text(
              "Welcome to FlAppwrite Starter template, your base to build awesome applications.",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
