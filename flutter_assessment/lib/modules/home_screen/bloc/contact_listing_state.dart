part of 'contact_listing_bloc.dart';

class ContactListingModel extends Equatable {
  final List<Contact> contactListFromApi;
  final List<Contact> contactListFromDatabase;
  final Contact? submittedContact;
  final ContactListingState contactListingState;
  final int? contactIdSelected;

  const ContactListingModel({
    required this.contactListFromApi,
    required this.contactListFromDatabase,
    this.submittedContact,
    required this.contactListingState,
    this.contactIdSelected,
  });

  @override
  List<Object?> get props => [
        contactListFromApi,
        contactListFromDatabase,
        submittedContact,
        contactIdSelected,
        contactListingState
      ];

  factory ContactListingModel.initial() {
    return ContactListingModel(
      contactListFromApi: const [],
      contactListFromDatabase: const [],
      contactListingState: ContactListingLoadingFromApi(),
    );
  }

  ContactListingModel copyWith({
    List<Contact>? newContactListFromApi,
    List<Contact>? newContactListFromDatabase,
    Contact? newSubmittedContact,
    int? newContactIdSelected,
    ContactListingState? newContactListingState,
  }) {
    return ContactListingModel(
      contactListFromApi: newContactListFromApi ?? contactListFromApi,
      contactListFromDatabase:
          newContactListFromDatabase ?? contactListFromDatabase,
      submittedContact: newSubmittedContact ?? submittedContact,
      contactIdSelected: newContactIdSelected ?? contactIdSelected,
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

class ContactListingLoadingDelete extends ContactListingState {}

class ContactListingLoadingToggleFavourite extends ContactListingState {}

class ContactListingLoaded extends ContactListingState {}

class ContactListingError extends ContactListingState {
  final String message;
  ContactListingError({required this.message});
  @override
  List<Object> get props => [message];
}
