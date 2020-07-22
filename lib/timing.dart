import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerText extends StatefulWidget {
    
    static final int refreshRateMs = 500;
    
    DateTime expiration;
    
    TimerText({this.expiration,});
    
    @override
    _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
    
    Timer _timer;    // schedules frequent stopwatch checks
    Stopwatch _stopwatch = new Stopwatch();   // counts time elapsed
    
    Duration _initialTimeRemaining;     // final
    Duration _timeRemaining;
    Unit _lastUnit;
    
    static const TextStyle _textStyle = TextStyle(
        color: Colors.white,
        fontSize: 18.0,
    );
    
    @override
    void initState() {     
        
        _initialTimeRemaining = widget.expiration.difference(DateTime.now());
        _timeRemaining = _initialTimeRemaining;
            
        _stopwatch.start();
        
        _timer = new Timer.periodic(
            new Duration(
                milliseconds: TimerText.refreshRateMs
            ),
            _checkStopwatch
        );
    }
    
    @override
    Widget build(BuildContext context) {
        return Text(
            _formattedTimeRemaining(),
            style: _textStyle,
        );
    }
    
    void _checkStopwatch(Timer timer) {
        _timeRemaining = _initialTimeRemaining - _stopwatch.elapsed;
        
        // lower timer frequency for longer remaining times
//        _timer = new Timer.periodic(
//            new Duration(
//                milliseconds: TimerText.refreshRateMs
//            ),
//            _checkStopwatch
//        );
            
        setState(() {});
    }
    
    void _newTimerRefreshRate(Unit units) {
        int refreshRateMs;
        
        // assuming weeks is the highest in Unit enum
        switch (units) {
            case Unit.weeks:
                refreshRateMs = 1000 * 60 * 60;
                break;
            case Unit.days:
                refreshRateMs = 1000 * 60 * 30;
                break;
            case Unit.hours:
                refreshRateMs = 1000 * 60;
                break;
            case Unit.minutes:
                refreshRateMs = 500;
                break;
            default:
                refreshRateMs = 1000;
        }
//        _timer.cancel();
        _timer = new Timer.periodic(
            new Duration(milliseconds: refreshRateMs),
            _checkStopwatch
        );
    }
    
    String _formattedTimeRemaining() {
        return UnitAmount.largestUnit(_timeRemaining).toString();
    }
}
    
enum Unit {seconds, minutes, hours, days, weeks}
    
class UnitAmount {
    
    final Unit units;
    final int amount;
    
    UnitAmount(this.units, this.amount);
    
    static UnitAmount largestUnit(Duration d) {
        int amount;
        Unit units;
        
        final int days = d.inDays;
        final int weeks = (days / 7).truncate();
        if (weeks > 0) {
            amount = weeks;
            units = Unit.weeks;
        } else if(days > 0) {
            amount = days;
            units = Unit.days;
        } else {
            final int hours = d.inHours;
            if (hours > 0) {
                amount = hours;
                units = Unit.hours;
            } else {
                final int minutes = d.inMinutes;
                if (minutes > 0) {
                    amount = minutes;
                    units = Unit.minutes;
                } else {
                    final int seconds = d.inSeconds;
                    if (seconds > 0) {
                        amount = seconds;
                        units = Unit.seconds;
                    } else {
                        amount = 0;
                        units = null;
                    }
                }
            }
        }
        return UnitAmount(units, amount);
    }
    
    @override
    String toString() {
        // cover tiny units
        if (this.isZero()) {
            return '0';
        } else if(units == Unit.seconds) {
            return 'Less than 1 minute';
        }
        
        // format plural
        String s = amount.toString() +' '+ describeEnum(units);
        return amount == 1 ?
            s.substring(0, s.length - 1) :
            s;
    }
    
    bool isZero() {
        return amount == 0;
    }
}