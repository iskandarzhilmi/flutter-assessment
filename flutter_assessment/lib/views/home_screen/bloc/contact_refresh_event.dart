part of 'contact_refresh_bloc.dart';

abstract class ContactRefreshEvent extends Equatable {
  const ContactRefreshEvent();
  @override
  List<Object?> get props => [];
}

class ContactRefreshPressed extends ContactRefreshEvent {
  const ContactRefreshPressed();
}
