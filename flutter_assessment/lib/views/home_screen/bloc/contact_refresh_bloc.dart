import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_assessment/services/contact_model.dart';

part 'contact_refresh_event.dart';
part 'contact_refresh_state.dart';

//TODO: Change this and other's name to ContactListing
class ContactRefreshBloc
    extends Bloc<ContactRefreshEvent, ContactRefreshModel> {
  ContactRefreshBloc() : super(ContactRefreshModel.initial()) {
    on<ContactRefreshFromApiTriggered>(_onContactRefreshFromApiTriggered);
    on<ContactRefreshFromDatabaseTriggered>(
        _onContactRefreshFromDatabaseTriggered);
    on<ContactEditSubmitted>(_onContactEditSubmitted);
  }

  _onContactRefreshFromApiTriggered(
      ContactRefreshFromApiTriggered event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          newContactRefreshState: ContactRefreshLoading(),
        ),
      );

      List<Contact> contactListFromApi =
          await ContactRepoInterface().getContactListFromApi();

      await ContactRepoInterface().insertContactList(contactListFromApi);

      emit(
        state.copyWith(
          newContactListFromApi: contactListFromApi,
          newContactRefreshState: ContactRefreshLoadingFromDatabase(),
        ),
      );

      List<Contact> contactListFromDatabase =
          await ContactRepoInterface().getContactListFromDatabase();

      emit(
        state.copyWith(
          newContactListFromDatabase: contactListFromDatabase,
          newContactRefreshState: ContactRefreshLoaded(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          newContactRefreshState:
              ContactRefreshError(message: 'Contact load failed.'),
        ),
      );
    }
  }

  _onContactRefreshFromDatabaseTriggered(
      ContactRefreshFromDatabaseTriggered event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          newContactRefreshState: ContactRefreshLoadingFromDatabase(),
        ),
      );

      List<Contact> contactListFromDatabase =
          await ContactRepoInterface().getContactListFromDatabase();

      emit(
        state.copyWith(
          newContactRefreshState: ContactRefreshLoaded(),
          newContactListFromDatabase: contactListFromDatabase,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          newContactRefreshState:
              ContactRefreshError(message: 'Fetching from database failed.'),
        ),
      );
    }
  }

  _onContactEditSubmitted(ContactEditSubmitted event, Emitter emit) async {
    try {
      Contact contact = event.submittedContact;

      emit(
        state.copyWith(
          newContactRefreshState: ContactRefreshLoading(),
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
          newContactRefreshState: ContactRefreshError(
            message: 'Contact edit submission failed.',
          ),
        ),
      );
    }
  }
}
