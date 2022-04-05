part of 'contact_bloc.dart';

class ContactStateModel extends Equatable {
  final List<Contact> contactList;
  final ContactState contactState;

  const ContactStateModel({
    required this.contactList,
    required this.contactState,
  });

  @override
  List<Object?> get props => [contactList, contactState];

  factory ContactStateModel.initial() {
    return ContactStateModel(
      contactList: const [],
      contactState: ContactLoading(),
    );
  }
  ContactStateModel copyWith({
    List<Contact>? newContactList,
    ContactState? newContactState,
  }) {
    return ContactStateModel(
      contactList: newContactList ?? contactList,
      contactState: newContactState ?? contactState,
    );
  }
}

abstract class ContactState extends Equatable {
  @override
  List<Object> get props => [];
}

// class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {}

class ContactError extends ContactState {
  final String message;

  ContactError({required this.message});

  @override
  List<Object> get props => [message];
}
