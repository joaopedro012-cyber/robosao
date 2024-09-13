// // ignore_for_file: depend_on_referenced_packages

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   testWidgets('Testa se o HomeScreen carrega corretamente', (WidgetTester tester) async {
//     // Construa o widget HomeScreen
//     await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

//     // Verifique se o texto "Home" está presente
//     expect(find.text('Home'), findsOneWidget);

//     // Verifique se o botão com o texto "Ir para Administração" está presente
//     expect(find.text('Ir para Administração'), findsOneWidget);

//     // Simule um clique no botão
//     await tester.tap(find.byType(ElevatedButton));
    
//     // Aguarde que todas as interações sejam processadas
//     await tester.pumpAndSettle();

//     // Aqui você pode adicionar mais verificações após a interação
//   });
// }
