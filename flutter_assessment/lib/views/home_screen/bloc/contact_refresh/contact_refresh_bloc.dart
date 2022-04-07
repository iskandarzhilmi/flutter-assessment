import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_assessment/services/contact_model.dart';

part 'contact_refresh_event.dart';
part 'contact_refresh_state.dart';

class ContactRefreshBloc
    extends Bloc<ContactRefreshEvent, ContactRefreshModel> {
  ContactRefreshBloc() : super(ContactRefreshModel.initial()) {
    on<ContactRefreshButtonPressed>(_onContactRefreshPressed);
    on<ContactRefreshFromDatabaseTriggered>(
        _onContactRefreshFromDatabaseTriggered);
  }

  _onContactRefreshPressed(
      ContactRefreshButtonPressed event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          newContactRefreshState: ContactRefreshLoading(),
        ),
      );

      List<Contact> contactListFromApi =
          await ContactRefreshRepoInterface().getContactListFromApi();

      await ContactRefreshRepoInterface().insertContactList(contactListFromApi);

      emit(
        state.copyWith(
          newContactListFromApi: contactListFromApi,
          newContactRefreshState: ContactRefreshLoadingFromDatabase(),
        ),
      );

      List<Contact> contactListFromDatabase =
          await ContactRefreshRepoInterface().getContactListFromDatabase();

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
          await ContactRefreshRepoInterface().getContactListFromDatabase();

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
                ContactRefreshError(message: 'Fetching from database failed.')),
      );
    }
  }
}
