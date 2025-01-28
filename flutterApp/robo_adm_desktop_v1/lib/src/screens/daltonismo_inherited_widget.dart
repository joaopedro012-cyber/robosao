import 'package:flutter/material.dart';

// InheritedWidget para controlar a configuração do modo Daltonismo
class DaltonismoInheritedWidget extends InheritedWidget {
  final bool isDaltonismo;

  // No caso de InheritedWidget, o 'child' é passado diretamente para o super
  const DaltonismoInheritedWidget({
    required this.isDaltonismo,
    required super.child,
    super.key,
  });

  // Método para acessar o estado global de Daltonismo
  static DaltonismoInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DaltonismoInheritedWidget>();
  }

  // Indicando que estamos sobrescrevendo o método updateShouldNotify
  @override
  bool updateShouldNotify(DaltonismoInheritedWidget oldWidget) {
    return oldWidget.isDaltonismo != isDaltonismo;
  }
}
