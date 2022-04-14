part of 'contact_listing_bloc.dart';

abstract class ContactListingEvent extends Equatable {
  const ContactListingEvent();

  @override
  List<Object?> get props => [];
}

class ContactListingFromApiTriggered extends ContactListingEvent {
  const ContactListingFromApiTriggered();
}

class ContactListingFromDatabaseTriggered extends ContactListingEvent {
  const ContactListingFromDatabaseTriggered();
}

class ContactListingEditSubmitted extends ContactListingEvent {
  const ContactListingEditSubmitted(this.submittedContact);

  final Contact submittedContact;

  @override
  List<Object?> get props => [submittedContact];
}

class ContactListingDelete extends ContactListingEvent {
  const ContactListingDelete(this.contactIdSelected);

  final int contactIdSelected;

  @override
  List<Object?> get props => [contactIdSelected];
}

class ContactListingToggleFavourite extends ContactListingEvent {
  const ContactListingToggleFavourite(this.contactIdSelected);

  final int contactIdSelected;

  @override
  List<Object?> get props => [contactIdSelected];
}
