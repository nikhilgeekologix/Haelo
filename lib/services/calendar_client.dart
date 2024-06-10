import 'dart:isolate';

import 'package:device_calendar/device_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

// import 'package:googleapis/compute/v1.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

class CalendarClient {
  // static const _scopes = const [go.CalendarApi.calendarScope];

  // insert(title, startTime, endTime) {
  //   var _clientID = new ClientId("999104674185-0lklvrjp242lp3fiee8vqtcegvu0qvln.apps.googleusercontent.com", "");
  //   clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
  //     var calendar = CalendarApi(client);
  //     calendar.calendarList.list().then((value) => print("VAL________$value"));
  //
  //     String calendarId = "primary";
  //     Event event = Event(); // Create object of event
  //
  //     event.summary = title;
  //
  //     EventDateTime start = new EventDateTime();
  //     start.dateTime = startTime;
  //     start.timeZone = "GMT+05:00";
  //     event.start = start;
  //
  //     EventDateTime end = new EventDateTime();
  //     end.timeZone = "GMT+05:00";
  //     end.dateTime = endTime;
  //     event.end = end;
  //     try {
  //       calendar.events.insert(event, calendarId).then((value) {
  //         print("ADDEDDD_________________${value.status}");
  //         if (value.status == "confirmed") {
  //           log('Event added in google calendar');
  //         } else {
  //           log("Unable to add event in google calendar");
  //         }
  //       });
  //     } catch (e) {
  //       log('Error creating event $e');
  //     }
  //   });
  // }
  //
  // void prompt(String url) async {
  //   print("Please go to the following URL and grant access:");
  //   print("  => $url");
  //   print("");
  //
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // final CalendarPlugin _myPlugin = CalendarPlugin();

  // List<Calendar>? cal=[];
  //
  // Future<List<Calendar>?> _fetchCalendars() async {

  // print("myplugin caledar ${_myPlugin.getCalendars()}");
  // return _myPlugin.getCalendars();
  // }

  // void addEvent(String startDateTime, String title, String description ) async {
  //   // cal=await _fetchCalendars();
  //  // print("calendar ${await _myPlugin.hasPermissions()}");
  //  //  print("calendar1 ${await requestPermission(Permission.calendar)}");
  //
  //   if (await requestPermission(Permission.calendar)){
  //     DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
  //     //print(format.parse(widget.apiDateOfListing));
  //     DateTime startDate = format.parse(startDateTime);
  //     print("start date $startDate");
  //     DateTime endDate = startDate.add(Duration(hours: 1));
  //     print("endDate  $endDate");
  //     CalendarEvent _newEvent = CalendarEvent(
  //       title: title,
  //       description: description,
  //       startDate: startDate,
  //       endDate: endDate,
  //       url: 'https://www.rahul.com',
  //       attendees: Attendees(
  //         attendees: [
  //           Attendee(emailAddress: 'test1@gmail.com', name: 'Test1'),
  //           Attendee(emailAddress: 'test2@gmail.com', name: 'Test2'),
  //         ],
  //       ),
  //     );
  //     _myPlugin
  //         .createEvent(calendarId: "1", event: _newEvent)
  //         .then((evenId) {
  //       // setState(() {
  //       debugPrint('Event Id is: $evenId');
  //       // });
  //     });
  //   }
  //   }


  Future<void> saveTheDate(
      String startDateTime, String title, String description) async {
    print("hii inside savethedate");
    if (await requestPermission(Permission.calendar)) {
      tz.initializeTimeZones();


      try {
        var deviceCalendarPlugin = DeviceCalendarPlugin();
        var calendars = await deviceCalendarPlugin.retrieveCalendars();
        print("calendarsss ${calendars.data}");
        print("calendarssslength ${calendars.data!.length}");
        var calendars1 = calendars.data;
        var defaultCalendar = calendars1!.firstWhere(
              (calendar) => calendar.isDefault == true,
          orElse: () => calendars1[0],
        );
        print("defaultCalendar $defaultCalendar");

        if (calendars.data!=null && calendars.data!.isNotEmpty) {
         // var defaultCalendar = calendars.data![0];
          DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
          //print(format.parse(widget.apiDateOfListing));
          DateTime start = format.parse(startDateTime);

          DateTime end = start.add(Duration(hours: 1));

          final detroit = getLocation("Asia/Kolkata");

          var startDate = TZDateTime.from(start,detroit!);
          var endDate =
          TZDateTime.from(end,detroit);

          Event event = Event(
            defaultCalendar.id,
            title: title,
            start: startDate,
            end: endDate,
            description: description,
            allDay: true,
            status: EventStatus.Tentative,
            availability: Availability.Tentative,
          );

          await DeviceCalendarPlugin().createOrUpdateEvent(event).then((value) {
            print("after event added ");
            print("after value ${value!.data} ");
          });
        } else {
          throw PlatformException(
            code: 'NoCalendars',
            message: 'No calendars found on the device.',
          );
        }
      } catch (e) {
        // Handle any exceptions that occur
        print('Error adding event to calendar: $e');
      }
    }
  }

//   _myPlugin.hasPermissions().then((value) {
//     if (!value!) {
//       _myPlugin.requestPermissions();
//     }else{
//       // print("ok google calendar ${cal!.first.id}");
//       // print("ok google calendar ${cal!.first.name}");
//       // for(int i=0; i<cal!.length; i++){
//       //   print("hello rahul ${cal![i].name}");
//       //   print("hello rahul ${cal![i].id}");
//       // }
//
//
//   });
//
//
// }
}
