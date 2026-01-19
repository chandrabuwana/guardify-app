import 'package:equatable/equatable.dart';

class CutiKuotaItemEntity extends Equatable {
  final int quota;
  final int remaining;

  const CutiKuotaItemEntity({
    required this.quota,
    required this.remaining,
  });

  @override
  List<Object?> get props => [quota, remaining];
}
