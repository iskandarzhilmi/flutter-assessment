import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/repository/contact_repository.dart';
import 'package:flutter_assessment/services/contact_model.dart';
import 'package:flutter_assessment/views/home_screen/bloc/contact_refresh_bloc.dart';
import 'package:meta/meta.dart';

part 'edit_contact_event.dart';
part 'edit_contact_state.dart';

//TODO: Replace the name and related to it with suitable term.
class EditContactBloc extends Bloc<EditContactEvent, EditContactModel> {
  EditContactBloc() : super(EditContactModel.initial()) {
    on<EditContactSubmitted>(_onEditContactSubmitted);
  }

  _onEditContactSubmitted(EditContactSubmitted event, Emitter emit) async {
    try {
      Contact contact = event.contact;

      emit(
        state.copyWith(
          newEditContactState: EditContactLoading(),
          newContact: event.contact,
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
          newEditContactState: EditContactError(
            message: 'Contact edit submission failed.',
          ),
        ),
      );
    }
  }
}
