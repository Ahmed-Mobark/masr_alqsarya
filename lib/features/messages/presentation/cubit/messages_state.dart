import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_thread.dart';

enum MessagesStatus { initial, loading, success, failure }

class MessagesState extends Equatable {
  const MessagesState({
    this.status = MessagesStatus.initial,
    this.threads = const [],
    this.errorMessage,
  });

  final MessagesStatus status;
  final List<ChatThread> threads;
  final String? errorMessage;

  MessagesState copyWith({
    MessagesStatus? status,
    List<ChatThread>? threads,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessagesState(
      status: status ?? this.status,
      threads: threads ?? this.threads,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, threads, errorMessage];
}
