import 'package:equatable/equatable.dart';

class CompanyRuleCategoryEntity extends Equatable {
  final int id;
  final String name;

  const CompanyRuleCategoryEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
