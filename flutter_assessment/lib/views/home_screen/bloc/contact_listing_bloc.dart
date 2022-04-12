import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_assessment/services/contact_model.dart';

part 'contact_listing_event.dart';
part 'contact_listing_state.dart';

class ContactListingBloc
    extends Bloc<ContactListingEvent, ContactListingModel> {
  ContactListingBloc() : super(ContactListingModel.initial()) {
    on<ContactListingFromApiTriggered>(_onContactListingFromApiTriggered);
    on<ContactListingFromDatabaseTriggered>(
        _onContactListingFromDatabaseTriggered);
    on<ContactListingEditSubmitted>(_onContactListingEditSubmitted);
  }

  _onContactListingFromApiTriggered(
      ContactListingFromApiTriggered event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          newContactListingState: ContactListingLoading(),
        ),
      );

      List<Contact> contactListFromApi =
          await ContactRepoInterface().getContactListFromApi();

      await ContactRepoInterface().insertContactList(contactListFromApi);

      emit(
        state.copyWith(
          newContactListFromApi: contactListFromApi,
          newContactListingState: ContactListingLoadingFromDatabase(),
        ),
      );

      List<Contact> contactListFromDatabase =
          await ContactRepoInterface().getContactListFromDatabase();

      emit(
        state.copyWith(
          newContactListFromDatabase: contactListFromDatabase,
          newContactListingState: ContactListingLoaded(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          newContactListingState:
              ContactListingError(message: 'Contact load failed.'),
        ),
      );
    }
  }

  _onContactListingFromDatabaseTriggered(
      ContactListingFromDatabaseTriggered event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          newContactListingState: ContactListingLoadingFromDatabase(),
        ),
      );

      List<Contact> contactListFromDatabase =
          await ContactRepoInterface().getContactListFromDatabase();

      emit(
        state.copyWith(
          newContactListingState: ContactListingLoaded(),
          newContactListFromDatabase: contactListFromDatabase,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          newContactListingState:
              ContactListingError(message: 'Fetching from database failed.'),
        ),
      );
    }
  }

  _onContactListingEditSubmitted(
      ContactListingEditSubmitted event, Emitter emit) async {
    try {
      Contact contact = event.submittedContact;

      emit(
        state.copyWith(
          newContactListingState: ContactListingLoading(),
          newSubmittedContact: event.submittedContact,
        ),
      );

      ContactRepoInterface().editContact(
        contact.id,
        contact.firstName,
        contact.lastName,
        contact.email,
      );
    } catch (e) {
      emit(
        state.copyWith(
          newContactListingState: ContactListingError(
            message: 'Contact edit submission failed.',
          ),
        ),
      );
    }
  }
}
