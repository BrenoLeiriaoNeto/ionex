import 'package:flutter/material.dart';
import 'package:ionex/src/core/ion.dart';

/// O [IonProvider] é o widget responsável por injetar e propagar um [Ion]
/// através da árvore de widgets utilizando o contexto nativo do Flutter.
///
/// Ele permite que qualquer widget filho acesse o estado do [Ion] sem a necessidade
/// de passá-lo via construtor (prop drilling), utilizando o padrão Service Locator.
class IonProvider extends InheritedWidget {
  /// O [Ion] que será disponibilizado para a árvore de widgets abaixo deste provider.
  final Ion<dynamic> ion;

  /// Cria um [IonProvider] que injeta o [Ion] e envolve o [child] informado.
  const IonProvider({super.key, required this.ion, required super.child});

  /// Busca um [Ion] do tipo [T] especificado na árvore de widgets mais próxima
  /// acima do [context] fornecido.
  ///
  /// Lança uma [Exception] caso o [IonProvider] não seja encontrado no escopo atual.
  ///
  /// Exemplo de uso:
  /// `final authIon = IonProvider.of<User?>(context);`
  static Ion<T> of<T>(BuildContext context) {
    final IonProvider? provider =
        context.dependOnInheritedWidgetOfExactType<IonProvider>();

    if (provider == null) {
      throw Exception("Nenhum IonProvider encontrado no contexto atual. "
          "Certifique-se de envolver sua árvore de widgets com um IonProvider.");
    }
    return provider.ion as Ion<T>;
  }

  @override
  bool updateShouldNotify(IonProvider oldWidget) {
    // Como o prório Ion possui o mecanismo interno de notificação de ouvintes
    // (ValueNotifier), o InheritedWidget não precisa forçar a reconstrução de
    // toda a árvore caso a instância do Ion continue a mesma.
    return ion != oldWidget.ion;
  }
}
