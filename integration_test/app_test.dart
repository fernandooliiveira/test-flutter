import 'package:client_control/models/clients.dart';
import 'package:client_control/models/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:client_control/main.dart' as app;
import 'package:provider/provider.dart';


void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Integration Test", (widgetTester) async {
    final providerKey = GlobalKey();
    app.main(list: [], providerKey: providerKey);
    await widgetTester.pumpAndSettle();
    //Testando tela inicial
    expect(find.text("Clientes"), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    //Testando drawer
    await widgetTester.tap(find.byIcon(Icons.menu));
    await widgetTester.pumpAndSettle();

    expect(find.text("Menu"), findsOneWidget);
    expect(find.text("Gerenciar clientes"), findsOneWidget);
    expect(find.text("Tipos de clientes"), findsOneWidget);
    expect(find.text("Sair"), findsOneWidget);

    //Testando a navegação
    await widgetTester.tap(find.text('Tipos de clientes'));
    await widgetTester.pumpAndSettle();

    expect(find.text("Tipos de cliente"), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.text("Platinum"), findsOneWidget);
    expect(find.text("Golden"), findsOneWidget);
    expect(find.text("Titanium"), findsOneWidget);
    expect(find.text("Diamond"), findsOneWidget);

    //Testar a criação de um tipo de cliente
    await widgetTester.tap(find.byType(FloatingActionButton));
    await widgetTester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    await widgetTester.enterText(find.byType(TextFormField), "Ferro");
    await widgetTester.tap(find.text('Selecionar icone'));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byIcon(Icons.card_giftcard));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text("Salvar"));
    await widgetTester.pumpAndSettle();

    expect(find.text("Ferro"), findsOneWidget);
    expect(find.byIcon(Icons.card_giftcard), findsOneWidget);

    expect(Provider.of<Types>(providerKey.currentContext!, listen: false).types.last.name, 'Ferro');
    expect(Provider.of<Types>(providerKey.currentContext!, listen: false).types.last.icon, Icons.card_giftcard);

    //TESTANDO NOVO CLIENTE
    await widgetTester.tap(find.byIcon(Icons.menu));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text("Gerenciar clientes"));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byType(FloatingActionButton));
    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(find.byKey(const Key('NameKey1')), "Fernando");
    await widgetTester.enterText(find.byKey(const Key('EmailKey1')), "Fernando@email");

    await widgetTester.tap(find.byIcon(Icons.arrow_downward));
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text("Ferro").last);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.text("Salvar"));
    await widgetTester.pumpAndSettle();

    //Verificando se o Cliente apareceu devidamente
    expect(find.text('Fernando (Ferro)'), findsOneWidget);
    expect(find.byIcon(Icons.card_giftcard), findsOneWidget);

    expect(Provider.of<Clients>(providerKey.currentContext!, listen: false).clients.last.name, 'Fernando');
    expect(Provider.of<Clients>(providerKey.currentContext!, listen: false).clients.last.email, 'Fernando@email');

  });

}