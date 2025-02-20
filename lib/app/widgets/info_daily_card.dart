import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rain/app/widgets/desc.dart';
import 'package:rain/app/widgets/message.dart';
import 'package:rain/app/widgets/status_weather.dart';
import 'package:rain/app/widgets/status_data.dart';
import 'package:rain/app/widgets/sunset_sunrise.dart';

class InfoDailyCard extends StatefulWidget {
  const InfoDailyCard({
    super.key,
    required this.timeDaily,
    required this.weathercodeDaily,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.sunrise,
    required this.sunset,
    required this.precipitationSum,
    required this.precipitationProbabilityMax,
    required this.windspeed10MMax,
    required this.windgusts10MMax,
    required this.uvIndexMax,
    required this.rainSum,
    required this.winddirection10MDominant,
    required this.index,
  });
  final List<DateTime> timeDaily;
  final List<int?>? weathercodeDaily;
  final List<double?>? temperature2MMax;
  final List<double?>? temperature2MMin;
  final List<double?>? apparentTemperatureMax;
  final List<double?>? apparentTemperatureMin;
  final List<String> sunrise;
  final List<String> sunset;
  final List<double?>? precipitationSum;
  final List<int?>? precipitationProbabilityMax;
  final List<double?>? windspeed10MMax;
  final List<double?>? windgusts10MMax;
  final List<double?>? uvIndexMax;
  final List<double?>? rainSum;
  final List<int?>? winddirection10MDominant;
  final int index;

  @override
  State<InfoDailyCard> createState() => _InfoDailyCardState();
}

class _InfoDailyCardState extends State<InfoDailyCard> {
  final locale = Get.locale;
  final statusWeather = StatusWeather();
  final statusData = StatusData();
  final message = Message();
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.index);
    pageIndex = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Iconsax.arrow_left_1,
            size: 20,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        title: Text(
          DateFormat.MMMMEEEEd(locale?.languageCode)
              .format(widget.timeDaily[pageIndex]),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          itemCount: widget.timeDaily.length,
          itemBuilder: (context, index) {
            return widget.weathercodeDaily?[index] == null
                ? null
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 15),
                            Image(
                              image: AssetImage(statusWeather.getImageNowDaily(
                                  widget.weathercodeDaily?[index],
                                  widget.timeDaily[index])),
                              fit: BoxFit.fill,
                              height: 200,
                            ),
                            const SizedBox(height: 10),
                            GlowText(
                              '${widget.temperature2MMin?[index]?.round()} / ${widget.temperature2MMax?[index]?.round()}',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                              ),
                              blurRadius: 4,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              statusWeather
                                  .getText(widget.weathercodeDaily?[index]),
                              style: context.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat.MMMMEEEEd(locale?.languageCode)
                                  .format(widget.timeDaily[index]),
                              style: context.textTheme.labelLarge?.copyWith(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SunsetSunrise(
                            timeSunrise: widget.sunrise[index],
                            timeSunset: widget.sunset[index],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              spacing: 5,
                              children: [
                                widget.apparentTemperatureMin?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/cold.png',
                                        value: statusData.getDegree(widget
                                            .apparentTemperatureMin?[index]
                                            ?.round()),
                                        desc: 'apparentTemperatureMin'.tr,
                                      ),
                                widget.apparentTemperatureMax?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/hot.png',
                                        value: statusData.getDegree(widget
                                            .apparentTemperatureMax?[index]
                                            ?.round()),
                                        desc: 'apparentTemperatureMax'.tr,
                                      ),
                                widget.uvIndexMax?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/uv.png',
                                        value:
                                            '${widget.uvIndexMax?[index]?.round()}',
                                        desc: 'uvIndex'.tr,
                                        message: message.getUvIndex(
                                            widget.uvIndexMax?[index]?.round()),
                                      ),
                                widget.winddirection10MDominant?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/windsock.png',
                                        value:
                                            '${widget.winddirection10MDominant?[index]}°',
                                        desc: 'direction'.tr,
                                        message: message.getDirection(widget
                                            .winddirection10MDominant?[index]),
                                      ),
                                widget.windspeed10MMax?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/wind.png',
                                        value: statusData.getSpeed(widget
                                            .windspeed10MMax?[index]
                                            ?.round()),
                                        desc: 'wind'.tr,
                                      ),
                                widget.windgusts10MMax?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName:
                                            'assets/images/windgusts.png',
                                        value: statusData.getSpeed(widget
                                            .windgusts10MMax?[index]
                                            ?.round()),
                                        desc: 'windgusts'.tr,
                                      ),
                                widget.precipitationProbabilityMax?[index] ==
                                        null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/humidity.png',
                                        value:
                                            '${widget.precipitationProbabilityMax?[index]}%',
                                        desc: 'precipitationProbabilit'.tr,
                                      ),
                                widget.rainSum?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/water.png',
                                        value: statusData.getPrecipitation(
                                            widget.rainSum?[index]),
                                        desc: 'rain'.tr,
                                      ),
                                widget.precipitationSum?[index] == null
                                    ? Container()
                                    : DescWeather(
                                        imageName: 'assets/images/rainfall.png',
                                        value: statusData.getPrecipitation(
                                            widget.precipitationSum?[index]),
                                        desc: 'precipitation'.tr,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
