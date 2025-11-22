import 'package:cicatriza/core/utils/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimestampConverter', () {
    late TimestampConverter converter;

    setUp(() {
      converter = const TimestampConverter();
    });

    group('fromJson', () {
      test('Deve converter Timestamp para DateTime', () {
        final timestamp = Timestamp.fromDate(DateTime(2025, 11, 5, 10, 30));
        final result = converter.fromJson(timestamp);

        expect(result, isA<DateTime>());
        expect(result.year, 2025);
        expect(result.month, 11);
        expect(result.day, 5);
        expect(result.hour, 10);
        expect(result.minute, 30);
      });

      test('Deve converter String ISO8601 para DateTime', () {
        const isoString = '2025-11-05T15:30:00.000';
        final result = converter.fromJson(isoString);

        expect(result, isA<DateTime>());
        expect(result.year, 2025);
        expect(result.month, 11);
        expect(result.day, 5);
        expect(result.hour, 15);
        expect(result.minute, 30);
      });

      test('Deve converter int (milliseconds) para DateTime', () {
        final dateTime = DateTime(2025, 11, 5, 12, 0);
        final millis = dateTime.millisecondsSinceEpoch;

        final result = converter.fromJson(millis);

        expect(result, isA<DateTime>());
        expect(result.millisecondsSinceEpoch, millis);
      });

      test('Deve lançar ArgumentError para tipo não suportado', () {
        expect(
          () => converter.fromJson(12.5), // double não é suportado
          throwsArgumentError,
        );
      });

      test('Deve lançar ArgumentError para objeto não suportado', () {
        expect(
          () => converter.fromJson({'invalid': 'object'}),
          throwsArgumentError,
        );
      });
    });

    group('toJson', () {
      test('Deve converter DateTime para Timestamp', () {
        final dateTime = DateTime(2025, 11, 5, 14, 45);
        final result = converter.toJson(dateTime);

        expect(result, isA<Timestamp>());
        final timestamp = result as Timestamp;
        expect(timestamp.toDate(), dateTime);
      });

      test('Deve preservar data e hora ao converter', () {
        final dateTime = DateTime(2023, 1, 15, 9, 30, 45);
        final result = converter.toJson(dateTime);

        final timestamp = result as Timestamp;
        final converted = timestamp.toDate();

        expect(converted.year, dateTime.year);
        expect(converted.month, dateTime.month);
        expect(converted.day, dateTime.day);
        expect(converted.hour, dateTime.hour);
        expect(converted.minute, dateTime.minute);
        expect(converted.second, dateTime.second);
      });

      test('Deve converter DateTime.now() corretamente', () {
        final now = DateTime.now();
        final result = converter.toJson(now);

        expect(result, isA<Timestamp>());
        final timestamp = result as Timestamp;
        final converted = timestamp.toDate();

        // Verifica se a diferença é menor que 1 segundo (tolerância para conversão)
        final difference = converted.difference(now).abs();
        expect(difference.inSeconds, lessThan(1));
      });

      test('Deve converter datas antigas corretamente', () {
        final oldDate = DateTime(1990, 1, 1);
        final result = converter.toJson(oldDate);

        expect(result, isA<Timestamp>());
        final timestamp = result as Timestamp;
        expect(timestamp.toDate(), oldDate);
      });

      test('Deve converter datas futuras corretamente', () {
        final futureDate = DateTime(2030, 12, 31);
        final result = converter.toJson(futureDate);

        expect(result, isA<Timestamp>());
        final timestamp = result as Timestamp;
        expect(timestamp.toDate(), futureDate);
      });
    });

    group('Conversão bidirecional', () {
      test('Deve ser reversível: DateTime -> Timestamp -> DateTime', () {
        final original = DateTime(2025, 6, 15, 18, 30);

        final timestamp = converter.toJson(original) as Timestamp;
        final recovered = converter.fromJson(timestamp);

        expect(recovered, original);
      });

      test('Deve ser reversível para data atual', () {
        final original = DateTime.now();

        final timestamp = converter.toJson(original) as Timestamp;
        final recovered = converter.fromJson(timestamp);

        // Permite pequena diferença devido a precisão
        final difference = recovered.difference(original).abs();
        expect(difference.inMilliseconds, lessThan(10));
      });

      test('Deve ser reversível para int -> DateTime -> Timestamp', () {
        final millis = DateTime(2025, 3, 20, 10, 0).millisecondsSinceEpoch;

        final dateTime = converter.fromJson(millis);
        final timestamp = converter.toJson(dateTime) as Timestamp;
        final recovered = converter.fromJson(timestamp);

        expect(recovered.millisecondsSinceEpoch, millis);
      });
    });

    group('Edge cases', () {
      test('Deve lidar com string de data válida com timezone', () {
        const isoWithTz = '2025-11-05T15:30:00.000Z';
        final result = converter.fromJson(isoWithTz);

        expect(result, isA<DateTime>());
      });

      test('Deve lidar com milliseconds = 0 (Unix epoch)', () {
        final result = converter.fromJson(0);

        expect(result, isA<DateTime>());
        expect(result, DateTime.fromMillisecondsSinceEpoch(0));
      });

      test('Deve lidar com data no início do Unix epoch', () {
        final epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final result = converter.toJson(epoch);

        expect(result, isA<Timestamp>());
      });
    });
  });
}
