/*import 'package:flutter/material.dart';
import 'package:friendfit_v2/theme/colors/light_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherTimeline extends StatelessWidget {
 // final CalendarController ctrlr = new CalendarController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          TableCalendar(
            locale: 'en_US',
           // calendarController: ctrlr,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.week,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: ListView(
                children: <Widget>[
                  /*TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.3,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 70,
                        height: 70,
                        indicator: _Sun(),
                      ),
                      beforeLineStyle: LineStyle(color: Colors.white.withOpacity(0.7)),
                      endChild: _ContainerHeader(),
                    ),*/
                  _buildTimelineTile(
                      indicator: _IconIndicator(
                        iconData: WeatherIcons.cloudy,
                        size: 20,
                      ),
                      hour: '07:30',
                      isFirst: true,
                      weather: 'Sabah',
                      phrase:
                          "Açık çay ve bitki çayı(şekersiz), 2 dilim peynir 1 tane haşlanmış yumurta, 5 tane zeytin, 1 dilim ekmek,1 tatlı kaşığı bal veya pekmez, domatsalatalık v.b.(Yağsız)"),
                  _buildTimelineTile(
                    indicator: _IconIndicator(
                      iconData: WeatherIcons.sunset,
                      size: 20,
                    ),
                    hour: '09:30',
                    weather: 'Ara',
                    phrase: '2 tane kayısı',
                  ),
                  _buildTimelineTile(
                    indicator: _IconIndicator(
                      iconData: WeatherIcons.sunset,
                      size: 20,
                    ),
                    hour: '11:00',
                    weather: 'Ara',
                    phrase: '1 kare bitter çikolata',
                  ),
                  _buildTimelineTile(
                    indicator: _IconIndicator(
                      iconData: WeatherIcons.night_alt_rain_mix,
                      size: 20,
                    ),
                    hour: '12:30',
                    weather: 'Öğle',
                    phrase:
                        'Çorba 1 dilim ekmek, 3tane ceviz +3 tane hurma,3 yemek kaşığı yoğurt, salata(yağsız)',
                  ),
                  _buildTimelineTile(
                    indicator: _IconIndicator(
                      iconData: WeatherIcons.sunset,
                      size: 20,
                    ),
                    hour: '15:30',
                    weather: 'Ara',
                    phrase: '2 tane kayısı + 5 tane fındık',
                  ),
                  _buildTimelineTile(
                    indicator: _IconIndicator(
                      iconData: WeatherIcons.sunset,
                      size: 20,
                    ),
                    hour: '17:00',
                    weather: 'Ara',
                    phrase: '1 su bardağı ayran',
                  ),
                  _buildTimelineTile(
                    indicator: _IconIndicator(
                      iconData: WeatherIcons.snowflake_cold,
                      size: 20,
                    ),
                    hour: '19:00',
                    weather: 'Akşam',
                    phrase:
                        "1 kepçeçorba, 3 köfte kadar et(90 gr.)veya 8 yemek kaşığı k.baklagil,salata(yağsız)",
                  ),
                  _buildTimelineTile(
                    indicator: _IconIndicator(
                      iconData: WeatherIcons.sunset,
                      size: 20,
                    ),
                    hour: '21:30',
                    weather: 'Ara',
                    phrase: '3 yemek kaşığı yoğurt',
                    isLast: true,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TimelineTile _buildTimelineTile(
      {_IconIndicator? indicator,
      String? hour,
      String? weather,
      //String temperature,
      String? phrase,
      bool isLast = false,
      bool isFirst = false}) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      beforeLineStyle: LineStyle(color: Colors.deepOrangeAccent),
      indicatorStyle: IndicatorStyle(
        indicatorXY: 0.3,
        drawGap: true,
        width: 30,
        height: 30,
        indicator: indicator,
      ),
      isLast: isLast,
      isFirst: isFirst,
      startChild: Center(
        child: Container(
          alignment: const Alignment(0.0, -0.50),
          child: Text(
            hour!,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Poppins",
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      endChild: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              weather!,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 4),
            Text(
              phrase!,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Poppins"),
            )
          ],
        ),
      ),
    );
  }
}

class _IconIndicator extends StatelessWidget {
  const _IconIndicator({
    Key? key,
    this.iconData,
    this.size,
  }) : super(key: key);

  final IconData? iconData;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                iconData,
                size: size,
                color: const Color(0xFF9E3773).withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContainerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'now - 17:30',
              style: GoogleFonts.lato(
                fontSize: 18,
                color: const Color(0xFFF4A5CD),
              ),
            ),
            Text(
              'Sunny',
              style: GoogleFonts.lato(
                fontSize: 30,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Humidity 40%',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF4A448F).withOpacity(0.8),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  '30°C',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: const Color(0xFF4A448F).withOpacity(0.8),
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Sun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 25,
            spreadRadius: 20,
          ),
        ],
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}
*/