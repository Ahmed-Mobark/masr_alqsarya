import 'package:equatable/equatable.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
    this.obscureCurrent = true,
    this.obscureNew = true,
    this.obscureConfirm = true,
  });

  final ChangePasswordStatus status;
  final String? errorMessage;
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
    bool? obscureCurrent,
    bool? obscureNew,
    bool? obscureConfirm,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      obscureCurrent: obscureCurrent ?? this.obscureCurrent,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        obscureCurrent,
        obscureNew,
        obscureConfirm,
      ];
}
