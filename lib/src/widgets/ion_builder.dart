import 'package:flutter/material.dart';
import 'package:ionex/src/core/ion.dart';

/// O [IonBuilder] é o widget reativo encarregado de escutar as mudanças de um [Ion].
///
/// Toda vez que o estado do [Ion] fornecido for modificado através de `.set()` ou
/// `.update()`, apenas o escopo delimitado pelo método [builder] será re-renderizado,
/// garantindo uma performance cirúrgica na interface de usuário.
class IonBuilder<T> extends StatelessWidget {
  /// O [Ion] que este widget ficará observando reativamente.
  final Ion<T> ion;

  /// A função que reconstrói a árvore de widgets baseando-se no novo valor do [Ion].
  ///
  /// Fornece o [BuildContext] atual e o valor [value] em tempo real do estado.
  final Widget Function(BuildContext context, T value) builder;

  /// Cria um [IonBuilder] associado a um [Ion] e a uma função de renderização [builder].
  const IonBuilder({
    super.key,
    required this.ion,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: ion,
      builder: (context, value, _) => builder(context, value),
    );
  }
}
