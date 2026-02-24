abstract class BoardFormEvent {}

class BoardFormUpdateFieldsEvent extends BoardFormEvent {
  final String? title;
  final String? description;
  final String? color;

  BoardFormUpdateFieldsEvent({
    this.title,
    this.description,
    this.color,
  });
}

class CreateBoardEvent extends BoardFormEvent {}

class BoardFormResetEvent extends BoardFormEvent {
  final bool? showNotification;
  final bool? closeDialog;

  BoardFormResetEvent({
    this.showNotification,
    this.closeDialog,
  });
}
