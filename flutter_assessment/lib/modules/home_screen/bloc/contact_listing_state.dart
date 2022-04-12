part of 'contact_listing_bloc.dart';

class ContactListingModel extends Equatable {
  final List<Contact> contactListFromApi;
  final List<Contact> contactListFromDatabase;
  final Contact? submittedContact;
  final ContactListingState contactListingState;

  const ContactListingModel({
    required this.contactListFromApi,
    required this.contactListFromDatabase,
    this.submittedContact,
    required this.contactListingState,
  });

  @override
  List<Object?> get props =>
      [contactListFromApi, contactListFromDatabase, ContactListingState];

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
    ContactListingState? newContactListingState,
  }) {
    return ContactListingModel(
      contactListFromApi: newContactListFromApi ?? contactListFromApi,
      contactListFromDatabase:
          newContactListFromDatabase ?? contactListFromDatabase,
      submittedContact: newSubmittedContact ?? submittedContact,
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
