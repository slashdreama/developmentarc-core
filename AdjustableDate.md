# Introduction #

The AdjustableDate Class is a utility class that provides a proxy wrapper around a Flash Date object and extends the Date Object by providing helper methods to manage the current Date instance.  The AdjustableDate provides the ability to determine if the current date is a leap year or enables you to move the date up 3 moths or back 21 days without having to calculate the exact date value properties.  The AdjustableDate provides many of the same getter/setter properties of the Flash Date object but does not expose the redundant `get{PropertyName}()` / `set{PropertyName}()` methods since the getter/setter properties already expose this functionality.

# The Basics #

When using Date objects there are often situations where the date reference needs to be adjusted forward or backwards by a set number of minutes, days, hours, etc.  An example of this would be having a start date value of January 29th, 2009 and you need to move it forward one month expecting the last day of February.  The challenge with this example is that you first need to know if this year is a leap year, because if it is not then attempting to set the month value to 1 would set the date to March 1st, 2009 instead of February 28th, 2009.  If it is a leap year then the value would be February 29th, 2009 (in this cause it would be March):

```
// create the date
var date:Date = new Date(2009, 0, 29);

// view the current value
trace(date); //output: Thu Jan 29 00:00:00 GMT-0800 2009

// move the date up one month
date.month = 1;

// the value is now March since Feb. 29th does not exist this year
trace(date); //output: Sun Mar 1 00:00:00 GMT-0800 2009
```

The AdjustableDate provides an offset method that understands the concepts of months and leap years and when moving forward one month tracks the date object to make sure it moves forward correctly:

```
// create an AdjustableDate
var adj:AdjustableDate = new AdjustableDate(2009, 0, 29);

// view the current date
trace(adj); //output: Thu Jan 29 00:00:00 GMT-0800 2009

// offset by one month forward
adj.offsetMonths(1);

// the value is Feb. 28th
trace(adj); //output: Feb 28 00:00:00 GMT-0800 2009
```

## Using AdjstableDate Offsets and Proxy Methods ##
The overall goal of the Adjustable date is to easily offset date objects both forward and backwards in time. At the same time, provide easy access to the Date methods we are used to working with. For example, we have a HTTP service that will return a list of employee vacation based on a start and end time.  We want to display the vacation dates from 6 months ago and to the next 30 days.  This service expects the query string to be in Unix epoch time (seconds instead of milliseconds. Flash's Date.time property is in milliseconds).  We also want the date to be set at the start of midnight, UTC:

```
// create the start date, using now and set to the top of the hour
var startDate:AdjustableDate = new AdjustableDate();
startDate.millisecondsUTC = 0;
startDate.secondsUTC = 0;
startDate.minutesUTC = 0;
startDate.hoursUTC = 0;

// clone the set time into the end date
var endDate:AdjustableDate = new AdjustableDate(startDate.time);

// offset the start and end dates
startDate.offsetMonths(-6);
trace(startDate); //Mon Jul 14 16:00:00 GMT-0800 2008

endDate.offsetDays(30);
trace(endDate); //Fri Feb 13 16:00:00 GMT-0800 2009

// build the querey string
var quereyString:String = "?start=" + startDate.sinceEpoch + "&end=" + endDate.sinceEpoch;
trace(quereyString); //output: ?start=1216076400&end=1234569600

// call the service, etc...
```

As you can see, we can set the UTC values directly, just like a Date object.  We can create a new AdjustableDate from the time of an existing AdjustableDate (or even a regular Date object).  We can then offset back in time by passing in a negative value and forward in time by passing in a positive value.  The AdjustableDate can also return time since epoch in Unix format (seconds in place of milliseconds).  Finally, notice that we can trace AdjustableDates and have the string format published just like a Date object.

# Considerations #

With any API/Data set there are always considerations that need to be made when using the technology.  Its always better to know about these potential issues before hand, rather then implementing the technology and then realizing it does not behave the way that was originally intended.

  * The AdjustableDate is a proxy around a Date object and does not extend the Date object due to the Date Object being a Final class.  This means that you can not cast the AdjustableDate as a Date nor use it in place of a Date object where a Date object is required.  If you need to pass in a Date Object the use the `dateInstance` property.