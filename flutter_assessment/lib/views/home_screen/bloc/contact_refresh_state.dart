part of 'contact_refresh_bloc.dart';

class ContactRefreshModel extends Equatable {
  final List<Contact> contactList;
  final ContactRefreshState contactState;

  const ContactRefreshModel({
    required this.contactList,
    required this.contactState,
  });

  @override
  List<Object?> get props => [contactList, contactState];

  factory ContactRefreshModel.initial() {
    return ContactRefreshModel(
      contactList: const [],
      contactState: ContactRefreshLoading(),
    );
  }
  ContactRefreshModel copyWith({
    List<Contact>? newContactList,
    ContactRefreshState? newContactRefreshState,
  }) {
    return ContactRefreshModel(
      contactList: newContactList ?? contactList,
      contactState: newContactRefreshState ?? contactState,
    );
  }
}

abstract class ContactRefreshState extends Equatable {
  @override
  List<Object> get props => [];
}

// class ContactInitial extends ContactState {}

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
