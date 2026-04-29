import 'dart:math';

import 'package:tabla_mareas/domain/entities/random_number.dart';

abstract class RandomNumberRemoteDataSource {
  Future<RandomNumber> getRandomNumber();
}

class RandomNumberRemoteDataSourceImpl implements RandomNumberRemoteDataSource {
  @override
  Future<RandomNumber> getRandomNumber() async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));
    final randomNumber = Random().nextInt(100);
    return RandomNumber(value: randomNumber);
  }
}
