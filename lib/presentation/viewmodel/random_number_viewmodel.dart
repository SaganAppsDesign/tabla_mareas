import 'package:tabla_mareas/domain/usecases/get_random_number_usecase.dart';
import 'package:tabla_mareas/core/presentation/base_viewmodel.dart';
import 'package:tabla_mareas/core/usecases/usecase.dart';

class RandomNumberViewModel extends BaseViewModel {
  RandomNumberViewModel(this._getRandomNumberUseCase);
  final GetRandomNumberUseCase _getRandomNumberUseCase;

  int? _randomNumber;
  int? get randomNumber => _randomNumber;

  Future<void> fetchRandomNumber() async {
    setLoading(true);
    clearError();

    final result = await _getRandomNumberUseCase(NoParams());

    result.fold(
      (failure) => setError(failure.message),
      (randomNumber) => _randomNumber = randomNumber.value,
    );

    setLoading(false);
  }
}
