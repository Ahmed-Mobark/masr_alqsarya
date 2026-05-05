import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:masr_al_qsariya/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:masr_al_qsariya/features/messages/domain/repositories/messages_repository.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/download_chat_attachment_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_audit_logs_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_messages_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_threads_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_tone_insights_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/log_chat_moderation_decision_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/send_chat_message_usecase.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/conversation_insights_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/messages_cubit.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';

Future<void> initMessagesInjection(GetIt sl) async {
  sl.registerLazySingleton<MessagesRemoteDataSource>(
    () => MessagesRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<MessagesRepository>(
    () => MessagesRepositoryImpl(sl<MessagesRemoteDataSource>(), sl<Storage>()),
  );

  sl.registerLazySingleton<GetChatThreadsUseCase>(
    () => GetChatThreadsUseCase(sl<MessagesRepository>()),
  );

  sl.registerLazySingleton<GetChatMessagesUseCase>(
    () => GetChatMessagesUseCase(sl<MessagesRepository>()),
  );

  sl.registerLazySingleton<SendChatMessageUseCase>(
    () => SendChatMessageUseCase(sl<MessagesRepository>()),
  );

  sl.registerLazySingleton<LogChatModerationDecisionUseCase>(
    () => LogChatModerationDecisionUseCase(sl<MessagesRepository>()),
  );

  sl.registerLazySingleton<DownloadChatAttachmentUseCase>(
    () => DownloadChatAttachmentUseCase(sl<MessagesRepository>()),
  );

  sl.registerLazySingleton<GetChatToneInsightsUseCase>(
    () => GetChatToneInsightsUseCase(sl<MessagesRepository>()),
  );

  sl.registerLazySingleton<GetChatAuditLogsUseCase>(
    () => GetChatAuditLogsUseCase(sl<MessagesRepository>()),
  );

  sl.registerFactory<ConversationInsightsCubit>(
    () => ConversationInsightsCubit(
      sl<GetChatToneInsightsUseCase>(),
      sl<GetChatAuditLogsUseCase>(),
    ),
  );

  sl.registerFactory<MessagesCubit>(
    () => MessagesCubit(
      sl<GetChatThreadsUseCase>(),
      sl<WorkspaceIdStorage>(),
    ),
  );
}
