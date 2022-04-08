part of 'edit_contact_bloc.dart';

class EditContactModel extends Equatable {
  final Contact? contact;
  final EditContactState editContactState;

  const EditContactModel({
    required this.contact,
    required this.editContactState,
  });

  factory EditContactModel.initial() {
    return EditContactModel(
      contact: null,
      editContactState: EditContactLoading(),
    );
  }

  EditContactModel copyWith({
    Contact? newContact,
    EditContactState? newEditContactState,
  }) {
    return EditContactModel(
      contact: newContact ?? contact,
      editContactState: newEditContactState ?? editContactState,
    );
  }

  @override
  List<Object?> get props => [contact, editContactState];
}

abstract class EditContactState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditContactInitial extends EditContactState {}

class EditContactLoading extends EditContactState {}

class EditContactLoaded extends EditContactState {}

class EditContactError extends EditContactState {
  final String message;
  EditContactError({required this.message});

  @override
  List<Object> get props => [message];
}
