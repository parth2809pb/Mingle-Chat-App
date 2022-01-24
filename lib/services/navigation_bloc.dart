import 'package:bloc/bloc.dart';
import 'package:mingle/views/chatScreen.dart';
import 'package:mingle/views/peoplewindow.dart';
import 'package:mingle/views/profileWindow.dart';

enum NavigationEvent{ ChatWindowClickedEvent, PeopleClickedEvent, ProfileClickedEvent}

abstract class NavigationState{}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState>{
  NavigationBloc(NavigationState initialState) : super(initialState);

  @override
  NavigationState get initialState => ChatWindow();

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async*{
    // TODO: implement mapEventToState
    switch(event){
      case NavigationEvent.ChatWindowClickedEvent:
        yield ChatWindow();
        break;
      case NavigationEvent.PeopleClickedEvent:
        yield PeopleWindow();
        break;
      case NavigationEvent.ProfileClickedEvent:
        yield ProfileWindow();
        break;
    }
  }
}