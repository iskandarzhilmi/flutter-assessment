part of 'contact_listing_bloc.dart';

class ContactListingModel extends Equatable {
  final List<Contact> contactListFromApi;
  final List<Contact> contactListFromDatabase;
  final Contact? submittedContact;
  final ContactListingState contactListingState;
  final int? contactIdToDelete;

  const ContactListingModel({
    required this.contactListFromApi,
    required this.contactListFromDatabase,
    this.submittedContact,
    required this.contactListingState,
    this.contactIdToDelete,
  });

  @override
  List<Object?> get props => [
        contactListFromApi,
        contactListFromDatabase,
        submittedContact,
        contactIdToDelete,
        contactListingState
      ];

  factory ContactListingModel.initial() {
    return ContactListingModel(
      contactListFromApi: const [],
      contactListFromDatabase: const [],
      contactListingState: ContactListingLoading(),
    );
  }

  ContactListingModel copyWith({
    List<Contact>? newContactListFromApi,
    List<Contact>? newContactListFromDatabase,
    Contact? newSubmittedContact,
    int? newContactIdToDelete,
    ContactListingState? newContactListingState,
  }) {
    return ContactListingModel(
      contactListFromApi: newContactListFromApi ?? contactListFromApi,
      contactListFromDatabase:
          newContactListFromDatabase ?? contactListFromDatabase,
      submittedContact: newSubmittedContact ?? submittedContact,
      contactIdToDelete: newContactIdToDelete ?? contactIdToDelete,
      contactListingState: newContactListingState ?? contactListingState,
    );
  }
}

abstract class ContactListingState extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactListingLoading extends ContactListingState {}

class ContactListingLoadingFromApi extends ContactListingState {}

class ContactListingLoadingFromDatabase extends ContactListingState {}

class ContactListingLoaded extends ContactListingState {}

class ContactListingError extends ContactListingState {
  final String message;
  ContactListingError({required this.message});
  @override
  List<Object> get props => [message];
}
