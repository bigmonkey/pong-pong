/** TWO PLUGINS BELOW: mask.js and Zebra_Datepicker
*   
*   At the bottom is js that calls the functions when the document is opened
*
*   CW 01.03.13
*/


 /**
 * jquery.mask.js
 * @version: v0.7.2
 * @author: Igor Escobar
 *
 * Created by Igor Escobar on 2012-03-10. Please report any bug at http://blog.igorescobar.com
 *
 * Copyright (c) 2012 Igor Escobar http://blog.igorescobar.com
 *
 * The MIT License (http://www.opensource.org/licenses/mit-license.php)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

(function ($) {
    "use strict";
    var  e;
    var Mask = function (el, mask, options) {
        var plugin = this,
            $el = $(el),
            defaults = {
                byPassKeys: [8, 9, 37, 38, 39, 40],
                maskChars: {':': '(:)?', '-': '(-)?', '.': '(\\\.)?', '(': '(\\()?', ')': '(\\))?', '/': '(\/)?', ',': '(,)?', '_': '(_)?', ' ': '(\\s)?', '+': '(\\\+)?'},
                translationNumbers: {0: '(\\d)', 1: '(\\d)', 2: '(\\d)', 3: '(\\d)', 4: '(\\d)', 5: '(\\d)', 6: '(\\d)', 7: '(\\d)', 8: '(\\d)', 9: '(\\d)'},
                translation: {'A': '([a-zA-Z0-9])', 'S': '([a-zA-Z])'}
            };

        plugin.init = function() {
            plugin.settings = {};
            options = options || {};

            defaults.translation = $.extend({}, defaults.translation, defaults.translationNumbers)
            plugin.settings = $.extend(true, {}, defaults, options);
            plugin.settings.specialChars = $.extend({}, plugin.settings.maskChars, plugin.settings.translation);

            $el.each(function() {
                mask = __p.resolveDynamicMask(mask, $(this).val(), e, $(this), options);
                $el.attr('maxlength', mask.length);
                $el.attr('autocomplete', 'off');

                __p.destroyEvents();
                __p.setOnKeyUp();
                __p.setOnPaste();    
            });
        };

        var __p = {
            resolveDynamicMask: function(mask, oValue, e, currentField, options) {
                return typeof mask == "function" ? mask(oValue, e, currentField, options) : mask;
            },
            onlyNonMaskChars: function(string) {
                $.each(plugin.settings.maskChars, function(k,v){
                    string = string.replace(new RegExp(plugin.settings.maskChars[k], 'g'), '')
                });
                return string;
            },
            onPasteMethod: function() {
                setTimeout(function() {
                    $el.trigger('keyup');
                }, 100);
            },
            setOnPaste: function() {
                (__p.hasOnSupport()) ? $el.on("paste", __p.onPasteMethod) : $el.onpaste = __p.onPasteMethod;
            },
            setOnKeyUp: function() {
                $el.keyup(__p.maskBehaviour).trigger('keyup');
            },
            hasOnSupport: function() {
                return $.isFunction($.on);
            },
            destroyEvents: function() {
                $el.unbind('keyup').unbind('onpaste');
            },
            maskBehaviour: function(e) {
            e = e || window.event;
                var keyCode = e.keyCode || e.which;

                if ($.inArray(keyCode, plugin.settings.byPassKeys) > -1)  return true;

                var oCleanedValue = __p.onlyNonMaskChars($el.val()),
                    nowDigitIndex = $el.val().length-1,
                    nowDigitValue = $el.val()[nowDigitIndex],
                    pMask = (typeof options.reverse == "boolean" && options.reverse === true) ?
                            __p.getProportionalReverseMask(oCleanedValue, mask) :
                            __p.getProportionalMask(oCleanedValue, mask);

                if (nowDigitValue === mask[nowDigitIndex] && plugin.settings.maskChars[nowDigitValue]) {
                    $el.val(__p.cleanBullShit($el.val(), mask));
                    return true;
                } 

                var oNewValue = __p.applyMask(e, $el, pMask, options);

                if (oNewValue !== $el.val()){
                    $el.val(oNewValue).trigger('change');
                }
                  
                return __p.seekCallbacks(e, options, oNewValue, mask, $el);
            },
            applyMask: function (e, fieldObject, mask, options) {
                var oValue = __p.onlyNonMaskChars(fieldObject.val()).substring(0, __p.onlyNonMaskChars(mask).length);
                return __p.cleanBullShit(oValue.replace(new RegExp(__p.maskToRegex(mask)), function() {
                    for (var i = 1, oNewValue = ''; i < arguments.length - 2; i++) {
                        if (typeof arguments[i] == "undefined" || arguments[i] === "")
                            arguments[i] = mask.charAt(i-1);
                        oNewValue += arguments[i];
                    }

                  return oNewValue;
                }), mask);
            },
            getProportionalMask: function (oValue, mask) {
                var endMask = 0, m = 0;

                while (m <= oValue.length-1){
                    while(plugin.settings.maskChars[mask.charAt(endMask)])
                        endMask++;
                    endMask++;
                    m++;
                }

                return mask.substring(0, endMask);
            },
            getProportionalReverseMask: function (oValue, mask) {
                var startMask = 0, endMask = 0, m = 0, mLength = mask.length;
                startMask = (mLength >= 1) ? mLength : mLength-1;
                endMask = startMask;

                while (m <= oValue.length-1) {
                    while (plugin.settings.maskChars[mask.charAt(endMask-1)])
                        endMask--;
                    endMask--;
                    m++;
                }

                endMask = (mask.length >= 1) ? endMask : endMask-1;
                return mask.substring(startMask, endMask);
            },
            maskToRegex: function (mask) {
                for (var i = 0, regex = ''; i < mask.length; i ++){
                    if (plugin.settings.specialChars[mask.charAt(i)])
                        regex += plugin.settings.specialChars[mask.charAt(i)];
                    }
                return regex;
            },
            validDigit: function (nowMask, nowDigit) {
                if (new RegExp(plugin.settings.specialChars[nowMask].replace(/\?$/, '')).test(nowDigit) === false)
                    return false;
                return true;
            },
            cleanBullShit: function (oNewValue, mask, index) {
                index = index || 0;
                oNewValue = oNewValue.split('');
                for (var i = index, mLen = mask.length; i < mLen; i++) {
                    if (__p.validDigit(mask.charAt(i), oNewValue[i]) === false && typeof oNewValue[i] !== "undefined") {
                        oNewValue[i] = '';
                        return __p.cleanBullShit(oNewValue.join(''), mask, 0);
                    } 
                }
                return oNewValue.join('');
            },
            seekCallbacks: function (e, options, oNewValue, mask, currentField) {
                if (options.onKeyPress && e.isTrigger === undefined && typeof options.onKeyPress == "function")
                    options.onKeyPress(oNewValue, e, currentField, options);

                if (options.onComplete && e.isTrigger === undefined &&
                    oNewValue.length === mask.length && typeof options.onComplete == "function")
                        options.onComplete(oNewValue, e, currentField, options);
            }
        };

        // qunit private methods testing
        if (typeof QUNIT === "boolean") plugin.__p = __p;

        // public methods
        plugin.remove = function() {
          __p.destroyEvents();
          $el.val(__p.onlyNonMaskChars($el.val()));
        };

        plugin.init();
    };

    $.fn.mask = function(mask, options) {
        return this.each(function() {
            $(this).data('mask', new Mask(this, mask, options));
        });
    };

})(jQuery);




/**
 *  Zebra_DatePicker
 *
 *  Zebra_DatePicker is a small, compact and highly configurable date picker plugin for jQuery
 *
 *  Visit {@link http://stefangabos.ro/jquery/zebra-datepicker/} for more information.
 *
 *  For more resources visit {@link http://stefangabos.ro/}
 *
 *  @author     Stefan Gabos <contact@stefangabos.ro>
 *  @version    1.6.7 (last revision: January 28, 2013)
 *  @copyright  (c) 2011 - 2013 Stefan Gabos
 *  @license    http://www.gnu.org/licenses/lgpl-3.0.txt GNU LESSER GENERAL PUBLIC LICENSE
 *  @package    Zebra_DatePicker
 */
;(function($) {

    $.Zebra_DatePicker = function(element, options) {

        var defaults = {

            //  by default, the button for clearing a previously selected date is shown only if a previously selected date
            //  already exists; this means that if the input the date picker is attached to is empty, and the user selects
            //  a date for the first time, this button will not be visible; once the user picked a date and opens the date
            //  picker again, this time the button will be visible.
            //
            //  setting this property to TRUE will make this button visible all the time
            always_show_clear:  false,

            //  setting this property to a jQuery element, will result in the date picker being always visible, the indicated
            //  element being the date picker's container;
            //  note that when this property is set to TRUE, the "always_show_clear" property will automatically be set to TRUE
            always_visible:     false,

            //  days of the week; Sunday to Saturday
            days:               ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],

            //  by default, the abbreviated name of a day consists of the first 2 letters from the day's full name;
            //  while this is common for most languages, there are also exceptions for languages like Thai, Loa, Myanmar,
            //  etc. where this is not correct; for these cases, specify an array with the abbreviations to be used for
            //  the 7 days of the week; leave it FALSE to use the first 2 letters of a day's name as the abbreviation.
            //
            //  default is FALSE
            days_abbr:          false,

            //  direction of the calendar
            //
            //  a positive or negative integer: n (a positive integer) creates a future-only calendar beginning at n days
            //  after today; -n (a negative integer); if n is 0, the calendar has no restrictions. use boolean true for
            //  a future-only calendar starting with today and use boolean false for a past-only calendar ending today.
            //
            //  you may also set this property to an array with two elements in the following combinations:
            //
            //  -   first item is boolean TRUE (calendar starts today), an integer > 0 (calendar starts n days after
            //      today), or a valid date given in the format defined by the "format" attribute (calendar starts at the
            //      specified date), and the second item is boolean FALSE (the calendar has no ending date), an integer
            //      > 0 (calendar ends n days after the starting date), or a valid date given in the format defined by
            //      the "format" attribute and which occurs after the starting date (calendar ends at the specified date)
            //
            //  -   first item is boolean FALSE (calendar ends today), an integer < 0 (calendar ends n days before today),
            //      or a valid date given in the format defined by the "format" attribute (calendar ends at the specified
            //      date), and the second item is an integer > 0 (calendar ends n days before the ending date), or a valid
            //      date given in the format defined by the "format" attribute and which occurs before the starting date
            //      (calendar starts at the specified date)
            //
            //  [1, 7] - calendar starts tomorrow and ends seven days after that
            //  [true, 7] - calendar starts today and ends seven days after that
            //  ['2013-01-01', false] - calendar starts on January 1st 2013 and has no ending date ("format" is YYYY-MM-DD)
            //  [false, '2012-01-01'] - calendar ends today and starts on January 1st 2012 ("format" is YYYY-MM-DD)
            //
            //  note that "disabled_dates" property will still apply!
            //
            //  default is 0 (no restrictions)
            direction:          0,

            //  an array of disabled dates in the following format: 'day month year weekday' where "weekday" is optional
            //  and can be 0-6 (Saturday to Sunday); the syntax is similar to cron's syntax: the values are separated by
            //  spaces and may contain * (asterisk) - (dash) and , (comma) delimiters:
            //
            //  ['1 1 2012'] would disable January 1, 2012;
            //  ['* 1 2012'] would disable all days in January 2012;
            //  ['1-10 1 2012'] would disable January 1 through 10 in 2012;
            //  ['1,10 1 2012'] would disable January 1 and 10 in 2012;
            //  ['1-10,20,22,24 1-3 *'] would disable 1 through 10, plus the 22nd and 24th of January through March for every year;
            //  ['* * * 0,6'] would disable all Saturdays and Sundays;
            //  ['01 07 2012', '02 07 2012', '* 08 2012'] would disable 1st and 2nd of July 2012, and all of August of 2012
            //
            //  default is FALSE, no disabled dates
            disabled_dates:     false,

            //  week's starting day
            //
            //  valid values are 0 to 6, Sunday to Saturday
            //
            //  default is 1, Monday
            first_day_of_week:  1,

            //  format of the returned date
            //
            //  accepts the following characters for date formatting: d, D, j, l, N, w, S, F, m, M, n, Y, y borrowing
            //  syntax from (PHP's date function)
            //
            //  note that when setting a date format without days ('d', 'j'), the users will be able to select only years
            //  and months, and when setting a format without months and days ('F', 'm', 'M', 'n', 't', 'd', 'j'), the
            //  users will be able to select only years.
            //
            //  also note that the value of the "view" property (see below) may be overridden if it is the case: a value of
            //  "days" for the "view" property makes no sense if the date format doesn't allow the selection of days.
            //
            //  default is Y-m-d
            format:             'Y-m-d',

            //  should the icon for opening the datepicker be inside the element?
            //  if set to FALSE, the icon will be placed to the right of the parent element, while if set to TRUE it will
            //  be placed to the right of the parent element, but *inside* the element itself
            //
            //  default is TRUE
            inside:             true,

            //  the caption for the "Clear" button
            lang_clear_date:    'Clear',

            //  months names
            months:             ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],

            //  by default, the abbreviated name of a month consists of the first 3 letters from the month's full name;
            //  while this is common for most languages, there are also exceptions for languages like Thai, Loa, Myanmar,
            //  etc. where this is not correct; for these cases, specify an array with the abbreviations to be used for
            //  the months of the year; leave it FALSE to use the first 3 letters of a month's name as the abbreviation.
            //
            //  default is FALSE
            months_abbr:        false,

            //  the offset, in pixels (x, y), to shift the date picker's position relative to the top-right of the icon
            //  that toggles the date picker or, if the icon is disabled, relative to the top-right corner of the element
            //  the plugin is attached to.
            //
            //  note that this only applies if the position of element relative to the browser's viewport doesn't require
            //  the date picker to be placed automatically so that it is visible!
            //
            //  default is [20, -5]
            offset:             [5, -5],

            //  if set as a jQuery element with a Zebra_Datepicker attached, that particular date picker will use the
            //  current date picker's value as starting date
            //  note that the rules set in the "direction" property will still apply, only that the reference date will
            //  not be the current system date but the value selected in the current date picker
            //  default is FALSE (not paired with another date picker)
            pair:              false,

            //  should the element the calendar is attached to, be read-only?
            //  if set to TRUE, a date can be set only through the date picker and cannot be entered manually
            //
            //  default is TRUE
            readonly_element:   true,

            //  should a calendar icon be added to the elements the plugin is attached to?
            //
            //  default is TRUE
            show_icon:          true,

            //  should an extra column be shown, showing the number of each week?
            //  anything other than FALSE will enable this feature, and use the given value as column title
            //  i.e. show_week_number: 'Wk' would enable this feature and have "Wk" as the column's title
            //
            //  default is FALSE
            show_week_number:   false,

            //  a default date to start the date picker with
            //  must be specified in the format defined by the "format" property, or it will be ignored!
            //  note that this value is used only if there is no value in the field the date picker is attached to!
            start_date:         false,

            //  how should the date picker start; valid values are "days", "months" and "years"
            //  note that the date picker is always cycling days-months-years when clicking in the date picker's header,
            //  and years-months-days when selecting dates (unless one or more of the views are missing due to the date's
            //  format)
            //
            //  also note that the value of the "view" property may be overridden if the date's format requires so! (i.e.
            //  "days" for the "view" property makes no sense if the date format doesn't allow the selection of days)
            //
            //  default is "days"
            view:               'days',

            //  days of the week that are considered "weekend days"
            //  valid values are 0 to 6, Sunday to Saturday
            //
            //  default values are 0 and 6 (Saturday and Sunday)
            weekend_days:       [0, 6],

            //  when set to TRUE, day numbers < 10 will be prefixed with 0; set to FALSE if you don't want that
            //
            //  default is TRUE
            zero_pad:           true,

            //  callback function to be executed whenever the user changes the view (days/months/years), as well as when
            //  the user navigates by clicking on the "next"/"previous" icons in any of the views;
            //
            //  the callback function called by this event takes 3 arguments - the first argument represents the current
            //  view (can be "days", "months" or "years"), the second argument represents an array containing the "active"
            //  elements (not disabled) from the view, as jQuery elements, allowing for easy customization and interaction
            //  with particular cells in the date picker's view, while the third argument is a reference to the element
            //  the date picker is attached to, as a jQuery object
            //
            //  for simplifying searching for particular dates, each element in the second argument will also have a
            //  "date" data attribute whose format depends on the value of the "view" argument:
            //  - YYYY-MM-DD for elements in the "days" view
            //  - YYYY-MM for elements in the "months" view
            //  - YYYY for elements in the "years" view
            onChange:           null,

            //  callback function to be executed when the user clicks the "Clear" button
            //  the callback function takes a single argument:
            //  -   a reference to the element the date picker is attached to, as a jQuery object
            onClear:            null,

            //  callback function to be executed when a date is selected
            //  the callback function takes 4 arguments:
            //  -   the date in the format specified by the "format" attribute;
            //  -   the date in YYYY-MM-DD format
            //  -   the date as a JavaScript Date object
            //  -   a reference to the element the date picker is attached to, as a jQuery object
            onSelect:           null

        }

        // private properties
        var view, datepicker, icon, header, daypicker, monthpicker, yearpicker, footer, current_system_month, current_system_year,
            current_system_day, first_selectable_month, first_selectable_year, first_selectable_day, selected_month, selected_year,
            default_day, default_month, default_year, disabled_dates, shim, start_date, end_date, last_selectable_day,
            last_selectable_year, last_selectable_month, daypicker_cells, monthpicker_cells, yearpicker_cells, views, clickables;

        var plugin = this;

        plugin.settings = {}

        // the jQuery version of the element
        // "element" (without the $) will point to the DOM element
        var $element = $(element);

        /**
         *  Constructor method. Initializes the date picker.
         *
         *  @return void
         */
        var init = function(update) {

            // merge default settings with user-settings (unless we're just updating settings)
            if (!update) plugin.settings = $.extend({}, defaults, options);

            // if the element should be read-only, set the "readonly" attribute
            if (plugin.settings.readonly_element) $element.attr('readonly', 'readonly');

            // determine the views the user can cycle through, depending on the format
            // that is, if the format doesn't contain the day, the user will be able to cycle only through years and months,
            // whereas if the format doesn't contain months nor days, the user will only be able to select years

            var

                // the characters that may be present in the date format and that represent days, months and years
                date_chars = {
                    days:   ['d', 'j', 'D'],
                    months: ['F', 'm', 'M', 'n', 't'],
                    years:  ['o', 'Y', 'y']
                },

                // some defaults
                has_days = false,
                has_months = false,
                has_years = false;

            // iterate through all the character blocks
            for (type in date_chars)

                // iterate through the characters of each block
                $.each(date_chars[type], function(index, character) {

                    // if current character exists in the "format" property
                    if (plugin.settings.format.indexOf(character) > -1)

                        // set to TRUE the appropriate flag
                        if (type == 'days') has_days = true;
                        else if (type == 'months') has_months = true;
                        else if (type == 'years') has_years = true;

                });

            // if user can cycle through all the views, set the flag accordingly
            if (has_days && has_months && has_years) views = ['years', 'months', 'days'];

            // if user can cycle only through year and months, set the flag accordingly
            else if (!has_days && has_months && has_years) views = ['years', 'months'];

            // if user can only see the year picker, set the flag accordingly
            else if (!has_days && !has_months && has_years) views = ['years'];

            // if invalid format (no days, no months, no years) use the default where the user is able to cycle through
            // all the views
            else views = ['years', 'months', 'days'];

            // if the starting view is not amongst the views the user can cycle through, set the correct starting view
            if ($.inArray(plugin.settings.view, views) == -1) plugin.settings.view = views[views.length - 1];

            // parse the rules for disabling dates and turn them into arrays of arrays

            // array that will hold the rules for disabling dates
            disabled_dates = [];

            // if disabled dates is an array and is not empty
            if ($.isArray(plugin.settings.disabled_dates) && plugin.settings.disabled_dates.length > 0)

                // iterate through the rules for disabling dates
                $.each(plugin.settings.disabled_dates, function() {

                    // split the values in rule by white space
                    var rules = this.split(' ');

                    // there can be a maximum of 4 rules (days, months, years and, optionally, day of the week)
                    for (var i = 0; i < 4; i++) {

                        // if one of the values is not available
                        // replace it with a * (wildcard)
                        if (!rules[i]) rules[i] = '*';

                        // if rule contains a comma, create a new array by splitting the rule by commas
                        // if there are no commas create an array containing the rule's string
                        rules[i] = (rules[i].indexOf(',') > -1 ? rules[i].split(',') : new Array(rules[i]));

                        // iterate through the items in the rule
                        for (var j = 0; j < rules[i].length; j++)

                            // if item contains a dash (defining a range)
                            if (rules[i][j].indexOf('-') > -1) {

                                // get the lower and upper limits of the range
                                var limits = rules[i][j].match(/^([0-9]+)\-([0-9]+)/);

                                // if range is valid
                                if (null != limits) {

                                    // iterate through the range
                                    for (var k = to_int(limits[1]); k <= to_int(limits[2]); k++)

                                        // if value is not already among the values of the rule
                                        // add it to the rule
                                        if ($.inArray(k, rules[i]) == -1) rules[i].push(k + '');

                                    // remove the range indicator
                                    rules[i].splice(j, 1);

                                }

                            }

                        // iterate through the items in the rule
                        // and make sure that numbers are numbers
                        for (j = 0; j < rules[i].length; j++) rules[i][j] = (isNaN(to_int(rules[i][j])) ? rules[i][j] : to_int(rules[i][j]));

                    }

                    // add to the list of processed rules
                    disabled_dates.push(rules);

                });

            var

                // cache the current system date
                date = new Date(),

                // when the date picker's starting date depends on the value of another date picker, this value will be
                // set by the other date picker
                // this value will be used as base for all calculations (if not set, will be the same as the current
                // system date)
                reference_date = (!plugin.settings.reference_date ? ($element.data('zdp_reference_date') && undefined != $element.data('zdp_reference_date') ? $element.data('zdp_reference_date') : date) : plugin.settings.reference_date),

                tmp_start_date, tmp_end_date;

            // reset these values here as this method might be called more than once during a date picker's lifetime
            // (when the selectable dates depend on the values from another date picker)
            start_date = undefined; end_date = undefined;

            // extract the date parts
            // also, save the current system month/day/year - we'll use them to highlight the current system date
            first_selectable_month = reference_date.getMonth();
            current_system_month = date.getMonth();
            first_selectable_year = reference_date.getFullYear();
            current_system_year = date.getFullYear();
            first_selectable_day = reference_date.getDate();
            current_system_day = date.getDate();

            // check if the calendar has any restrictions

            // calendar is future-only, starting today
            // it means we have a starting date (the current system date), but no ending date
            if (plugin.settings.direction === true) start_date = reference_date;

            // calendar is past only, ending today
            else if (plugin.settings.direction === false) {

                // it means we have an ending date (the reference date), but no starting date
                end_date = reference_date;

                // extract the date parts
                last_selectable_month = end_date.getMonth();
                last_selectable_year = end_date.getFullYear();
                last_selectable_day = end_date.getDate();

            } else if (

                // if direction is not given as an array and the value is an integer > 0
                (!$.isArray(plugin.settings.direction) && is_integer(plugin.settings.direction) && to_int(plugin.settings.direction) > 0) ||

                // or direction is given as an array
                ($.isArray(plugin.settings.direction) && (

                    // and first entry is boolean TRUE
                    plugin.settings.direction[0] === true ||
                    // or an integer > 0
                    (is_integer(plugin.settings.direction[0]) && plugin.settings.direction[0] > 0) ||
                    // or a valid date
                    (tmp_start_date = check_date(plugin.settings.direction[0]))

                ) && (

                    // and second entry is boolean FALSE
                    plugin.settings.direction[1] === false ||
                    // or integer >= 0
                    (is_integer(plugin.settings.direction[1]) && plugin.settings.direction[1] >= 0) ||
                    // or a valid date
                    (tmp_end_date = check_date(plugin.settings.direction[1]))

                ))

            ) {

                // if an exact starting date was given, use that as a starting date
                if (tmp_start_date) start_date = tmp_start_date;

                // otherwise
                else

                    // figure out the starting date
                    // use the Date object to normalize the date
                    // for example, 2011 05 33 will be transformed to 2011 06 02
                    start_date = new Date(
                        first_selectable_year,
                        first_selectable_month,
                        first_selectable_day + (!$.isArray(plugin.settings.direction) ? to_int(plugin.settings.direction) : to_int(plugin.settings.direction[0] === true ? 0 : plugin.settings.direction[0]))
                    );

                // re-extract the date parts
                first_selectable_month = start_date.getMonth();
                first_selectable_year = start_date.getFullYear();
                first_selectable_day = start_date.getDate();

                // if an exact ending date was given and the date is after the starting date, use that as a ending date
                if (tmp_end_date && +tmp_end_date >= +start_date) end_date = tmp_end_date;

                // if have information about the ending date
                else if (!tmp_end_date && plugin.settings.direction[1] !== false && $.isArray(plugin.settings.direction))

                    // figure out the ending date
                    // use the Date object to normalize the date
                    // for example, 2011 05 33 will be transformed to 2011 06 02
                    end_date = new Date(
                        first_selectable_year,
                        first_selectable_month,
                        first_selectable_day + to_int(plugin.settings.direction[1])
                    );

                // if a valid ending date exists
                if (end_date) {

                    // extract the date parts
                    last_selectable_month = end_date.getMonth();
                    last_selectable_year = end_date.getFullYear();
                    last_selectable_day = end_date.getDate();

                }

            } else if (

                // if direction is not given as an array and the value is an integer < 0
                (!$.isArray(plugin.settings.direction) && is_integer(plugin.settings.direction) && to_int(plugin.settings.direction) < 0) ||

                // or direction is given as an array
                ($.isArray(plugin.settings.direction) && (

                    // and first entry is boolean FALSE
                    plugin.settings.direction[0] === false ||
                    // or an integer < 0
                    (is_integer(plugin.settings.direction[0]) && plugin.settings.direction[0] < 0)

                ) && (

                    // and second entry is integer >= 0
                    (is_integer(plugin.settings.direction[1]) && plugin.settings.direction[1] >= 0) ||
                    // or a valid date
                    (tmp_start_date = check_date(plugin.settings.direction[1]))

                ))

            ) {

                // figure out the ending date
                // use the Date object to normalize the date
                // for example, 2011 05 33 will be transformed to 2011 06 02
                end_date = new Date(
                    first_selectable_year,
                    first_selectable_month,
                    first_selectable_day + (!$.isArray(plugin.settings.direction) ? to_int(plugin.settings.direction) : to_int(plugin.settings.direction[0] === false ? 0 : plugin.settings.direction[0]))
                );

                // re-extract the date parts
                last_selectable_month = end_date.getMonth();
                last_selectable_year = end_date.getFullYear();
                last_selectable_day = end_date.getDate();

                // if an exact starting date was given, and the date is before the ending date, use that as a starting date
                if (tmp_start_date && +tmp_start_date < +end_date) start_date = tmp_start_date;

                // if have information about the starting date
                else if (!tmp_start_date && $.isArray(plugin.settings.direction))

                    // figure out the staring date
                    // use the Date object to normalize the date
                    // for example, 2011 05 33 will be transformed to 2011 06 02
                    start_date = new Date(
                        last_selectable_year,
                        last_selectable_month,
                        last_selectable_day - to_int(plugin.settings.direction[1])
                    );

                // if a valid starting date exists
                if (start_date) {

                    // extract the date parts
                    first_selectable_month = start_date.getMonth();
                    first_selectable_year = start_date.getFullYear();
                    first_selectable_day = start_date.getDate();

                }

            }

            // if first selectable date exists but is disabled, find the actual first selectable date
            if (is_disabled(first_selectable_year, first_selectable_month, first_selectable_day)) {

                // loop until we find the first selectable year
                while (is_disabled(first_selectable_year)) {

                    // if calendar is past-only, 
                    if (!start_date) {

                        // decrement the year
                        first_selectable_year--;

                        // because we've changed years, reset the month to December
                        first_selectable_month = 11;

                    // otherwise
                    } else {

                        // increment the year
                        first_selectable_year++;

                        // because we've changed years, reset the month to January
                        first_selectable_month = 0;

                    }

                }

                // loop until we find the first selectable month
                while (is_disabled(first_selectable_year, first_selectable_month)) {

                    // if calendar is past-only
                    if (!start_date) {

                        // decrement the month
                        first_selectable_month--;

                        // because we've changed months, reset the day to the last day of the month
                        first_selectable_day = 31;

                    // otherwise
                    } else {

                        // increment the month
                        first_selectable_month++;

                        // because we've changed months, reset the day to the first day of the month
                        first_selectable_day = 1;

                    }

                    // if we moved to a following year
                    if (first_selectable_month > 11) {

                        // increment the year
                        first_selectable_year++;

                        // reset the month to January
                        first_selectable_month = 0;

                        // because we've changed months, reset the day to the first day of the month
                        first_selectable_day = 1;

                    // if we moved to a previous year
                    } else if (first_selectable_month < 0) {

                        // decrement the year
                        first_selectable_year--;

                        // reset the month to December
                        first_selectable_month = 11;

                        // because we've changed months, reset the day to the last day of the month
                        first_selectable_day = 31;

                    }

                }

                // loop until we find the first selectable day
                while (is_disabled(first_selectable_year, first_selectable_month, first_selectable_day))

                    // if calendar is past-only, decrement the day
                    if (!start_date) first_selectable_day--;

                    // otherwise, increment the day
                    else first_selectable_day++;

                // use the Date object to normalize the date
                // for example, 2011 05 33 will be transformed to 2011 06 02
                date = new Date(first_selectable_year, first_selectable_month, first_selectable_day);

                // re-extract date parts from the normalized date
                // as we use them in the current loop
                first_selectable_year = date.getFullYear();
                first_selectable_month = date.getMonth();
                first_selectable_day = date.getDate();

            }

            // get the default date, from the element, and check if it represents a valid date, according to the required format
            var default_date = check_date($element.val() || (plugin.settings.start_date ? plugin.settings.start_date : ''));

            // if there is a default date but it is disabled
            if (default_date && is_disabled(default_date.getFullYear(), default_date.getMonth(), default_date.getDate()))

                // clear the value of the parent element
                $element.val('');

            // updates value for the date picker whose starting date depends on the selected date (if any)
            update_dependent(default_date);

            // if date picker is not always visible
            if (!plugin.settings.always_visible) {

                // if we're just creating the date picker
                if (!update) {

                    // if a calendar icon should be added to the element the plugin is attached to, create the icon now
                    if (plugin.settings.show_icon) {

                        // create the calendar icon (show a disabled icon if the element is disabled)
                        var html = '<button type="button" class="Zebra_DatePicker_Icon' + ($element.attr('disabled') == 'disabled' ? ' Zebra_DatePicker_Icon_Disabled' : '') + '">Pick a date</button>';

                        // convert to a jQuery object
                        icon = $(html);

                        // a reference to the icon, as a global property
                        plugin.icon = icon;

                        // the date picker will open when clicking both the icon and the element the plugin is attached to
                        clickables = icon.add($element);

                    // if calendar icon is not visible, the date picker will open when clicking the element
                    } else clickables = $element;

                    // attach the click event to the clickable elements (icon and/or element)
                    clickables.bind('click', function(e) {

                        e.preventDefault();

                        // if element is not disabled
                        if (!$element.attr('disabled'))

                            // if the date picker is visible, hide it
                            if (datepicker.css('display') != 'none') plugin.hide();

                            // if the date picker is not visible, show it
                            else plugin.show();

                    });

                    // if icon exists, inject it into the DOM
                    if (undefined != icon) icon.insertAfter(element);

                }

                // if calendar icon exists
                if (undefined != icon) {

                    // if calendar icon is to be placed *inside* the element
                    // add an extra class to the icon
                    if (plugin.settings.inside) icon.addClass('Zebra_DatePicker_Icon_Inside');

                    var

                        // get element's position relative to the offset parent
                        element_position = $element.position(),

                        // get element's width and height
                        element_height = $element.outerHeight(false),
                        element_margin_top = parseInt($element.css('marginTop'), 10) || 0,
                        element_width = $element.outerWidth(false),
                        element_margin_left = parseInt($element.css('marginLeft'), 10) || 0,

                        // get icon's width and height
                        icon_width = icon.outerWidth(true),
                        icon_height = icon.outerHeight(true);

                    // if icon is to be placed *inside* the element
                    if (plugin.settings.inside)

                        // position the icon accordingly
                        icon.css({
                            'left': element_position.left + element_margin_left + element_width - icon_width,
                            'top': element_position.top + element_margin_top + ((element_height - icon_height) / 2)
                        });

                    // if icon is to be placed to the right of the element
                    else

                        // position the icon accordingly
                        icon.css({
                            'left': element_position.left + element_width,
                            'top': element_position.top + ((element_height - icon_height) / 2)
                        });

                }

            }

            // if calendar icon exists (there's no icon if the date picker is always visible or it is specifically hidden)
            if (undefined != icon)

                // if parent element is not visible (has display: none, width and height are explicitly set to 0, an ancestor
                // element is hidden, so the element is not shown on the page), hide the icon, or show it otherwise
                if (!($element.is(':visible'))) icon.css('display', 'none'); else icon.css('display', 'block');

            // if we just needed to recompute the things above, return now
            if (update) return;

            // generate the container that will hold everything
            var html = '' +
                '<div class="Zebra_DatePicker">' +
                    '<table class="dp_header">' +
                        '<tr>' +
                            '<td class="dp_previous">&laquo;</td>' +
                            '<td class="dp_caption">&nbsp;</td>' +
                            '<td class="dp_next">&raquo;</td>' +
                        '</tr>' +
                    '</table>' +
                    '<table class="dp_daypicker"></table>' +
                    '<table class="dp_monthpicker"></table>' +
                    '<table class="dp_yearpicker"></table>' +
                    '<table class="dp_footer">' +
                        '<tr><td>' + plugin.settings.lang_clear_date + '</td></tr>' +
                    '</table>' +
                '</div>';

            // create a jQuery object out of the HTML above and create a reference to it
            datepicker = $(html);

            // a reference to the calendar, as a global property
            plugin.datepicker = datepicker;

            // create references to the different parts of the date picker
            header = $('table.dp_header', datepicker);
            daypicker = $('table.dp_daypicker', datepicker);
            monthpicker = $('table.dp_monthpicker', datepicker);
            yearpicker = $('table.dp_yearpicker', datepicker);
            footer = $('table.dp_footer', datepicker);

            // if date picker is not always visible
            if (!plugin.settings.always_visible)

                // inject the container into the DOM
                $('body').append(datepicker);

            // otherwise, if element is not disabled
            else if (!$element.attr('disabled')) {

                // inject the date picker into the designated container element
                plugin.settings.always_visible.append(datepicker);

                // and make it visible right away
                plugin.show();

            }

            // add the mouseover/mousevents to all to the date picker's cells
            // except those that are not selectable
            datepicker.
                delegate('td:not(.dp_disabled, .dp_weekend_disabled, .dp_not_in_month, .dp_blocked, .dp_week_number)', 'mouseover', function() {
                    $(this).addClass('dp_hover');
                }).
                delegate('td:not(.dp_disabled, .dp_weekend_disabled, .dp_not_in_month, .dp_blocked, .dp_week_number)', 'mouseout', function() {
                    $(this).removeClass('dp_hover');
                });

            // prevent text highlighting for the text in the header
            // (for the case when user keeps clicking the "next" and "previous" buttons)
            disable_text_select($('td', header));

            // event for when clicking the "previous" button
            $('.dp_previous', header).bind('click', function() {

                // if button is not disabled
                if (!$(this).hasClass('dp_blocked')) {

                    // if view is "months"
                    // decrement year by one
                    if (view == 'months') selected_year--;

                    // if view is "years"
                    // decrement years by 12
                    else if (view == 'years') selected_year -= 12;

                    // if view is "days"
                    // decrement the month and
                    // if month is out of range
                    else if (--selected_month < 0) {

                        // go to the last month of the previous year
                        selected_month = 11;
                        selected_year--;

                    }

                    // generate the appropriate view
                    manage_views();

                }

            });

            // attach a click event to the caption in header
            $('.dp_caption', header).bind('click', function() {

                // if current view is "days", take the user to the next view, depending on the format
                if (view == 'days') view = ($.inArray('months', views) > -1 ? 'months' : ($.inArray('years', views) > -1 ? 'years' : 'days'));

                // if current view is "months", take the user to the next view, depending on the format
                else if (view == 'months') view = ($.inArray('years', views) > -1 ? 'years' : ($.inArray('days', views) > -1 ? 'days' : 'months'));

                // if current view is "years", take the user to the next view, depending on the format
                else view = ($.inArray('days', views) > -1 ? 'days' : ($.inArray('months', views) > -1 ? 'months' : 'years'));

                // generate the appropriate view
                manage_views();

            });

            // event for when clicking the "next" button
            $('.dp_next', header).bind('click', function() {

                // if button is not disabled
                if (!$(this).hasClass('dp_blocked')) {

                    // if view is "months"
                    // increment year by 1
                    if (view == 'months') selected_year++;

                    // if view is "years"
                    // increment years by 12
                    else if (view == 'years') selected_year += 12;

                    // if view is "days"
                    // increment the month and
                    // if month is out of range
                    else if (++selected_month == 12) {

                        // go to the first month of the next year
                        selected_month = 0;
                        selected_year++;

                    }

                    // generate the appropriate view
                    manage_views();

                }

            });

            // attach a click event for the cells in the day picker
            daypicker.delegate('td:not(.dp_disabled, .dp_weekend_disabled, .dp_not_in_month, .dp_week_number)', 'click', function() {

                // put selected date in the element the plugin is attached to, and hide the date picker
                select_date(selected_year, selected_month, to_int($(this).html()), 'days', $(this));

            });

            // attach a click event for the cells in the month picker
            monthpicker.delegate('td:not(.dp_disabled)', 'click', function() {

                // get the month we've clicked on
                var matches = $(this).attr('class').match(/dp\_month\_([0-9]+)/);

                // set the selected month
                selected_month = to_int(matches[1]);

                // if user can select only years and months
                if ($.inArray('days', views) == -1)

                    // put selected date in the element the plugin is attached to, and hide the date picker
                    select_date(selected_year, selected_month, 1, 'months', $(this));

                else {

                    // direct the user to the "days" view
                    view = 'days';

                    // if date picker is always visible
                    // empty the value in the text box the date picker is attached to
                    if (plugin.settings.always_visible) $element.val('');

                    // generate the appropriate view
                    manage_views();

                }

            });

            // attach a click event for the cells in the year picker
            yearpicker.delegate('td:not(.dp_disabled)', 'click', function() {

                // set the selected year
                selected_year = to_int($(this).html());

                // if user can select only years
                if ($.inArray('months', views) == -1)

                    // put selected date in the element the plugin is attached to, and hide the date picker
                    select_date(selected_year, 1, 1, 'years', $(this));

                else {

                    // direct the user to the "months" view
                    view = 'months';

                    // if date picker is always visible
                    // empty the value in the text box the date picker is attached to
                    if (plugin.settings.always_visible) $element.val('');

                    // generate the appropriate view
                    manage_views();

                }

            });

            // bind a function to the onClick event on the table cell in the footer (the "Clear" button)
            $('td', footer).bind('click', function(e) {

                e.preventDefault();

                // clear the element's value
                $element.val('');

                // if date picker is not always visible
                if (!plugin.settings.always_visible) {

                    // reset these values
                    default_day = null; default_month = null; default_year = null; selected_month = null; selected_year = null;

                    // remove the footer element
                    footer.css('display', 'none');

                }

                // hide the date picker
                plugin.hide();

                // if a callback function exists for when clearing a date
                if (plugin.settings.onClear && typeof plugin.settings.onClear == 'function')

                    // execute the callback function and pass as argument the element the plugin is attached to
                    plugin.settings.onClear($element);

            });

            // if date picker is not always visible
            if (!plugin.settings.always_visible)

                // bind some events to the document
                $(document).bind({

                    //whenever anything is clicked on the page or a key is pressed
                    'mousedown': plugin._mousedown,
                    'keyup': plugin._keyup

                });

            // last thing is to pre-render some of the date picker right away
            manage_views();

        }

        /**
         *  Hides the date picker.
         *
         *  @return void
         */
        plugin.hide = function() {

            // if date picker is not always visible
            if (!plugin.settings.always_visible) {

                // hide the iFrameShim in Internet Explorer 6
                iframeShim('hide');

                // hide the date picker
                datepicker.css('display', 'none');

            }

        }

        /**
         *  Shows the date picker.
         *
         *  @return void
         */
        plugin.show = function() {

            // always show the view defined in settings
            view = plugin.settings.view;

            // get the default date, from the element, and check if it represents a valid date, according to the required format
            var default_date = check_date($element.val() || (plugin.settings.start_date ? plugin.settings.start_date : ''));

            // if the value represents a valid date
            if (default_date) {

                // extract the date parts
                // we'll use these to highlight the default date in the date picker and as starting point to
                // what year and month to start the date picker with
                // why separate values? because selected_* will change as user navigates within the date picker
                default_month = default_date.getMonth();
                selected_month = default_date.getMonth();
                default_year = default_date.getFullYear();
                selected_year = default_date.getFullYear();
                default_day = default_date.getDate();

                // if the default date represents a disabled date
                if (is_disabled(default_year, default_month, default_day)) {

                    // clear the value of the parent element
                    $element.val('');

                    // the calendar will start with the first selectable year/month
                    selected_month = first_selectable_month;
                    selected_year = first_selectable_year;

                }

            // if a default value is not available, or value does not represent a valid date
            } else {

                // the calendar will start with the first selectable year/month
                selected_month = first_selectable_month;
                selected_year = first_selectable_year;

            }

            // generate the appropriate view
            manage_views();

            // if date picker is not always visible and the calendar icon is visible
            if (!plugin.settings.always_visible) {

                var

                    // get the date picker width and height
                    datepicker_width = datepicker.outerWidth(),
                    datepicker_height = datepicker.outerHeight(),

                    // compute the date picker's default left and top
                    // this will be computed relative to the icon's top-right corner (if the calendar icon exists), or
                    // relative to the element's top-right corner otherwise, to which the offsets given at initialization
                    // are added/subtracted
                    left = (undefined != icon ? icon.offset().left + icon.outerWidth(true) : $element.offset().left + $element.outerWidth(true)) + plugin.settings.offset[0],
                    top = (undefined != icon ? icon.offset().top : $element.offset().top) - datepicker_height + plugin.settings.offset[1],

                    // get browser window's width and height
                    window_width = $(window).width(),
                    window_height = $(window).height(),

                    // get browser window's horizontal and vertical scroll offsets
                    window_scroll_top = $(window).scrollTop(),
                    window_scroll_left = $(window).scrollLeft();

                // if date picker is outside the viewport, adjust its position so that it is visible
                if (left + datepicker_width > window_scroll_left + window_width) left = window_scroll_left + window_width - datepicker_width;
                if (left < window_scroll_left) left = window_scroll_left;
                if (top + datepicker_height > window_scroll_top + window_height) top = window_scroll_top + window_height - datepicker_height;
                if (top < window_scroll_top) top = window_scroll_top;

                // make the date picker visible
                datepicker.css({
                    'left':     left,
                    'top':      top
                });

                // fade-in the date picker
                // for Internet Explorer < 9 show the date picker instantly or fading alters the font's weight
                datepicker.fadeIn(browser.name == 'explorer' && browser.version < 9 ? 0 : 150, 'linear');

                // show the iFrameShim in Internet Explorer 6
                iframeShim();

            // if date picker is always visible, show it
            } else datepicker.css('display', 'block');

        }

        /**
         *  Updates the configuration options given as argument
         *
         *  @param  object  values  An object containing any number of configuration options to be updated
         *
         *  @return void
         */
        plugin.update = function(values) {

            // if original direction not saved, save it now
            if (plugin.original_direction) plugin.original_direction = plugin.direction;

            // update configuration options
            plugin.settings = $.extend(plugin.settings, values);

            // reinitialize the object with the new options
            init(true);

        }

        /**
         *  Checks if a string represents a valid date according to the format defined by the "format" property.
         *
         *  @param  string  str_date    A string representing a date, formatted accordingly to the "format" property.
         *                              For example, if "format" is "Y-m-d" the string should look like "2011-06-01"
         *
         *  @return mixed               Returns a JavaScript Date object if string represents a valid date according
         *                              formatted according to the "format" property, or FALSE otherwise.
         *
         *  @access private
         */
        var check_date = function(str_date) {

            // treat argument as a string
            str_date += '';

            // if value is given
            if ($.trim(str_date) != '') {

                var

                    // prepare the format by removing white space from it
                    // and also escape characters that could have special meaning in a regular expression
                    format = escape_regexp(plugin.settings.format.replace(/\s/g, '')),

                    // allowed characters in date's format
                    format_chars = ['d','D','j','l','N','S','w','F','m','M','n','Y','y'],

                    // "matches" will contain the characters defining the date's format
                    matches = new Array,

                    // "regexp" will contain the regular expression built for each of the characters used in the date's format
                    regexp = new Array;

                // iterate through the allowed characters in date's format
                for (var i = 0; i < format_chars.length; i++)

                    // if character is found in the date's format
                    if ((position = format.indexOf(format_chars[i])) > -1)

                        // save it, alongside the character's position
                        matches.push({character: format_chars[i], position: position});

                // sort characters defining the date's format based on their position, ascending
                matches.sort(function(a, b){ return a.position - b.position });

                // iterate through the characters defining the date's format
                $.each(matches, function(index, match) {

                    // add to the array of regular expressions, based on the character
                    switch (match.character) {

                        case 'd': regexp.push('0[1-9]|[12][0-9]|3[01]'); break;
                        case 'D': regexp.push('[a-z]{3}'); break;
                        case 'j': regexp.push('[1-9]|[12][0-9]|3[01]'); break;
                        case 'l': regexp.push('[a-z]+'); break;
                        case 'N': regexp.push('[1-7]'); break;
                        case 'S': regexp.push('st|nd|rd|th'); break;
                        case 'w': regexp.push('[0-6]'); break;
                        case 'F': regexp.push('[a-z]+'); break;
                        case 'm': regexp.push('0[1-9]|1[012]+'); break;
                        case 'M': regexp.push('[a-z]{3}'); break;
                        case 'n': regexp.push('[1-9]|1[012]'); break;
                        case 'Y': regexp.push('[0-9]{4}'); break;
                        case 'y': regexp.push('[0-9]{2}'); break;

                    }

                });

                // if we have an array of regular expressions
                if (regexp.length) {

                    // we will replace characters in the date's format in reversed order
                    matches.reverse();

                    // iterate through the characters in date's format
                    $.each(matches, function(index, match) {

                        // replace each character with the appropriate regular expression
                        format = format.replace(match.character, '(' + regexp[regexp.length - index - 1] + ')');

                    });

                    // the final regular expression
                    regexp = new RegExp('^' + format + '$', 'ig');

                    // if regular expression was matched
                    if ((segments = regexp.exec(str_date.replace(/\s/g, '')))) {

                        // check if date is a valid date (i.e. there's no February 31)

                        var original_day,
                            original_month,
                            original_year,
                            english_days   = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
                            english_months = ['January','February','March','April','May','June','July','August','September','October','November','December'],
                            iterable,

                            // by default, we assume the date is valid
                            valid = true;

                        // reverse back the characters in the date's format
                        matches.reverse();

                        // iterate through the characters in the date's format
                        $.each(matches, function(index, match) {

                            // if the date is not valid, don't look further
                            if (!valid) return true;

                            // based on the character
                            switch (match.character) {

                                case 'm':
                                case 'n':

                                    // extract the month from the value entered by the user
                                    original_month = to_int(segments[index + 1]);

                                    break;

                                case 'd':
                                case 'j':

                                    // extract the day from the value entered by the user
                                    original_day = to_int(segments[index + 1]);

                                    break;

                                case 'D':
                                case 'l':
                                case 'F':
                                case 'M':

                                    // if day is given as day name, we'll check against the names in the used language
                                    if (match.character == 'D' || match.character == 'l') iterable = plugin.settings.days;

                                    // if month is given as month name, we'll check against the names in the used language
                                    else iterable = plugin.settings.months;

                                    // by default, we assume the day or month was not entered correctly
                                    valid = false;

                                    // iterate through the month/days in the used language
                                    $.each(iterable, function(key, value) {

                                        // if month/day was entered correctly, don't look further
                                        if (valid) return true;

                                        // if month/day was entered correctly
                                        if (segments[index + 1].toLowerCase() == value.substring(0, (match.character == 'D' || match.character == 'M' ? 3 : value.length)).toLowerCase()) {

                                            // extract the day/month from the value entered by the user
                                            switch (match.character) {

                                                case 'D': segments[index + 1] = english_days[key].substring(0, 3); break;
                                                case 'l': segments[index + 1] = english_days[key]; break;
                                                case 'F': segments[index + 1] = english_months[key]; original_month = key + 1; break;
                                                case 'M': segments[index + 1] = english_months[key].substring(0, 3); original_month = key + 1; break;

                                            }

                                            // day/month value is valid
                                            valid = true;

                                        }

                                    });

                                    break;

                                case 'Y':

                                    // extract the year from the value entered by the user
                                    original_year = to_int(segments[index + 1]);

                                    break;

                                case 'y':

                                    // extract the year from the value entered by the user
                                    original_year = '19' + to_int(segments[index + 1]);

                                    break;

                            }
                        });

                        // if everything is ok so far
                        if (valid) {

                            // generate a Date object using the values entered by the user
                            // (handle also the case when original_month and/or original_day are undefined - i.e date format is "Y-m" or "Y")
                            var date = new Date(original_year, (original_month || 1) - 1, original_day || 1);

                            // if, after that, the date is the same as the date entered by the user
                            if (date.getFullYear() == original_year && date.getDate() == (original_day || 1) && date.getMonth() == ((original_month || 1) - 1))

                                // return the date as JavaScript date object
                                return date;

                        }

                    }

                }

                // if script gets this far, return false as something must've went wrong
                return false;

            }

        }

        /**
         *  Prevents the possibility of selecting text on a given element. Used on the "previous" and "next" buttons
         *  where text might get accidentally selected when user quickly clicks on the buttons.
         *
         *  Code by http://chris-barr.com/index.php/entry/disable_text_selection_with_jquery/
         *
         *  @param  jQuery Element  el  A jQuery element on which to prevents text selection.
         *
         *  @return void
         *
         *  @access private
         */
        var disable_text_select = function(el) {

            // if browser is Firefox
      if (browser.name == 'firefox') el.css('MozUserSelect', 'none');

            // if browser is Internet Explorer
            else if (browser.name == 'explorer') el.bind('selectstart', function() { return false });

            // for the other browsers
      else el.mousedown(function() { return false });

        }

        /**
         *  Escapes special characters in a string, preparing it for use in a regular expression.
         *
         *  @param  string  str     The string in which special characters should be escaped.
         *
         *  @return string          Returns the string with escaped special characters.
         *
         *  @access private
         */
        var escape_regexp = function(str) {

            // return string with special characters escaped
            return str.replace(/([-.*+?^${}()|[\]\/\\])/g, '\\$1');

        }

        /**
         *  Formats a JavaScript date object to the format specified by the "format" property.
         *  Code taken from http://electricprism.com/aeron/calendar/
         *
         *  @param  date    date    A valid JavaScript date object
         *
         *  @return string          Returns a string containing the formatted date
         *
         *  @access private
         */
        var format = function(date) {

            var result = '',

                // extract parts of the date:
                // day number, 1 - 31
                j = date.getDate(),

                // day of the week, 0 - 6, Sunday - Saturday
                w = date.getDay(),

                // the name of the day of the week Sunday - Saturday
                l = plugin.settings.days[w],

                // the month number, 1 - 12
                n = date.getMonth() + 1,

                // the month name, January - December
                f = plugin.settings.months[n - 1],

                // the year (as a string)
                y = date.getFullYear() + '';

            // iterate through the characters in the format
            for (var i = 0; i < plugin.settings.format.length; i++) {

                // extract the current character
                var chr = plugin.settings.format.charAt(i);

                // see what character it is
                switch(chr) {

                    // year as two digits
                    case 'y': y = y.substr(2);

                    // year as four digits
                    case 'Y': result += y; break;

                    // month number, prefixed with 0
                    case 'm': n = str_pad(n, 2);

                    // month number, not prefixed with 0
                    case 'n': result += n; break;

                    // month name, three letters
                    case 'M': f = ($.isArray(plugin.settings.months_abbr) && undefined != plugin.settings.months_abbr[n - 1] ? plugin.settings.months_abbr[n - 1] : plugin.settings.months[n - 1].substr(0, 3));

                    // full month name
                    case 'F': result += f; break;

                    // day number, prefixed with 0
                    case 'd': j = str_pad(j, 2);

                    // day number not prefixed with 0
                    case 'j': result += j; break;

                    // day name, three letters
                    case 'D': l = ($.isArray(plugin.settings.days_abbr) && undefined != plugin.settings.days_abbr[w] ? plugin.settings.days_abbr[w] : plugin.settings.days[w].substr(0, 3));

                    // full day name
                    case 'l': result += l; break;

                    // ISO-8601 numeric representation of the day of the week, 1 - 7
                    case 'N': w++;

                    // day of the week, 0 - 6
                    case 'w': result += w; break;

                    // English ordinal suffix for the day of the month, 2 characters
                    // (st, nd, rd or th (works well with j))
                    case 'S':

                        if (j % 10 == 1 && j != '11') result += 'st';

                        else if (j % 10 == 2 && j != '12') result += 'nd';

                        else if (j % 10 == 3 && j != '13') result += 'rd';

                        else result += 'th';

                        break;

                    // this is probably the separator
                    default: result += chr;

                }

            }

            // return formated date
            return result;

        }

        /**
         *  Generates the day picker view, and displays it
         *
         *  @return void
         *
         *  @access private
         */
        var generate_daypicker = function() {

            var

                // get the number of days in the selected month
                days_in_month = new Date(selected_year, selected_month + 1, 0).getDate(),

                // get the selected month's starting day (from 0 to 6)
                first_day = new Date(selected_year, selected_month, 1).getDay(),

                // how many days are there in the previous month
                days_in_previous_month = new Date(selected_year, selected_month, 0).getDate(),

                // how many days are there to be shown from the previous month
                days_from_previous_month = first_day - plugin.settings.first_day_of_week;

            // the final value of how many days are there to be shown from the previous month
            days_from_previous_month = days_from_previous_month < 0 ? 7 + days_from_previous_month : days_from_previous_month;

            // manage header caption and enable/disable navigation buttons if necessary
            manage_header(plugin.settings.months[selected_month] + ', ' + selected_year);

            // start generating the HTML
            var html = '<tr>';

            // if a column featuring the number of the week is to be shown
            if (plugin.settings.show_week_number)

                // column title
                html += '<th>' + plugin.settings.show_week_number + '</th>';

            // name of week days
            // show only the first two letters
            // and also, take in account the value of the "first_day_of_week" property
            for (var i = 0; i < 7; i++)

                html += '<th>' + ($.isArray(plugin.settings.days_abbr) && undefined != plugin.settings.days_abbr[(plugin.settings.first_day_of_week + i) % 7] ? plugin.settings.days_abbr[(plugin.settings.first_day_of_week + i) % 7] : plugin.settings.days[(plugin.settings.first_day_of_week + i) % 7].substr(0, 2)) + '</th>';

            html += '</tr><tr>';

            // the calendar shows a total of 42 days
            for (var i = 0; i < 42; i++) {

                // seven days per row
                if (i > 0 && i % 7 == 0) html += '</tr><tr>';

                // if week number is to be shown
                if (i % 7 == 0 && plugin.settings.show_week_number)

                    // show ISO 8601 week number
                    html += '<td class="dp_week_number">' + getWeekNumber(new Date(selected_year, selected_month, (i - days_from_previous_month + 1))) + '</td>';

                // the number of the day in month
                var day = (i - days_from_previous_month + 1);

                // if this is a day from the previous month
                if (i < days_from_previous_month)

                    html += '<td class="dp_not_in_month">' + str_pad(days_in_previous_month - days_from_previous_month + i + 1, plugin.settings.zero_pad ? 2 : 0) + '</td>';

                // if this is a day from the next month
                else if (day > days_in_month)

                    html += '<td class="dp_not_in_month">' + str_pad(day - days_in_month, plugin.settings.zero_pad ? 2 : 0) + '</td>';

                // if this is a day from the current month
                else {

                    var

                        // get the week day (0 to 6, Sunday to Saturday)
                        weekday = (plugin.settings.first_day_of_week + i) % 7,

                        class_name = '';

                    // if date needs to be disabled
                    if (is_disabled(selected_year, selected_month, day)) {

                        // if day is in weekend
                        if ($.inArray(weekday, plugin.settings.weekend_days) > -1) class_name = 'dp_weekend_disabled';

                        // if work day
                        else class_name += ' dp_disabled';

                        // highlight the current system date
                        if (selected_month == current_system_month && selected_year == current_system_year && current_system_day == day) class_name += ' dp_disabled_current';

                    // if there are no restrictions
                    } else {

                        // if day is in weekend
                        if ($.inArray(weekday, plugin.settings.weekend_days) > -1) class_name = 'dp_weekend';

                        // highlight the currently selected date
                        if (selected_month == default_month && selected_year == default_year && default_day == day) class_name += ' dp_selected';

                        // highlight the current system date
                        if (selected_month == current_system_month && selected_year == current_system_year && current_system_day == day) class_name += ' dp_current';

                    }

                    // print the day of the month
                    html += '<td' + (class_name != '' ? ' class="' + $.trim(class_name) + '"' : '') + '>' + (plugin.settings.zero_pad ? str_pad(day, 2) : day) + '</td>';

                }

            }

            // wrap up generating the day picker
            html += '</tr>';

            // inject the day picker into the DOM
            daypicker.html($(html));

            // if date picker is always visible
            if (plugin.settings.always_visible)

                // cache all the cells
                // (we need them so that we can easily remove the "dp_selected" class from all of them when user selects a date)
                daypicker_cells = $('td:not(.dp_disabled, .dp_weekend_disabled, .dp_not_in_month, .dp_blocked, .dp_week_number)', daypicker);

            // make the day picker visible
            daypicker.css('display', '');

        }

        /**
         *  Generates the month picker view, and displays it
         *
         *  @return void
         *
         *  @access private
         */
        var generate_monthpicker = function() {

            // manage header caption and enable/disable navigation buttons if necessary
            manage_header(selected_year);

            // start generating the HTML
            var html = '<tr>';

            // iterate through all the months
            for (var i = 0; i < 12; i++) {

                // three month per row
                if (i > 0 && i % 3 == 0) html += '</tr><tr>';

                var class_name = 'dp_month_' + i;

                // if month needs to be disabled
                if (is_disabled(selected_year, i)) class_name += ' dp_disabled';

                // else, if a date is already selected and this is that particular month, highlight it
                else if (default_month !== false && default_month == i) class_name += ' dp_selected';

                // else, if this the current system month, highlight it
                else if (current_system_month == i && current_system_year == selected_year) class_name += ' dp_current';

                // first three letters of the month's name
                html += '<td class="' + $.trim(class_name) + '">' + ($.isArray(plugin.settings.months_abbr) && undefined != plugin.settings.months_abbr[i] ? plugin.settings.months_abbr[i] : plugin.settings.months[i].substr(0, 3)) + '</td>';

            }

            // wrap up
            html += '</tr>';

            // inject into the DOM
            monthpicker.html($(html));

            // if date picker is always visible
            if (plugin.settings.always_visible)

                // cache all the cells
                // (we need them so that we can easily remove the "dp_selected" class from all of them when user selects a month)
                monthpicker_cells = $('td:not(.dp_disabled)', monthpicker);

            // make the month picker visible
            monthpicker.css('display', '');

        }

        /**
         *  Generates the year picker view, and displays it
         *
         *  @return void
         *
         *  @access private
         */
        var generate_yearpicker = function() {

            // manage header caption and enable/disable navigation buttons if necessary
            manage_header(selected_year - 7 + ' - ' + (selected_year + 4));

            // start generating the HTML
            var html = '<tr>';

            // we're showing 9 years at a time, current year in the middle
            for (var i = 0; i < 12; i++) {

                // three years per row
                if (i > 0 && i % 3 == 0) html += '</tr><tr>';

                var class_name = '';

                // if year needs to be disabled
                if (is_disabled(selected_year - 7 + i)) class_name += ' dp_disabled';

                // else, if a date is already selected and this is that particular year, highlight it
                else if (default_year && default_year == selected_year - 7 + i) class_name += ' dp_selected'

                // else, if this is the current system year, highlight it
                else if (current_system_year == (selected_year - 7 + i)) class_name += ' dp_current';

                // first three letters of the month's name
                html += '<td' + ($.trim(class_name) != '' ? ' class="' + $.trim(class_name) + '"' : '') + '>' + (selected_year - 7 + i) + '</td>';

            }

            // wrap up
            html += '</tr>';

            // inject into the DOM
            yearpicker.html($(html));

            // if date picker is always visible
            if (plugin.settings.always_visible)

                // cache all the cells
                // (we need them so that we can easily remove the "dp_selected" class from all of them when user selects a year)
                yearpicker_cells = $('td:not(.dp_disabled)', yearpicker);

            // make the year picker visible
            yearpicker.css('display', '');

        }

        /**
         *  Generates an iFrame shim in Internet Explorer 6 so that the date picker appears above select boxes.
         *
         *  @return void
         *
         *  @access private
         */
        var iframeShim = function(action) {

            // this is necessary only if browser is Internet Explorer 6
        if (browser.name == 'explorer' && browser.version == 6) {

                // if the iFrame was not yet created
                // "undefined" evaluates as FALSE
                if (!shim) {

                    // the iFrame has to have the element's zIndex minus 1
                    var zIndex = to_int(datepicker.css('zIndex')) - 1;

                    // create the iFrame
                    shim = jQuery('<iframe>', {
                        'src':                  'javascript:document.write("")',
                        'scrolling':            'no',
                        'frameborder':          0,
                        'allowtransparency':    'true',
                        css: {
                            'zIndex':       zIndex,
                            'position':     'absolute',
                            'top':          -1000,
                            'left':         -1000,
                            'width':        datepicker.outerWidth(),
                            'height':       datepicker.outerHeight(),
                            'filter':       'progid:DXImageTransform.Microsoft.Alpha(opacity=0)',
                            'display':      'none'
                        }
                    });

                    // inject iFrame into DOM
                    $('body').append(shim);

                }

                // what do we need to do
                switch (action) {

                    // hide the iFrame?
                    case 'hide':

                        // set the iFrame's display property to "none"
                        shim.css('display', 'none');

                        break;

                    // show the iFrame?
                    default:

                        // get date picker top and left position
                        var offset = datepicker.offset();

                        // position the iFrame shim right underneath the date picker
                        // and set its display to "block"
                        shim.css({
                            'top':      offset.top,
                            'left':     offset.left,
                            'display':  'block'
                        });

                }

            }

        }

        /**
         *  Checks if, according to the restrictions of the calendar and/or the values defined by the "disabled_dates"
         *  property, a day, a month or a year needs to be disabled.
         *
         *  @param  integer     year    The year to check
         *  @param  integer     month   The month to check
         *  @param  integer     day     The day to check
         *
         *  @return boolean         Returns TRUE if the given value is not disabled or FALSE otherwise
         *
         *  @access private
         */
        var is_disabled = function(year, month, day) {

            // if calendar has direction restrictions
            if (!(!$.isArray(plugin.settings.direction) && to_int(plugin.settings.direction) === 0)) {

                var
                    // normalize and merge arguments then transform the result to an integer
                    now = to_int(str_concat(year, (typeof month != 'undefined' ? str_pad(month, 2) : ''), (typeof day != 'undefined' ? str_pad(day, 2) : ''))),

                    // get the length of the argument
                    len = (now + '').length;

                // if we're checking days
                if (len == 8 && (

                    // day is before the first selectable date
                    (typeof start_date != 'undefined' && now < to_int(str_concat(first_selectable_year, str_pad(first_selectable_month, 2), str_pad(first_selectable_day, 2)))) ||

                    // or day is after the last selectable date
                    (typeof end_date != 'undefined' && now > to_int(str_concat(last_selectable_year, str_pad(last_selectable_month, 2), str_pad(last_selectable_day, 2))))

                // day needs to be disabled
                )) return true;

                // if we're checking months
                else if (len == 6 && (

                    // month is before the first selectable month
                    (typeof start_date != 'undefined' && now < to_int(str_concat(first_selectable_year, str_pad(first_selectable_month, 2)))) ||

                    // or day is after the last selectable date
                    (typeof end_date != 'undefined' && now > to_int(str_concat(last_selectable_year, str_pad(last_selectable_month, 2))))

                // month needs to be disabled
                )) return true;

                // if we're checking years
                else if (len == 4 && (

                    // year is before the first selectable year
                    (typeof start_date != 'undefined' && now < first_selectable_year) ||

                    // or day is after the last selectable date
                    (typeof end_date != 'undefined'  && now > last_selectable_year)

                // year needs to be disabled
                )) return true;

            }

            // if there are rules for disabling dates
            if (disabled_dates) {

                // if month is given as argument, increment it (as JavaScript uses 0 for January, 1 for February...)
                if (typeof month != 'undefined') month = month + 1

                // by default, we assume the day/month/year is not to be disabled
                var disabled = false;

                // iterate through the rules for disabling dates
                $.each(disabled_dates, function() {

                    // if the date is to be disabled, don't look any further
                    if (disabled) return;

                    var rule = this;

                    // if the rules apply for the current year
                    if ($.inArray(year, rule[2]) > -1 || $.inArray('*', rule[2]) > -1)

                        // if the rules apply for the current month
                        if ((typeof month != 'undefined' && $.inArray(month, rule[1]) > -1) || $.inArray('*', rule[1]) > -1)

                            // if the rules apply for the current day
                            if ((typeof day != 'undefined' && $.inArray(day, rule[0]) > -1) || $.inArray('*', rule[0]) > -1) {

                                // if day is to be disabled whatever the day
                                // don't look any further
                                if (rule[3] == '*') return (disabled = true);

                                // get the weekday
                                var weekday = new Date(year, month - 1, day).getDay();

                                // if weekday is to be disabled
                                // don't look any further
                                if ($.inArray(weekday, rule[3]) > -1) return (disabled = true);

                            }

                });

                // if the day/month/year needs to be disabled
                if (disabled) return true;

            }

            // if script gets this far it means that the day/month/year doesn't need to be disabled
            return false;

        }

        /**
         *  Checks whether a value is an integer number.
         *
         *  @param  mixed   value   Value to check
         *
         *  @return                 Returns TRUE if the value represents an integer number, or FALSE otherwise
         *
         *  @access private
         */
        var is_integer = function(value) {

            // return TRUE if value represents an integer number, or FALSE otherwise
            return (value + '').match(/^\-?[0-9]+$/) ? true : false;

        }

        /**
         *  Sets the caption in the header of the date picker and enables or disables navigation buttons when necessary.
         *
         *  @param  string  caption     String that needs to be displayed in the header
         *
         *  @return void
         *
         *  @access private
         */
        var manage_header = function(caption) {

            // update the caption in the header
            $('.dp_caption', header).html(caption);

            // if calendar has direction restrictions
            if (!(!$.isArray(plugin.settings.direction) && to_int(plugin.settings.direction) === 0)) {

                // get the current year and month
                var year = selected_year,
                    month = selected_month,
                    next, previous;

                // if current view is showing days
                if (view == 'days') {

                    // clicking on "previous" should take us to the previous month
                    // (will check later if that particular month is available)
                    previous = (month - 1 < 0 ? str_concat(year - 1, '11') : str_concat(year, str_pad(month - 1, 2)));

                    // clicking on "next" should take us to the next month
                    // (will check later if that particular month is available)
                    next = (month + 1 > 11 ? str_concat(year + 1, '00') : str_concat(year, str_pad(month + 1, 2)));

                // if current view is showing months
                } else if (view == 'months') {

                    // clicking on "previous" should take us to the previous year
                    // (will check later if that particular year is available)
                    previous = year - 1;

                    // clicking on "next" should take us to the next year
                    // (will check later if that particular year is available)
                    next = year + 1;

                // if current view is showing years
                } else if (view == 'years') {

                    // clicking on "previous" should show a list with some previous years
                    // (will check later if that particular list of years contains selectable years)
                    previous = year - 7;

                    // clicking on "next" should show a list with some following years
                    // (will check later if that particular list of years contains selectable years)
                    next = year + 7;

                }

                // if the previous month/year is not selectable or, in case of years, if the list doesn't contain selectable years
                if (is_disabled(previous)) {

                    // disable the "previous" button
                    $('.dp_previous', header).addClass('dp_blocked');
                    $('.dp_previous', header).removeClass('dp_hover');

                // otherwise enable the "previous" button
                } else $('.dp_previous', header).removeClass('dp_blocked');

                // if the next month/year is not selectable or, in case of years, if the list doesn't contain selectable years
                if (is_disabled(next)) {

                    // disable the "next" button
                    $('.dp_next', header).addClass('dp_blocked');
                    $('.dp_next', header).removeClass('dp_hover');

                // otherwise enable the "next" button
                } else $('.dp_next', header).removeClass('dp_blocked');

            }

        }

        /**
         *  Shows the appropriate view (days, months or years) according to the current value of the "view" property.
         *
         *  @return void
         *
         *  @access private
         */
    var manage_views = function() {

            // if the day picker was not yet generated
            if (daypicker.text() == '' || view == 'days') {

                // if the day picker was not yet generated
                if (daypicker.text() == '') {

                    // if date picker is not always visible
                    if (!plugin.settings.always_visible)

                        // temporarily set the date picker's left outside of view
                        // so that we can later grab its width and height
                        datepicker.css('left', -1000);

                    // temporarily make the date picker visible
                    // so that we can later grab its width and height
                    datepicker.css({
                        'display':  'block'
                    });

            // generate the day picker
            generate_daypicker();

                    // get the day picker's width and height
                    var width = daypicker.outerWidth(),
                        height = daypicker.outerHeight();

                    // adjust the size of the header
                    header.css('width', width);

                    // make the month picker have the same size as the day picker
                    monthpicker.css({
                        'width':    width,
                        'height':   height
                    });

                    // make the year picker have the same size as the day picker
                    yearpicker.css({
                        'width':    width,
                        'height':   height
                    });

                    // adjust the size of the footer
                    footer.css('width', width);

                    // hide the date picker again
                    datepicker.css({
                        'display':  'none'
                    });

                // if the day picker was previously generated at least once
        // generate the day picker
                } else generate_daypicker();

                // hide the year and the month pickers
                monthpicker.css('display', 'none');
                yearpicker.css('display', 'none');

            // if the view is "months"
            } else if (view == 'months') {

                // generate the month picker
                generate_monthpicker();

                // hide the day and the year pickers
                daypicker.css('display', 'none');
                yearpicker.css('display', 'none');

            // if the view is "years"
            } else if (view == 'years') {

                // generate the year picker
                generate_yearpicker();

                // hide the day and the month pickers
                daypicker.css('display', 'none');
                monthpicker.css('display', 'none');

            }

            // if a callback function exists for when navigating through months/years
            if (plugin.settings.onChange && typeof plugin.settings.onChange == 'function' && undefined != view) {

                // get the "active" elements in the view (ignoring the disabled ones)
                var elements = (view == 'days' ?
                                    daypicker.find('td:not(.dp_disabled, .dp_weekend_disabled, .dp_not_in_month, .dp_blocked)') :
                                        (view == 'months' ?
                                            monthpicker.find('td:not(.dp_disabled, .dp_weekend_disabled, .dp_not_in_month, .dp_blocked)') :
                                                yearpicker.find('td:not(.dp_disabled, .dp_weekend_disabled, .dp_not_in_month, .dp_blocked)')));

                // iterate through the active elements
                // and attach a "date" data attribute to each element in the form of
                // YYYY-MM-DD if the view is "days"
                // YYYY-MM if the view is "months"
                // YYYY if the view is "years"
                // so it's easy to identify elements in the list
                elements.each(function() {

                    // if view is "days"
                    if (view == 'days')

                        // attach a "date" data attribute to each element in the form of of YYYY-MM-DD for easily identifying sought elements
                        $(this).data('date', selected_year + '-' + str_pad(selected_month + 1, 2) + '-' + str_pad(to_int($(this).text()), 2));

                    // if view is "months"
                    else if (view == 'months') {

                        // get the month's number for the element's class
                        var matches = $(this).attr('class').match(/dp\_month\_([0-9]+)/);

                        // attach a "date" data attribute to each element in the form of of YYYY-MM for easily identifying sought elements
                        $(this).data('date', selected_year + '-' + str_pad(to_int(matches[1]) + 1, 2));

                    // if view is "years"
                    } else

                        // attach a "date" data attribute to each element in the form of of YYYY for easily identifying sought elements
                        $(this).data('date', to_int($(this).text()));

                });

                // execute the callback function and send as arguments the current view, the elements in the view, and
                // the element the plugin is attached to
                plugin.settings.onChange(view, elements, $element);

            }

            // if the button for clearing a previously selected date needs to be visible all the time,
            // or the date picker is always visible - case in which the "clear" button is always visible -
            // or there is content in the element the date picker is attached to
            // and the footer is not visible
            if ((plugin.settings.always_show_clear || plugin.settings.always_visible || $element.val() != '') && footer.css('display') != 'block')

                // show the footer
                footer.css('display', '');

            // hide the footer otherwise
            else footer.css('display', 'none');

    }

        /**
         *  Puts the specified date in the element the plugin is attached to, and hides the date picker.
         *
         *  @param  integer     year    The year
         *
         *  @param  integer     month   The month
         *
         *  @param  integer     day     The day
         *
         *  @param  string      view    The view from where the method was called
         *
         *  @param  object      cell    The element that was clicked
         *
         *  @return void
         *
         *  @access private
         */
        var select_date = function(year, month, day, view, cell) {

            var

                // construct a new date object from the arguments
                default_date = new Date(year, month, day, 12, 0, 0),

                // pointer to the cells in the current view
                view_cells = (view == 'days' ? daypicker_cells : (view == 'months' ? monthpicker_cells : yearpicker_cells)),

                // the selected date, formatted correctly
                selected_value = format(default_date);

            // set the currently selected and formated date as the value of the element the plugin is attached to
            $element.val(selected_value);

            // if date picker is always visible
            if (plugin.settings.always_visible) {

                // extract the date parts and reassign values to these variables
                // so that everything will be correctly highlighted
                default_month = default_date.getMonth();
                selected_month = default_date.getMonth();
                default_year = default_date.getFullYear();
                selected_year = default_date.getFullYear();
                default_day = default_date.getDate();

                // remove the "selected" class from all cells in the current view
                view_cells.removeClass('dp_selected');

                // add the "selected" class to the currently selected cell
                cell.addClass('dp_selected');

            }

            // hide the date picker
            plugin.hide();

            // updates value for the date picker whose starting date depends on the selected date (if any)
            update_dependent(default_date);

            // if a callback function exists for when selecting a date
            if (plugin.settings.onSelect && typeof plugin.settings.onSelect == 'function')

                // execute the callback function
                plugin.settings.onSelect(selected_value, year + '-' + str_pad(month + 1, 2) + '-' + str_pad(day, 2), default_date, $element);

        }

        /**
         *  Concatenates any number of arguments and returns them as string.
         *
         *  @return string  Returns the concatenated values.
         *
         *  @access private
         */
        var str_concat = function() {

            var str = '';

            // concatenate as string
            for (var i = 0; i < arguments.length; i++) str += (arguments[i] + '');

            // return the concatenated values
            return str;

        }

        /**
         *  Left-pad a string to a certain length with zeroes.
         *
         *  @param  string  str     The string to be padded.
         *
         *  @param  integer len     The length to which the string must be padded
         *
         *  @return string          Returns the string left-padded with leading zeroes
         *
         *  @access private
         */
        var str_pad = function(str, len) {

            // make sure argument is a string
            str += '';

            // pad with leading zeroes until we get to the desired length
            while (str.length < len) str = '0' + str;

            // return padded string
            return str;

        }

        /**
         *  Returns the integer representation of a string
         *
         *  @return int     Returns the integer representation of the string given as argument
         *
         *  @access private
         */
        var to_int = function(str) {

            // return the integer representation of the string given as argument
            return parseInt(str , 10);

        }

        /**
         *  Updates the paired date picker (whose starting date depends on the value of the current date picker)
         *
         *  @param  date    date    A JavaScript date object representing the currently selected date
         *
         *  @return void
         *
         *  @access private
         */
        var update_dependent = function(date) {

            // if the pair element exists
            if (plugin.settings.pair) {

                // iterate through the pair elements (as there may be more than just one)
                $.each(plugin.settings.pair, function() {

                    var $pair = $(this);

                    // chances are that in the beginning the pair element doesn't have the Zebra_DatePicker attached to it yet
                    // (as the "start" element is usually created before the "end" element)
                    // so we'll have to rely on "data" to send the starting date to the pair element

                    // therefore, if Zebra_DatePicker is not yet attached
                    if (!($pair.data && $pair.data('Zebra_DatePicker')))

                        // set the starting date like this
                        $pair.data('zdp_reference_date', date);

                    // if Zebra_DatePicker is attached to the pair element
                    else {

                        // reference the date picker object attached to the other element
                        var dp = $pair.data('Zebra_DatePicker');

                        // update the other date picker's starting date
                        // the value depends on the original value of the "direction" attribute
                        // (also, if the pair date picker does not have a direction, set it to 1)
                        dp.update({
                            'reference_date':   date,
                            'direction':        dp.settings.direction == 0 ? 1 : dp.settings.direction
                        });

                        // if the other date picker is always visible, update the visuals now
                        if (dp.settings.always_visible) dp.show()

                    }

                });

            }

        }

        /**
         *  Calculate the ISO 8601 week number for a given date.
         *
         *  Code is based on the algorithm at http://www.tondering.dk/claus/cal/week.php#calcweekno
         */
        var getWeekNumber = function(date) {

            var y = date.getFullYear(),
                m = date.getMonth() + 1,
                d = date.getDate(),
                a, b, c, s, e, f, g, d, n, w;

            // If month jan. or feb.
            if (m < 3) {

                a = y - 1;
                b = (a / 4 | 0) - (a / 100 | 0) + (a / 400 | 0);
                c = ((a - 1) / 4 | 0) - ((a - 1) / 100 | 0) + ((a - 1) / 400 | 0);
                s = b - c;
                e = 0;
                f = d - 1 + 31 * (m - 1);

            // If month mar. through dec.
            } else {

                a = y;
                b = (a / 4 | 0) - (a / 100 | 0) + (a / 400 | 0);
                c = ((a - 1) / 4 | 0) - ((a - 1) / 100 | 0) + ((a - 1) / 400 | 0);
                s = b - c;
                e = s + 1;
                f = d + ((153 * (m - 3) + 2) / 5 | 0) + 58 + s;

            }

            g = (a + b) % 7;
            // ISO Weekday (0 is monday, 1 is tuesday etc.)
            d = (f + g - e) % 7;
            n = f + 3 - d;

            if (n < 0) w = 53 - ((g - s) / 5 | 0);

            else if (n > 364 + s) w = 1;

            else w = (n / 7 | 0) + 1;

            return w;

        }

        /**
         *  Function to be called when the "onKeyUp" event occurs
         *
         *  Why as a separate function and not inline when binding the event? Because only this way we can "unbind" it
         *  if the date picker is destroyed
         *
         *  @return boolean     Returns TRUE
         *
         *  @access private
         */
        plugin._keyup = function(e) {

            // if the date picker is visible
            // and the pressed key is ESC
            // hide the date picker
            if (datepicker.css('display') == 'block' || e.which == 27) plugin.hide();

            return true;

        }

        /**
         *  Function to be called when the "onMouseDown" event occurs
         *
         *  Why as a separate function and not inline when binding the event? Because only this way we can "unbind" it
         *  if the date picker is destroyed
         *
         *  @return boolean     Returns TRUE
         *
         *  @access private
         */
        plugin._mousedown = function(e) {

            // if the date picker is visible
            if (datepicker.css('display') == 'block') {

                // if the calendar icon is visible and we clicked it, let the onClick event of the icon to handle the event
                // (we want it to toggle the date picker)
                if (plugin.settings.show_icon && $(e.target).get(0) === icon.get(0)) return true;

                // if what's clicked is not inside the date picker
                // hide the date picker
                if ($(e.target).parents().filter('.Zebra_DatePicker').length == 0) plugin.hide();

            }

            return true;

        }

        // since with jQuery 1.9.0 the $.browser object was removed we realy on this piece of code from
        // http://www.quirksmode.org/js/detect.html to detect the broser
        var browser = {
          init: function () {
            this.name = this.searchString(this.dataBrowser) || '';
            this.version = this.searchVersion(navigator.userAgent)
              || this.searchVersion(navigator.appVersion)
              || '';
          },
          searchString: function (data) {
            for (var i=0;i<data.length;i++) {
              var dataString = data[i].string;
              var dataProp = data[i].prop;
              this.versionSearchString = data[i].versionSearch || data[i].identity;
              if (dataString) {
                if (dataString.indexOf(data[i].subString) != -1)
                  return data[i].identity;
              }
              else if (dataProp)
                return data[i].identity;
            }
          },
          searchVersion: function (dataString) {
            var index = dataString.indexOf(this.versionSearchString);
            if (index == -1) return;
            return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
          },
          dataBrowser: [
            {
              string: navigator.userAgent,
              subString: 'Firefox',
              identity: 'firefox'
            },
            {
              string: navigator.userAgent,
              subString: 'MSIE',
              identity: 'explorer',
              versionSearch: 'MSIE'
            }
          ]
        }
        browser.init();

        // initialize the plugin
        init();

    }

    $.fn.Zebra_DatePicker = function(options) {

        return this.each(function() {

            // if element has a date picker already attached
            if (undefined != $(this).data('Zebra_DatePicker')) {

                // get reference to the previously attached date picker
                var plugin = $(this).data('Zebra_DatePicker');

                // remove the attached icon (if it exists)...
                if (undefined != plugin.icon) plugin.icon.remove();
                // ...and the calendar
                plugin.datepicker.remove();

                // remove associated event handlers from the document
                $(document).unbind('keyup', plugin._keyup);
                $(document).unbind('mousedown', plugin._mousedown);

            }

            // create a new instance of the plugin
            var plugin = new $.Zebra_DatePicker(this, options);

            // save a reference to the newly created object
            $(this).data('Zebra_DatePicker', plugin);

        });

    }

})(jQuery);

/**
*
*
* VALIDATION PLUGIN
*
*
*
*
*
*/
/*! jQuery Validation Plugin - v1.11.0 - 2/4/2013
* https://github.com/jzaefferer/jquery-validation
* Copyright (c) 2013 Jörn Zaefferer; Licensed MIT */

(function($) {

$.extend($.fn, {
  // http://docs.jquery.com/Plugins/Validation/validate
  validate: function( options ) {

    // if nothing is selected, return nothing; can't chain anyway
    if ( !this.length ) {
      if ( options && options.debug && window.console ) {
        console.warn( "Nothing selected, can't validate, returning nothing." );
      }
      return;
    }

    // check if a validator for this form was already created
    var validator = $.data( this[0], "validator" );
    if ( validator ) {
      return validator;
    }

    // Add novalidate tag if HTML5.
    this.attr( "novalidate", "novalidate" );

    validator = new $.validator( options, this[0] );
    $.data( this[0], "validator", validator );

    if ( validator.settings.onsubmit ) {

      this.validateDelegate( ":submit", "click", function( event ) {
        if ( validator.settings.submitHandler ) {
          validator.submitButton = event.target;
        }
        // allow suppressing validation by adding a cancel class to the submit button
        if ( $(event.target).hasClass("cancel") ) {
          validator.cancelSubmit = true;
        }
      });

      // validate the form on submit
      this.submit( function( event ) {
        if ( validator.settings.debug ) {
          // prevent form submit to be able to see console output
          event.preventDefault();
        }
        function handle() {
          var hidden;
          if ( validator.settings.submitHandler ) {
            if ( validator.submitButton ) {
              // insert a hidden input as a replacement for the missing submit button
              hidden = $("<input type='hidden'/>").attr("name", validator.submitButton.name).val(validator.submitButton.value).appendTo(validator.currentForm);
            }
            validator.settings.submitHandler.call( validator, validator.currentForm, event );
            if ( validator.submitButton ) {
              // and clean up afterwards; thanks to no-block-scope, hidden can be referenced
              hidden.remove();
            }
            return false;
          }
          return true;
        }

        // prevent submit for invalid forms or custom submit handlers
        if ( validator.cancelSubmit ) {
          validator.cancelSubmit = false;
          return handle();
        }
        if ( validator.form() ) {
          if ( validator.pendingRequest ) {
            validator.formSubmitted = true;
            return false;
          }
          return handle();
        } else {
          validator.focusInvalid();
          return false;
        }
      });
    }

    return validator;
  },
  // http://docs.jquery.com/Plugins/Validation/valid
  valid: function() {
    if ( $(this[0]).is("form")) {
      return this.validate().form();
    } else {
      var valid = true;
      var validator = $(this[0].form).validate();
      this.each(function() {
        valid &= validator.element(this);
      });
      return valid;
    }
  },
  // attributes: space seperated list of attributes to retrieve and remove
  removeAttrs: function( attributes ) {
    var result = {},
      $element = this;
    $.each(attributes.split(/\s/), function( index, value ) {
      result[value] = $element.attr(value);
      $element.removeAttr(value);
    });
    return result;
  },
  // http://docs.jquery.com/Plugins/Validation/rules
  rules: function( command, argument ) {
    var element = this[0];

    if ( command ) {
      var settings = $.data(element.form, "validator").settings;
      var staticRules = settings.rules;
      var existingRules = $.validator.staticRules(element);
      switch(command) {
      case "add":
        $.extend(existingRules, $.validator.normalizeRule(argument));
        staticRules[element.name] = existingRules;
        if ( argument.messages ) {
          settings.messages[element.name] = $.extend( settings.messages[element.name], argument.messages );
        }
        break;
      case "remove":
        if ( !argument ) {
          delete staticRules[element.name];
          return existingRules;
        }
        var filtered = {};
        $.each(argument.split(/\s/), function( index, method ) {
          filtered[method] = existingRules[method];
          delete existingRules[method];
        });
        return filtered;
      }
    }

    var data = $.validator.normalizeRules(
    $.extend(
      {},
      $.validator.classRules(element),
      $.validator.attributeRules(element),
      $.validator.dataRules(element),
      $.validator.staticRules(element)
    ), element);

    // make sure required is at front
    if ( data.required ) {
      var param = data.required;
      delete data.required;
      data = $.extend({required: param}, data);
    }

    return data;
  }
});

// Custom selectors
$.extend($.expr[":"], {
  // http://docs.jquery.com/Plugins/Validation/blank
  blank: function( a ) { return !$.trim("" + a.value); },
  // http://docs.jquery.com/Plugins/Validation/filled
  filled: function( a ) { return !!$.trim("" + a.value); },
  // http://docs.jquery.com/Plugins/Validation/unchecked
  unchecked: function( a ) { return !a.checked; }
});

// constructor for validator
$.validator = function( options, form ) {
  this.settings = $.extend( true, {}, $.validator.defaults, options );
  this.currentForm = form;
  this.init();
};

$.validator.format = function( source, params ) {
  if ( arguments.length === 1 ) {
    return function() {
      var args = $.makeArray(arguments);
      args.unshift(source);
      return $.validator.format.apply( this, args );
    };
  }
  if ( arguments.length > 2 && params.constructor !== Array  ) {
    params = $.makeArray(arguments).slice(1);
  }
  if ( params.constructor !== Array ) {
    params = [ params ];
  }
  $.each(params, function( i, n ) {
    source = source.replace( new RegExp("\\{" + i + "\\}", "g"), function() {
      return n;
    });
  });
  return source;
};

$.extend($.validator, {

  defaults: {
    messages: {},
    groups: {},
    rules: {},
    errorClass: "error",
    validClass: "valid",
    errorElement: "label",
    focusInvalid: true,
    errorContainer: $([]),
    errorLabelContainer: $([]),
    onsubmit: true,
    ignore: ":hidden",
    ignoreTitle: false,
    onfocusin: function( element, event ) {
      this.lastActive = element;

      // hide error label and remove error class on focus if enabled
      if ( this.settings.focusCleanup && !this.blockFocusCleanup ) {
        if ( this.settings.unhighlight ) {
          this.settings.unhighlight.call( this, element, this.settings.errorClass, this.settings.validClass );
        }
        this.addWrapper(this.errorsFor(element)).hide();
      }
    },
    onfocusout: function( element, event ) {
      if ( !this.checkable(element) && (element.name in this.submitted || !this.optional(element)) ) {
        this.element(element);
      }
    },
    onkeyup: function( element, event ) {
      if ( event.which === 9 && this.elementValue(element) === "" ) {
        return;
      } else if ( element.name in this.submitted || element === this.lastElement ) {
        this.element(element);
      }
    },
    onclick: function( element, event ) {
      // click on selects, radiobuttons and checkboxes
      if ( element.name in this.submitted ) {
        this.element(element);
      }
      // or option elements, check parent select in that case
      else if ( element.parentNode.name in this.submitted ) {
        this.element(element.parentNode);
      }
    },
    highlight: function( element, errorClass, validClass ) {
      if ( element.type === "radio" ) {
        this.findByName(element.name).addClass(errorClass).removeClass(validClass);
      } else {
        $(element).addClass(errorClass).removeClass(validClass);
      }
    },
    unhighlight: function( element, errorClass, validClass ) {
      if ( element.type === "radio" ) {
        this.findByName(element.name).removeClass(errorClass).addClass(validClass);
      } else {
        $(element).removeClass(errorClass).addClass(validClass);
      }
    }
  },

  // http://docs.jquery.com/Plugins/Validation/Validator/setDefaults
  setDefaults: function( settings ) {
    $.extend( $.validator.defaults, settings );
  },

  messages: {
    required: "",
    remote: "Please fix this field.",
    email: "",
    url: "Please enter a valid URL.",
    date: "Please enter a valid date.",
    dateISO: "Please enter a valid date (ISO).",
    number: "Please enter a valid number.",
    digits: "Please enter only digits.",
    creditcard: "Please enter a valid credit card number.",
    equalTo: "Please enter the same value again.",
    maxlength: $.validator.format("Please enter no more than {0} characters."),
    minlength: $.validator.format("Please enter at least {0} characters."),
    rangelength: $.validator.format("Please enter a value between {0} and {1} characters long."),
    range: $.validator.format("Please enter a value between {0} and {1}."),
    max: $.validator.format("Please enter a value less than or equal to {0}."),
    min: $.validator.format("Please enter a value greater than or equal to {0}.")
  },

  autoCreateRanges: false,

  prototype: {

    init: function() {
      this.labelContainer = $(this.settings.errorLabelContainer);
      this.errorContext = this.labelContainer.length && this.labelContainer || $(this.currentForm);
      this.containers = $(this.settings.errorContainer).add( this.settings.errorLabelContainer );
      this.submitted = {};
      this.valueCache = {};
      this.pendingRequest = 0;
      this.pending = {};
      this.invalid = {};
      this.reset();

      var groups = (this.groups = {});
      $.each(this.settings.groups, function( key, value ) {
        if ( typeof value === "string" ) {
          value = value.split(/\s/);
        }
        $.each(value, function( index, name ) {
          groups[name] = key;
        });
      });
      var rules = this.settings.rules;
      $.each(rules, function( key, value ) {
        rules[key] = $.validator.normalizeRule(value);
      });

      function delegate(event) {
        var validator = $.data(this[0].form, "validator"),
          eventType = "on" + event.type.replace(/^validate/, "");
        if ( validator.settings[eventType] ) {
          validator.settings[eventType].call(validator, this[0], event);
        }
      }
      $(this.currentForm)
        .validateDelegate(":text, [type='password'], [type='file'], select, textarea, " +
          "[type='number'], [type='search'] ,[type='tel'], [type='url'], " +
          "[type='email'], [type='datetime'], [type='date'], [type='month'], " +
          "[type='week'], [type='time'], [type='datetime-local'], " +
          "[type='range'], [type='color'] ",
          "focusin focusout keyup", delegate)
        .validateDelegate("[type='radio'], [type='checkbox'], select, option", "click", delegate);

      if ( this.settings.invalidHandler ) {
        $(this.currentForm).bind("invalid-form.validate", this.settings.invalidHandler);
      }
    },

    // http://docs.jquery.com/Plugins/Validation/Validator/form
    form: function() {
      this.checkForm();
      $.extend(this.submitted, this.errorMap);
      this.invalid = $.extend({}, this.errorMap);
      if ( !this.valid() ) {
        $(this.currentForm).triggerHandler("invalid-form", [this]);
      }
      this.showErrors();
      return this.valid();
    },

    checkForm: function() {
      this.prepareForm();
      for ( var i = 0, elements = (this.currentElements = this.elements()); elements[i]; i++ ) {
        this.check( elements[i] );
      }
      return this.valid();
    },

    // http://docs.jquery.com/Plugins/Validation/Validator/element
    element: function( element ) {
      element = this.validationTargetFor( this.clean( element ) );
      this.lastElement = element;
      this.prepareElement( element );
      this.currentElements = $(element);
      var result = this.check( element ) !== false;
      if ( result ) {
        delete this.invalid[element.name];
      } else {
        this.invalid[element.name] = true;
      }
      if ( !this.numberOfInvalids() ) {
        // Hide error containers on last error
        this.toHide = this.toHide.add( this.containers );
      }
      this.showErrors();
      return result;
    },

    // http://docs.jquery.com/Plugins/Validation/Validator/showErrors
    showErrors: function( errors ) {
      if ( errors ) {
        // add items to error list and map
        $.extend( this.errorMap, errors );
        this.errorList = [];
        for ( var name in errors ) {
          this.errorList.push({
            message: errors[name],
            element: this.findByName(name)[0]
          });
        }
        // remove items from success list
        this.successList = $.grep( this.successList, function( element ) {
          return !(element.name in errors);
        });
      }
      if ( this.settings.showErrors ) {
        this.settings.showErrors.call( this, this.errorMap, this.errorList );
      } else {
        this.defaultShowErrors();
      }
    },

    // http://docs.jquery.com/Plugins/Validation/Validator/resetForm
    resetForm: function() {
      if ( $.fn.resetForm ) {
        $(this.currentForm).resetForm();
      }
      this.submitted = {};
      this.lastElement = null;
      this.prepareForm();
      this.hideErrors();
      this.elements().removeClass( this.settings.errorClass ).removeData( "previousValue" );
    },

    numberOfInvalids: function() {
      return this.objectLength(this.invalid);
    },

    objectLength: function( obj ) {
      var count = 0;
      for ( var i in obj ) {
        count++;
      }
      return count;
    },

    hideErrors: function() {
      this.addWrapper( this.toHide ).hide();
    },

    valid: function() {
      return this.size() === 0;
    },

    size: function() {
      return this.errorList.length;
    },

    focusInvalid: function() {
      if ( this.settings.focusInvalid ) {
        try {
          $(this.findLastActive() || this.errorList.length && this.errorList[0].element || [])
          .filter(":visible")
          .focus()
          // manually trigger focusin event; without it, focusin handler isn't called, findLastActive won't have anything to find
          .trigger("focusin");
        } catch(e) {
          // ignore IE throwing errors when focusing hidden elements
        }
      }
    },

    findLastActive: function() {
      var lastActive = this.lastActive;
      return lastActive && $.grep(this.errorList, function( n ) {
        return n.element.name === lastActive.name;
      }).length === 1 && lastActive;
    },

    elements: function() {
      var validator = this,
        rulesCache = {};

      // select all valid inputs inside the form (no submit or reset buttons)
      return $(this.currentForm)
      .find("input, select, textarea")
      .not(":submit, :reset, :image, [disabled]")
      .not( this.settings.ignore )
      .filter(function() {
        if ( !this.name && validator.settings.debug && window.console ) {
          console.error( "%o has no name assigned", this);
        }

        // select only the first element for each name, and only those with rules specified
        if ( this.name in rulesCache || !validator.objectLength($(this).rules()) ) {
          return false;
        }

        rulesCache[this.name] = true;
        return true;
      });
    },

    clean: function( selector ) {
      return $(selector)[0];
    },

    errors: function() {
      var errorClass = this.settings.errorClass.replace(" ", ".");
      return $(this.settings.errorElement + "." + errorClass, this.errorContext);
    },

    reset: function() {
      this.successList = [];
      this.errorList = [];
      this.errorMap = {};
      this.toShow = $([]);
      this.toHide = $([]);
      this.currentElements = $([]);
    },

    prepareForm: function() {
      this.reset();
      this.toHide = this.errors().add( this.containers );
    },

    prepareElement: function( element ) {
      this.reset();
      this.toHide = this.errorsFor(element);
    },

    elementValue: function( element ) {
      var type = $(element).attr("type"),
        val = $(element).val();

      if ( type === "radio" || type === "checkbox" ) {
        return $("input[name='" + $(element).attr("name") + "']:checked").val();
      }

      if ( typeof val === "string" ) {
        return val.replace(/\r/g, "");
      }
      return val;
    },

    check: function( element ) {
      element = this.validationTargetFor( this.clean( element ) );

      var rules = $(element).rules();
      var dependencyMismatch = false;
      var val = this.elementValue(element);
      var result;

      for (var method in rules ) {
        var rule = { method: method, parameters: rules[method] };
        try {

          result = $.validator.methods[method].call( this, val, element, rule.parameters );

          // if a method indicates that the field is optional and therefore valid,
          // don't mark it as valid when there are no other rules
          if ( result === "dependency-mismatch" ) {
            dependencyMismatch = true;
            continue;
          }
          dependencyMismatch = false;

          if ( result === "pending" ) {
            this.toHide = this.toHide.not( this.errorsFor(element) );
            return;
          }

          if ( !result ) {
            this.formatAndAdd( element, rule );
            return false;
          }
        } catch(e) {
          if ( this.settings.debug && window.console ) {
            console.log( "Exception occured when checking element " + element.id + ", check the '" + rule.method + "' method.", e );
          }
          throw e;
        }
      }
      if ( dependencyMismatch ) {
        return;
      }
      if ( this.objectLength(rules) ) {
        this.successList.push(element);
      }
      return true;
    },

    // return the custom message for the given element and validation method
    // specified in the element's HTML5 data attribute
    customDataMessage: function( element, method ) {
      return $(element).data("msg-" + method.toLowerCase()) || (element.attributes && $(element).attr("data-msg-" + method.toLowerCase()));
    },

    // return the custom message for the given element name and validation method
    customMessage: function( name, method ) {
      var m = this.settings.messages[name];
      return m && (m.constructor === String ? m : m[method]);
    },

    // return the first defined argument, allowing empty strings
    findDefined: function() {
      for(var i = 0; i < arguments.length; i++) {
        if ( arguments[i] !== undefined ) {
          return arguments[i];
        }
      }
      return undefined;
    },

    defaultMessage: function( element, method ) {
      return this.findDefined(
        this.customMessage( element.name, method ),
        this.customDataMessage( element, method ),
        // title is never undefined, so handle empty string as undefined
        !this.settings.ignoreTitle && element.title || undefined,
        $.validator.messages[method],
        "<strong>Warning: No message defined for " + element.name + "</strong>"
      );
    },

    formatAndAdd: function( element, rule ) {
      var message = this.defaultMessage( element, rule.method ),
        theregex = /\$?\{(\d+)\}/g;
      if ( typeof message === "function" ) {
        message = message.call(this, rule.parameters, element);
      } else if (theregex.test(message)) {
        message = $.validator.format(message.replace(theregex, "{$1}"), rule.parameters);
      }
      this.errorList.push({
        message: message,
        element: element
      });

      this.errorMap[element.name] = message;
      this.submitted[element.name] = message;
    },

    addWrapper: function( toToggle ) {
      if ( this.settings.wrapper ) {
        toToggle = toToggle.add( toToggle.parent( this.settings.wrapper ) );
      }
      return toToggle;
    },

    defaultShowErrors: function() {
      var i, elements;
      for ( i = 0; this.errorList[i]; i++ ) {
        var error = this.errorList[i];
        if ( this.settings.highlight ) {
          this.settings.highlight.call( this, error.element, this.settings.errorClass, this.settings.validClass );
        }
        this.showLabel( error.element, error.message );
      }
      if ( this.errorList.length ) {
        this.toShow = this.toShow.add( this.containers );
      }
      if ( this.settings.success ) {
        for ( i = 0; this.successList[i]; i++ ) {
          this.showLabel( this.successList[i] );
        }
      }
      if ( this.settings.unhighlight ) {
        for ( i = 0, elements = this.validElements(); elements[i]; i++ ) {
          this.settings.unhighlight.call( this, elements[i], this.settings.errorClass, this.settings.validClass );
        }
      }
      this.toHide = this.toHide.not( this.toShow );
      this.hideErrors();
      this.addWrapper( this.toShow ).show();
    },

    validElements: function() {
      return this.currentElements.not(this.invalidElements());
    },

    invalidElements: function() {
      return $(this.errorList).map(function() {
        return this.element;
      });
    },

    showLabel: function( element, message ) {
      var label = this.errorsFor( element );
      if ( label.length ) {
        // refresh error/success class
        label.removeClass( this.settings.validClass ).addClass( this.settings.errorClass );
        // replace message on existing label
        label.html(message);
      } else {
        // create label
        label = $("<" + this.settings.errorElement + ">")
          .attr("for", this.idOrName(element))
          .addClass(this.settings.errorClass)
          .html(message || "");
        if ( this.settings.wrapper ) {
          // make sure the element is visible, even in IE
          // actually showing the wrapped element is handled elsewhere
          label = label.hide().show().wrap("<" + this.settings.wrapper + "/>").parent();
        }
        if ( !this.labelContainer.append(label).length ) {
          if ( this.settings.errorPlacement ) {
            this.settings.errorPlacement(label, $(element) );
          } else {
            label.insertAfter(element);
          }
        }
      }
      if ( !message && this.settings.success ) {
        label.text("");
        if ( typeof this.settings.success === "string" ) {
          label.addClass( this.settings.success );
        } else {
          this.settings.success( label, element );
        }
      }
      this.toShow = this.toShow.add(label);
    },

    errorsFor: function( element ) {
      var name = this.idOrName(element);
      return this.errors().filter(function() {
        return $(this).attr("for") === name;
      });
    },

    idOrName: function( element ) {
      return this.groups[element.name] || (this.checkable(element) ? element.name : element.id || element.name);
    },

    validationTargetFor: function( element ) {
      // if radio/checkbox, validate first element in group instead
      if ( this.checkable(element) ) {
        element = this.findByName( element.name ).not(this.settings.ignore)[0];
      }
      return element;
    },

    checkable: function( element ) {
      return (/radio|checkbox/i).test(element.type);
    },

    findByName: function( name ) {
      return $(this.currentForm).find("[name='" + name + "']");
    },

    getLength: function( value, element ) {
      switch( element.nodeName.toLowerCase() ) {
      case "select":
        return $("option:selected", element).length;
      case "input":
        if ( this.checkable( element) ) {
          return this.findByName(element.name).filter(":checked").length;
        }
      }
      return value.length;
    },

    depend: function( param, element ) {
      return this.dependTypes[typeof param] ? this.dependTypes[typeof param](param, element) : true;
    },

    dependTypes: {
      "boolean": function( param, element ) {
        return param;
      },
      "string": function( param, element ) {
        return !!$(param, element.form).length;
      },
      "function": function( param, element ) {
        return param(element);
      }
    },

    optional: function( element ) {
      var val = this.elementValue(element);
      return !$.validator.methods.required.call(this, val, element) && "dependency-mismatch";
    },

    startRequest: function( element ) {
      if ( !this.pending[element.name] ) {
        this.pendingRequest++;
        this.pending[element.name] = true;
      }
    },

    stopRequest: function( element, valid ) {
      this.pendingRequest--;
      // sometimes synchronization fails, make sure pendingRequest is never < 0
      if ( this.pendingRequest < 0 ) {
        this.pendingRequest = 0;
      }
      delete this.pending[element.name];
      if ( valid && this.pendingRequest === 0 && this.formSubmitted && this.form() ) {
        $(this.currentForm).submit();
        this.formSubmitted = false;
      } else if (!valid && this.pendingRequest === 0 && this.formSubmitted) {
        $(this.currentForm).triggerHandler("invalid-form", [this]);
        this.formSubmitted = false;
      }
    },

    previousValue: function( element ) {
      return $.data(element, "previousValue") || $.data(element, "previousValue", {
        old: null,
        valid: true,
        message: this.defaultMessage( element, "remote" )
      });
    }

  },

  classRuleSettings: {
    required: {required: true},
    email: {email: true},
    url: {url: true},
    date: {date: true},
    dateISO: {dateISO: true},
    number: {number: true},
    digits: {digits: true},
    creditcard: {creditcard: true}
  },

  addClassRules: function( className, rules ) {
    if ( className.constructor === String ) {
      this.classRuleSettings[className] = rules;
    } else {
      $.extend(this.classRuleSettings, className);
    }
  },

  classRules: function( element ) {
    var rules = {};
    var classes = $(element).attr("class");
    if ( classes ) {
      $.each(classes.split(" "), function() {
        if ( this in $.validator.classRuleSettings ) {
          $.extend(rules, $.validator.classRuleSettings[this]);
        }
      });
    }
    return rules;
  },

  attributeRules: function( element ) {
    var rules = {};
    var $element = $(element);

    for (var method in $.validator.methods) {
      var value;

      // support for <input required> in both html5 and older browsers
      if ( method === "required" ) {
        value = $element.get(0).getAttribute(method);
        // Some browsers return an empty string for the required attribute
        // and non-HTML5 browsers might have required="" markup
        if ( value === "" ) {
          value = true;
        }
        // force non-HTML5 browsers to return bool
        value = !!value;
      } else {
        value = $element.attr(method);
      }

      if ( value ) {
        rules[method] = value;
      } else if ( $element[0].getAttribute("type") === method ) {
        rules[method] = true;
      }
    }

    // maxlength may be returned as -1, 2147483647 (IE) and 524288 (safari) for text inputs
    if ( rules.maxlength && /-1|2147483647|524288/.test(rules.maxlength) ) {
      delete rules.maxlength;
    }

    return rules;
  },

  dataRules: function( element ) {
    var method, value,
      rules = {}, $element = $(element);
    for (method in $.validator.methods) {
      value = $element.data("rule-" + method.toLowerCase());
      if ( value !== undefined ) {
        rules[method] = value;
      }
    }
    return rules;
  },

  staticRules: function( element ) {
    var rules = {};
    var validator = $.data(element.form, "validator");
    if ( validator.settings.rules ) {
      rules = $.validator.normalizeRule(validator.settings.rules[element.name]) || {};
    }
    return rules;
  },

  normalizeRules: function( rules, element ) {
    // handle dependency check
    $.each(rules, function( prop, val ) {
      // ignore rule when param is explicitly false, eg. required:false
      if ( val === false ) {
        delete rules[prop];
        return;
      }
      if ( val.param || val.depends ) {
        var keepRule = true;
        switch (typeof val.depends) {
        case "string":
          keepRule = !!$(val.depends, element.form).length;
          break;
        case "function":
          keepRule = val.depends.call(element, element);
          break;
        }
        if ( keepRule ) {
          rules[prop] = val.param !== undefined ? val.param : true;
        } else {
          delete rules[prop];
        }
      }
    });

    // evaluate parameters
    $.each(rules, function( rule, parameter ) {
      rules[rule] = $.isFunction(parameter) ? parameter(element) : parameter;
    });

    // clean number parameters
    $.each(['minlength', 'maxlength'], function() {
      if ( rules[this] ) {
        rules[this] = Number(rules[this]);
      }
    });
    $.each(['rangelength'], function() {
      var parts;
      if ( rules[this] ) {
        if ( $.isArray(rules[this]) ) {
          rules[this] = [Number(rules[this][0]), Number(rules[this][1])];
        } else if ( typeof rules[this] === "string" ) {
          parts = rules[this].split(/[\s,]+/);
          rules[this] = [Number(parts[0]), Number(parts[1])];
        }
      }
    });

    if ( $.validator.autoCreateRanges ) {
      // auto-create ranges
      if ( rules.min && rules.max ) {
        rules.range = [rules.min, rules.max];
        delete rules.min;
        delete rules.max;
      }
      if ( rules.minlength && rules.maxlength ) {
        rules.rangelength = [rules.minlength, rules.maxlength];
        delete rules.minlength;
        delete rules.maxlength;
      }
    }

    return rules;
  },

  // Converts a simple string to a {string: true} rule, e.g., "required" to {required:true}
  normalizeRule: function( data ) {
    if ( typeof data === "string" ) {
      var transformed = {};
      $.each(data.split(/\s/), function() {
        transformed[this] = true;
      });
      data = transformed;
    }
    return data;
  },

  // http://docs.jquery.com/Plugins/Validation/Validator/addMethod
  addMethod: function( name, method, message ) {
    $.validator.methods[name] = method;
    $.validator.messages[name] = message !== undefined ? message : $.validator.messages[name];
    if ( method.length < 3 ) {
      $.validator.addClassRules(name, $.validator.normalizeRule(name));
    }
  },

  methods: {

    // http://docs.jquery.com/Plugins/Validation/Methods/required
    required: function( value, element, param ) {
      // check if dependency is met
      if ( !this.depend(param, element) ) {
        return "dependency-mismatch";
      }
      if ( element.nodeName.toLowerCase() === "select" ) {
        // could be an array for select-multiple or a string, both are fine this way
        var val = $(element).val();
        return val && val.length > 0;
      }
      if ( this.checkable(element) ) {
        return this.getLength(value, element) > 0;
      }
      return $.trim(value).length > 0;
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/remote
    remote: function( value, element, param ) {
      if ( this.optional(element) ) {
        return "dependency-mismatch";
      }

      var previous = this.previousValue(element);
      if (!this.settings.messages[element.name] ) {
        this.settings.messages[element.name] = {};
      }
      previous.originalMessage = this.settings.messages[element.name].remote;
      this.settings.messages[element.name].remote = previous.message;

      param = typeof param === "string" && {url:param} || param;

      if ( previous.old === value ) {
        return previous.valid;
      }

      previous.old = value;
      var validator = this;
      this.startRequest(element);
      var data = {};
      data[element.name] = value;
      $.ajax($.extend(true, {
        url: param,
        mode: "abort",
        port: "validate" + element.name,
        dataType: "json",
        data: data,
        success: function( response ) {
          validator.settings.messages[element.name].remote = previous.originalMessage;
          var valid = response === true || response === "true";
          if ( valid ) {
            var submitted = validator.formSubmitted;
            validator.prepareElement(element);
            validator.formSubmitted = submitted;
            validator.successList.push(element);
            delete validator.invalid[element.name];
            validator.showErrors();
          } else {
            var errors = {};
            var message = response || validator.defaultMessage( element, "remote" );
            errors[element.name] = previous.message = $.isFunction(message) ? message(value) : message;
            validator.invalid[element.name] = true;
            validator.showErrors(errors);
          }
          previous.valid = valid;
          validator.stopRequest(element, valid);
        }
      }, param));
      return "pending";
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/minlength
    minlength: function( value, element, param ) {
      var length = $.isArray( value ) ? value.length : this.getLength($.trim(value), element);
      return this.optional(element) || length >= param;
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/maxlength
    maxlength: function( value, element, param ) {
      var length = $.isArray( value ) ? value.length : this.getLength($.trim(value), element);
      return this.optional(element) || length <= param;
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/rangelength
    rangelength: function( value, element, param ) {
      var length = $.isArray( value ) ? value.length : this.getLength($.trim(value), element);
      return this.optional(element) || ( length >= param[0] && length <= param[1] );
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/min
    min: function( value, element, param ) {
      return this.optional(element) || value >= param;
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/max
    max: function( value, element, param ) {
      return this.optional(element) || value <= param;
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/range
    range: function( value, element, param ) {
      return this.optional(element) || ( value >= param[0] && value <= param[1] );
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/email
    email: function( value, element ) {
      // contributed by Scott Gonzalez: http://projects.scottsplayground.com/email_address_validation/
      return this.optional(element) || /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i.test(value);
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/url
    url: function( value, element ) {
      // contributed by Scott Gonzalez: http://projects.scottsplayground.com/iri/
      return this.optional(element) || /^(https?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(value);
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/date
    date: function( value, element ) {
      return this.optional(element) || !/Invalid|NaN/.test(new Date(value).toString());
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/dateISO
    dateISO: function( value, element ) {
      return this.optional(element) || /^\d{4}[\/\-]\d{1,2}[\/\-]\d{1,2}$/.test(value);
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/number
    number: function( value, element ) {
      return this.optional(element) || /^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/.test(value);
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/digits
    digits: function( value, element ) {
      return this.optional(element) || /^\d+$/.test(value);
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/creditcard
    // based on http://en.wikipedia.org/wiki/Luhn
    creditcard: function( value, element ) {
      if ( this.optional(element) ) {
        return "dependency-mismatch";
      }
      // accept only spaces, digits and dashes
      if ( /[^0-9 \-]+/.test(value) ) {
        return false;
      }
      var nCheck = 0,
        nDigit = 0,
        bEven = false;

      value = value.replace(/\D/g, "");

      for (var n = value.length - 1; n >= 0; n--) {
        var cDigit = value.charAt(n);
        nDigit = parseInt(cDigit, 10);
        if ( bEven ) {
          if ( (nDigit *= 2) > 9 ) {
            nDigit -= 9;
          }
        }
        nCheck += nDigit;
        bEven = !bEven;
      }

      return (nCheck % 10) === 0;
    },

    // http://docs.jquery.com/Plugins/Validation/Methods/equalTo
    equalTo: function( value, element, param ) {
      // bind to the blur event of the target in order to revalidate whenever the target field is updated
      // TODO find a way to bind the event just once, avoiding the unbind-rebind overhead
      var target = $(param);
      if ( this.settings.onfocusout ) {
        target.unbind(".validate-equalTo").bind("blur.validate-equalTo", function() {
          $(element).valid();
        });
      }
      return value === target.val();
    }

  }

});

// deprecated, use $.validator.format instead
$.format = $.validator.format;

}(jQuery));

// ajax mode: abort
// usage: $.ajax({ mode: "abort"[, port: "uniqueport"]});
// if mode:"abort" is used, the previous request on that port (port can be undefined) is aborted via XMLHttpRequest.abort()
(function($) {
  var pendingRequests = {};
  // Use a prefilter if available (1.5+)
  if ( $.ajaxPrefilter ) {
    $.ajaxPrefilter(function( settings, _, xhr ) {
      var port = settings.port;
      if ( settings.mode === "abort" ) {
        if ( pendingRequests[port] ) {
          pendingRequests[port].abort();
        }
        pendingRequests[port] = xhr;
      }
    });
  } else {
    // Proxy ajax
    var ajax = $.ajax;
    $.ajax = function( settings ) {
      var mode = ( "mode" in settings ? settings : $.ajaxSettings ).mode,
        port = ( "port" in settings ? settings : $.ajaxSettings ).port;
      if ( mode === "abort" ) {
        if ( pendingRequests[port] ) {
          pendingRequests[port].abort();
        }
        return (pendingRequests[port] = ajax.apply(this, arguments));
      }
      return ajax.apply(this, arguments);
    };
  }
}(jQuery));

// provides delegate(type: String, delegate: Selector, handler: Callback) plugin for easier event delegation
// handler is only called when $(event.target).is(delegate), in the scope of the jquery-object for event.target
(function($) {
  $.extend($.fn, {
    validateDelegate: function( delegate, type, handler ) {
      return this.bind(type, function( event ) {
        var target = $(event.target);
        if ( target.is(delegate) ) {
          return handler.apply(target, arguments);
        }
      });
    }
  });
}(jQuery));

$(document).ready(function(){
  $('.date').mask('11/11/1111');
//  $('.time').mask('00:00:00');
//  $('.date_time').mask('99/99/9999 00:00:00');
//  $('.cep').mask('99999-999');
  $('.ssn').mask('999-99-9999');
//  $('.phone_with_ddd').mask('(99) 9999-9999');
  $('.us_phone').mask('999-999-9999');
  $('.zip').mask('99999');
  $('.aba').mask('999999999'),
//  $('.mixed').mask('AAA 000-S0S');
//  $('.cpf').mask('999.999.999-99', {reverse: true});
//  $('.money').mask('000.000.000.000.000,00', {reverse: true});
  
  $( "#borrower_pay_date1" ).Zebra_DatePicker({
    disabled_dates: ['27 05 2013', '04 07 2013', '02 09 2013', '14 10 2013', '11 11 2013', '28 11 2013', '25 12 2013', '* * * 0,6'],
    first_day_of_week: 0,
    offset: [-200,-20]
  });

  $( "#borrower_pay_date2" ).Zebra_DatePicker({
    disabled_dates: ['27 05 2013', '04 07 2013', '02 09 2013', '14 10 2013', '11 11 2013', '28 11 2013', '25 12 2013', '* * * 0,6'],
    first_day_of_week: 0,
    offset: [-200,-20]  
  });

  $("#new_borrower").validate();
});
