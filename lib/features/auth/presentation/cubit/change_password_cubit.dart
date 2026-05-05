import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._changePasswordUseCase)
      : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePasswordUseCase;

  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void toggleObscureCurrent() =>
      emit(state.copyWith(obscureCurrent: !state.obscureCurrent));

  void toggleObscureNew() => emit(state.copyWith(obscureNew: !state.obscureNew));

  void toggleObscureConfirm() =>
      emit(state.copyWith(obscureConfirm: !state.obscureConfirm));

  String? validateCurrentPassword(String? value) =>
      Validator.defaultValidator(value);

  String? validateNewPassword(String? value) => Validator.password(value);

  String? validateConfirmPassword(String? value) =>
      Validator.confirmPassword(value, newPasswordController.text);

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(
      state.copyWith(
        status: ChangePasswordStatus.loading,
        clearError: true,
      ),
    );

    final result = await _changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: currentPasswordController.text.trim(),
        password: newPasswordController.text,
        passwordConfirmation: confirmPasswordController.text,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ChangePasswordStatus.success)),
    );
  }

  void resetStatusAfterHandled() {
    emit(state.copyWith(status: ChangePasswordStatus.initial, clearError: true));
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
