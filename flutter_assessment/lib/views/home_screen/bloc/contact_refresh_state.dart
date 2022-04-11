part of 'contact_refresh_bloc.dart';

class ContactRefreshModel extends Equatable {
  final List<Contact> contactListFromApi;
  final List<Contact> contactListFromDatabase;
  final Contact? submittedContact;
  final ContactRefreshState contactRefreshState;

  const ContactRefreshModel({
    required this.contactListFromApi,
    required this.contactRefreshState,
    this.submittedContact,
    required this.contactListFromDatabase,
  });

  @override
  List<Object?> get props =>
      [contactListFromApi, contactListFromDatabase, contactRefreshState];

  factory ContactRefreshModel.initial() {
    return ContactRefreshModel(
      contactListFromApi: const [],
      contactListFromDatabase: const [],
      // submittedContact: Contact(),
      contactRefreshState: ContactRefreshLoading(),
    );
  }

  ContactRefreshModel copyWith({
    List<Contact>? newContactListFromApi,
    List<Contact>? newContactListFromDatabase,
    Contact? newSubmittedContact,
    ContactRefreshState? newContactRefreshState,
  }) {
    return ContactRefreshModel(
      contactListFromApi: newContactListFromApi ?? contactListFromApi,
      contactListFromDatabase:
          newContactListFromDatabase ?? contactListFromDatabase,
      submittedContact: newSubmittedContact ?? submittedContact,
      contactRefreshState: newContactRefreshState ?? contactRefreshState,
    );
  }
}

abstract class ContactRefreshState extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactRefreshLoading extends ContactRefreshState {}

class ContactRefreshLoadingFromApi extends ContactRefreshState {}

class ContactRefreshLoadingFromDatabase extends ContactRefreshState {}

class ContactRefreshLoaded extends ContactRefreshState {}

class ContactRefreshError extends ContactRefreshState {
  final String message;
  ContactRefreshError({required this.message});
  @override
  List<Object> get props => [message];
}
