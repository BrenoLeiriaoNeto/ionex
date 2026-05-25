import 'package:flutter/foundation.dart';

/// O [Ion] é a unidade fundamental de estado reativo na biblioteca Ionex.
///
/// Ele encapsula um pedaço de estado molecular e gerencia seus ouvintes de
/// forma extremamente leve, estendendo as capacidade nativas do [ValueNotifier].
class Ion<T> extends ValueNotifier<T> {
  /// Inicializa o [Ion] com um valor padrão obrigatório.
  Ion(super.value);

  /// Retorna o estado atual do Íon.
  ///
  /// Funciona exatamente como ler o valor bruto em memória.
  T get state => value;

  /// Atualiza o estado do Íon com um valor totalmente novo.
  ///
  /// É o equivalente ao `setAtom` do Jotai ou ao `setState` molecular.
  /// Notifica automaticamente todos os widgets ouvintes se o valor mudar.
  void set(T newValue) {
    value = newValue;
  }

  /// Modifica o estado atual baseando-se no valor anterior.
  ///
  /// Muito útil para incrementos, manipulação de listas ou mutação de objetos.
  /// Exemplo: `contadorIon.update((c) => c + 1);`
  void update(T Function(T currentState) updateFn) {
    value = updateFn(value);
  }

  /// Reinicia o Íon para um valor específico.
  ///
  /// Sintaxe helper para legibilidade em fluxos de logout ou limpeza de filtros.
  void reset(T initialValue) {
    value = initialValue;
  }
}
