import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_assessment/services/contact_model.dart';

part 'contact_refresh_event.dart';
part 'contact_refresh_state.dart';

class ContactBloc extends Bloc<ContactRefreshEvent, ContactRefreshModel> {
  ContactBloc() : super(ContactRefreshModel.initial()) {
    on<ContactRefreshPressed>(_onContactRefreshPressed);
  }

  final ContactRefreshRepoInterface contactRefreshRepoInterface =
      ContactRefreshRepoInterface();

  _onContactRefreshPressed(ContactRefreshPressed event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          newContactRefreshState: ContactRefreshLoading(),
        ),
      );

      List<Contact> contactList =
          await contactRefreshRepoInterface.getContactListFromApi();
      emit(
        state.copyWith(
          newContactList: contactList,
          newContactRefreshState: ContactRefreshLoadingFromDatabase(),
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
}
