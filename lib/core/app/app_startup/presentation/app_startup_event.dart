import 'package:equatable/equatable.dart';

abstract class AppStartupEvent extends Equatable {
  const AppStartupEvent();

  @override
  List<Object?> get props => [];
}

class InitializeApp extends AppStartupEvent {
  const InitializeApp();
}
