import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_assessment/services/contact_model.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactStateModel> {
  ContactBloc() : super(ContactStateModel.initial()) {
    on<ContactRefreshPressed>(_onContactRefreshPressed);
  }

  final ContactRepoInterface contactRepoInterface = ContactRepoInterface();

  _onContactRefreshPressed(ContactRefreshPressed event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          newContactState: ContactLoading(),
        ),
      );

      List<Contact> contactList = await contactRepoInterface.getContactList();
      emit(state.copyWith(
        newContactList: contactList,
        newContactState: ContactLoaded(),
      ));
      // if(state.copyWith(newContactList: contactList,))
    } catch (e) {
      emit(
        state.copyWith(
          newContactState: ContactError(message: 'Contact load failed.'),
        ),
      );
    }
  }
}
