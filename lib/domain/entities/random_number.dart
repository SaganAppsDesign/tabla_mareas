import 'package:equatable/equatable.dart';

class RandomNumber extends Equatable {
  const RandomNumber({required this.value});
  final int value;

  @override
  List<Object?> get props => [value];
}
