import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://goqvhmgdefqpfmqusmlg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdvcXZobWdkZWZxcGZtcXVzbWxnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk1MTE3NDAsImV4cCI6MjA1NTA4Nzc0MH0.A8Fsx15b5COywRps30GLc9ECB8XqinmOEnKA4PadEEA',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Instruments',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client.from('instruments').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data available"));
          }

          final List instruments = snapshot.data as List;

          return ListView.builder(
            itemCount: instruments.length,
            itemBuilder: (context, index) {
              final instrument = instruments[index] as Map<String, dynamic>;
              return ListTile(
                title: Text(instrument['name'] ?? 'Unknown'),
              );
            },
          );
        },
      ),
    );
  }
}


// class _HomePageState extends State<HomePage> {
//   final _future = Supabase.instance.client
//       .from('instruments')
//       .select();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _future,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final instruments = snapshot.data!;
//           return ListView.builder(
//             itemCount: instruments.length,
//             itemBuilder: ((context, index) {
//               final instrument = instruments[index];
//               return ListTile(
//                 title: Text(instrument['name']),
//               );
//             }),
//           );
//         },
//       ),
//     );
//   }
// }