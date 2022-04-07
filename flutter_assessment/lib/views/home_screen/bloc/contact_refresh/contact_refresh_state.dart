part of 'contact_refresh_bloc.dart';

class ContactRefreshModel extends Equatable {
  final List<Contact> contactListFromApi;
  final List<Contact> contactListFromDatabase;
  final ContactListingState contactRefreshState;


  const ContactRefreshModel({
    required this.contactListFromApi,
    required this.contactRefreshState,
    required this.contactListFromDatabase,
  });

  @override
  List<Object?> get props => [contactListFromApi, contactListFromDatabase, contactRefreshState];

  factory ContactRefreshModel.initial() {
    return ContactRefreshModel(
      contactListFromApi: const [],
      contactListFromDatabase: const [],
      contactRefreshState: ContactRefreshLoading(),
    );
  }
  ContactRefreshModel copyWith({
    List<Contact>? newContactListFromApi,
    List<Contact>? newContactListFromDatabase,
    ContactListingState? newContactRefreshState,
  }) {
    return ContactRefreshModel(
      contactListFromApi: newContactListFromApi ?? contactListFromApi,
      contactListFromDatabase: newContactListFromDatabase ?? contactListFromDatabase,
      contactRefreshState: newContactRefreshState ?? contactRefreshState,
    );
  }
}

abstract class ContactListingState extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactRefreshLoading extends ContactListingState {}

class ContactRefreshLoadingFromApi extends ContactListingState {}

class ContactRefreshLoadingFromDatabase extends ContactListingState {}

class ContactRefreshLoaded extends ContactListingState {}

class ContactRefreshError extends ContactListingState {
  final String message;
  ContactRefreshError({required this.message});
  @override
  List<Object> get props => [message];
}
