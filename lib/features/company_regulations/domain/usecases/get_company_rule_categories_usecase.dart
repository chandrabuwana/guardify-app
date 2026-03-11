import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/company_rule_category_entity.dart';
import '../repositories/document_repository.dart';

@injectable
class GetCompanyRuleCategoriesUseCase {
  final DocumentRepository repository;

  GetCompanyRuleCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CompanyRuleCategoryEntity>>> call() async {
    return await repository.getCompanyRuleCategories();
  }
}
