import 'package:flutter_test/flutter_test.dart';
import 'package:mi_bolsillo/models/movimiento.dart';
import 'package:mi_bolsillo/services/finanzas.dart';
import 'package:mi_bolsillo/services/validadores.dart';

void main() {
  test('formatearPesos agrupa miles', () {
    expect(Finanzas.formatearPesos(1234567), '\$1.234.567');
    expect(Finanzas.formatearPesos(-5000), '-\$5.000');
  });

  test('validarMonto rechaza vacío, texto y cero', () {
    expect(Finanzas.validarMonto(''), isNotNull);
    expect(Finanzas.validarMonto('abc'), isNotNull);
    expect(Finanzas.validarMonto('0'), isNotNull);
    expect(Finanzas.validarMonto('15000'), isNull);
  });

  test('mesesParaMeta usa while finito', () {
    expect(Finanzas.mesesParaMeta(meta: 1000, ahorrado: 0, ahorroMensual: 250), 4);
    expect(Finanzas.mesesParaMeta(meta: 1000, ahorrado: 0, ahorroMensual: 0), isNull);
  });

  test('gastosPorCategoria suma solo gastos', () {
    final lista = [
      Movimiento(id: '1', descripcion: 'Almuerzo', monto: 12000, tipo: TipoMovimiento.gasto, categoria: 'Alimentación', fecha: DateTime(2026, 10, 1)),
      Movimiento(id: '2', descripcion: 'Mesada', monto: 500000, tipo: TipoMovimiento.ingreso, categoria: 'Mesada', fecha: DateTime(2026, 10, 1)),
    ];
    expect(Finanzas.gastosPorCategoria(lista), {'Alimentación': 12000});
  });

  test('validar correo y contraseña del acceso', () {
    expect(Validadores.correo(''), isNotNull);
    expect(Validadores.correo('sin-arroba'), isNotNull);
    expect(Validadores.correo('ana@correo.com'), isNull);
    expect(Validadores.contrasena('123'), isNotNull);
    expect(Validadores.contrasena('123456'), isNull);
  });
}
