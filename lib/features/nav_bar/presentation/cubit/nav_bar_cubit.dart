import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit() : super(const NavBarState(currentIndex: 0, hasUnreadMessages: true));

  void setIndex(int index) {
    if (index == state.currentIndex) return;
    emit(state.copyWith(currentIndex: index));
  }

  void setHasUnreadMessages(bool hasUnreadMessages) {
    if (hasUnreadMessages == state.hasUnreadMessages) return;
    emit(state.copyWith(hasUnreadMessages: hasUnreadMessages));
  }
}

class NavBarState extends Equatable {
  final int currentIndex;
  final bool hasUnreadMessages;

  const NavBarState({
    required this.currentIndex,
    required this.hasUnreadMessages,
  });

  NavBarState copyWith({
    int? currentIndex,
    bool? hasUnreadMessages,
  }) {
    return NavBarState(
      currentIndex: currentIndex ?? this.currentIndex,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
    );
  }

  @override
  List<Object> get props => [currentIndex, hasUnreadMessages];
}

