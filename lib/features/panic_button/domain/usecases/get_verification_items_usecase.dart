import 'package:injectable/injectable.dart';
import '../repositories/panic_button_repository.dart';

@injectable
class GetVerificationItemsUseCase {
  final PanicButtonRepository repository;

  GetVerificationItemsUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getVerificationItems();
  }
}
