import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerText extends StatefulWidget {
        
    DateTime expiration;
    
    TimerText({this.expiration,});
    
    @override
    _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
    
    Timer _timer;    // schedules frequent stopwatch checks
    Stopwatch _stopwatch;   // counts time elapsed
    
    Duration _initialTimeRemaining;     // final
    Duration _timeRemaining;
    Unit _lastUnit;
    
    @override
    void initState() {     
        
        _initialTimeRemaining = widget.expiration.difference(DateTime.now());
        _timeRemaining = _initialTimeRemaining;
        _lastUnit = UnitAmount.largestUnit(_timeRemaining).units;
        
        int startingRefreshRateMs = _refreshRate(_lastUnit);
            
        _stopwatch = new Stopwatch();
        _stopwatch.start();
        
        _timer = new Timer.periodic(
            new Duration(
                milliseconds: startingRefreshRateMs
            ),
            _checkStopwatch
        );
    }
    
    @override
    void dispose() {
        _stopwatch.stop();
        _timer.cancel();
        
        super.dispose();
    }
    
    @override
    Widget build(BuildContext context) {
        return Text(
            _formattedTimeRemaining(),
            style: Theme.of(context).textTheme.body1,
        );
    }
    
    void _checkStopwatch(Timer timer) {
        _timeRemaining = _initialTimeRemaining - _stopwatch.elapsed;
        
        Unit units = UnitAmount.largestUnit(_timeRemaining).units;
        
        // higher timer frequency for shorter remaining times
        if (units != _lastUnit) {
            int refreshRateMs = _refreshRate(units);
            _replaceTimer(refreshRateMs);
            _lastUnit = units;
        }
         
        setState(() {});
    }
    
    int _refreshRate(Unit units) {
        int refreshRateMs;
        
        // assuming months is the highest in Unit enum
        switch (units) {
            case Unit.months:
                refreshRateMs = 1000 * 60 * 60;
                break;
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
        return refreshRateMs;
    }
    
    void _replaceTimer(newRefreshRateMs) {
        
        _timer.cancel();
        _timer = new Timer.periodic(
            new Duration(milliseconds: newRefreshRateMs),
            _checkStopwatch
        );
    }
    
    String _formattedTimeRemaining() {
//        return _timeRemaining.inSeconds.toString();
//        return _initialTimeRemaining.inSeconds.toString();
        return UnitAmount.largestUnit(_timeRemaining).toString();
    }
}
    
enum Unit {seconds, minutes, hours, days, weeks, months}
    
class UnitAmount {
    
    final Unit units;
    final int amount;
    
    UnitAmount(this.units, this.amount);
    
    static UnitAmount largestUnit(Duration d) {
        int amount;
        Unit units;
        
        final int days = d.inDays;
        final int weeks = (days / 7).truncate();
        final int months = (days / 30).truncate();
        if (months > 0) {
            amount = months;
            units = Unit.months;
        } else if (weeks > 0) {
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