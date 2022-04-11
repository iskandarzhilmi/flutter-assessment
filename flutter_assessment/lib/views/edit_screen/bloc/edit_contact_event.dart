part of 'edit_contact_bloc.dart';

@immutable
abstract class EditContactEvent extends Equatable {
  const EditContactEvent();

  @override
  List<Object?> get props => [];
}

class EditContactSubmitted extends EditContactEvent {
  const EditContactSubmitted(this.contact);

  final Contact contact;

  @override
  List<Object?> get props => [contact];

  //how can i sharpen my axe
}
