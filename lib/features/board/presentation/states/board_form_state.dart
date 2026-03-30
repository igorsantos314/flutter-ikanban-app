class BoardFormState {
  final int? boardId; // null = create, non-null = edit
  final String title;
  final String? description;
  final String? color;
  final bool isLoading;
  final String? errorMessage;
  final String? titleError;
  final bool showNotification;
  final bool closeDialog;

  const BoardFormState({
    this.boardId,
    required this.title,
    this.description,
    this.color,
    required this.isLoading,
    this.errorMessage,
    this.titleError,
    this.showNotification = false,
    this.closeDialog = false,
  });

  bool get isEditMode => boardId != null;

  factory BoardFormState.initial() {
    return const BoardFormState(
      title: '',
      description: '',
      color: '#FF6B6B',
      isLoading: false,
    );
  }

  BoardFormState copyWith({
    int? boardId,
    String? title,
    String? description,
    String? color,
    bool? isLoading,
    String? errorMessage,
    String? titleError,
    bool? showNotification,
    bool? closeDialog,
  }) {
    return BoardFormState(
      boardId: boardId ?? this.boardId,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      titleError: titleError,
      showNotification: showNotification ?? false,
      closeDialog: closeDialog ?? false,
    );
  }
}
