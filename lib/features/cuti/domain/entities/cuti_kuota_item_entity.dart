import 'package:equatable/equatable.dart';

class CutiKuotaItemEntity extends Equatable {
  final int quota;
  final int remaining;
  final String? leaveRequestName;

  const CutiKuotaItemEntity({
    required this.quota,
    required this.remaining,
    this.leaveRequestName,
  });

  @override
  List<Object?> get props => [quota, remaining, leaveRequestName];
}
