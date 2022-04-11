part of 'contact_refresh_bloc.dart';

abstract class ContactRefreshEvent extends Equatable {
  const ContactRefreshEvent();

  @override
  List<Object?> get props => [];
}

class ContactRefreshFromApiTriggered extends ContactRefreshEvent {
  const ContactRefreshFromApiTriggered();
}

class ContactRefreshFromDatabaseTriggered extends ContactRefreshEvent {
  const ContactRefreshFromDatabaseTriggered();
}

class ContactEditSubmitted extends ContactRefreshEvent {
  const ContactEditSubmitted(this.submittedContact);

  final Contact submittedContact;

  @override
  List<Object?> get props => [submittedContact];
}
