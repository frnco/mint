/*
Utility functions for working with `Time`.

_THIS MODULE IS STILL WORK IN PROGRESS_
*/
module Time {
  /*
  Tries to parse the given string as an ISO date.

    Time.fromIso("2018-04-05T00:00:00.000Z")
  */
  fun fromIso (raw : String) : Maybe(Time) {
    `
    (() => {
      try {
        return #{Maybe::Just(`new Date(#{raw})`)}
      } catch (error) {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Formats the given time to the ISO format.

    Time.toIso(Tome.today()) == "2018-04-05T00:00:00.000Z"
  */
  fun toIso (date : Time) : String {
    `#{date}.toISOString()`
  }

  /* Returns the current time. */
  fun now : Time {
    `new Date()`
  }

  /* Returns the time of the begging of today. */
  fun today : Time {
    `
    (() => {
      const date = new Date()

      return new Date(Date.UTC(
        date.getUTCFullYear(),
        date.getUTCMonth(),
        date.getUTCDate()
      ))
    })()
    `
  }

  /*
  Returns a new UTC date from the given parameters.

    Time.from(2018, 4, 5)
  */
  fun from (year : Number, month : Number, day : Number) : Time {
    `new Date(Date.UTC(#{year}, #{month} - 1, #{day}))`
  }

  /*
  Returns the UTC day of the given time.

    (Time.from(2018, 4, 5)
    |> Time.day()) == 5
  */
  fun day (date : Time) : Number {
    `#{date}.getUTCDate()`
  }

  /*
  Returns the UTC month of the given time.

    (Time.from(2018, 4, 5)
    |> Time.month()) == 4
  */
  fun month (date : Time) : Number {
    `(#{date}.getUTCMonth() + 1)`
  }

  /*
  Returns the UTC year of the given time.

    (Time.from(2018, 4, 5)
    |> Time.year()) == 2018
  */
  fun year (date : Time) : Number {
    `#{date}.getUTCFullYear()`
  }

  /* Formats the time using the given pattern. */
  fun format (pattern : String, date : Time) : String {
    `DateFNS.format(#{date}, #{pattern})`
  }

  /* Returns the start of the day / month / week of the given time. */
  fun startOf (what : String, date : Time) : Time {
    `
    (() => {
      switch (#{what}) {
        case 'month':
          return DateFNS.startOfMonth(#{date})
        case 'week':
          return DateFNS.startOfWeek(#{date}, { weekStartsOn: 1 })
        case 'day':
          return DateFNS.startOfDay(#{date})
        default:
          return #{date}
      }
    })()
    `
  }

  /* Returns the end of the day / month / week of the given time. */
  fun endOf (what : String, date : Time) : Time {
    `
    (() => {
      switch (#{what}) {
        case 'month':
          return DateFNS.endOfMonth(#{date})
        case 'week':
          return DateFNS.endOfWeek(#{date}, { weekStartsOn: 1 })
        case 'day':
          return DateFNS.endOfDay(#{date})
        default:
          return #{date}
      }
    })()
    `
  }

  /* Returns an array of days from the given start to given end time. */
  fun range (from : Time, to : Time) : Array(Time) {
    `
    DateFNS.eachDay({
      start: #{from},
      end: #{to}
    })
    `
  }

  /* Returns the next month from the given time. */
  fun nextMonth (date : Time) : Time {
    `
    (() => {
      return DateFNS.addMonths(#{date}, 1)
    })()
    `
  }

  /* Returns the previous month from the given time. */
  fun previousMonth (date : Time) : Time {
    `
    (() => {
      return DateFNS.addMonths(#{date}, -1)
    })()
    `
  }

  /* Returns the previous week from the given time. */
  fun previousWeek (time : Time) : Time {
    `
    (() => {
      const x = new Date(+#{time})
      x.setDate(#{time}.getDate() - 7)
      return x
    })()
    `
  }

  /* Returns the next week from the given time. */
  fun nextWeek (time : Time) : Time {
    `
    (() => {
      const x = new Date(+#{time})
      x.setDate(#{time}.getDate() + 7)
      return x
    })()
    `
  }

  /* Returns the relative time from the given times (in english). */
  fun relative (other : Time, now : Time) : String {
    `
    (() => {
      return DateFNS.distanceInWordsStrict(#{now}, #{other}, { addSuffix: true })
    })()
    `
  }

  /* Returns the time respective to the given UNIX Timestamp (in Milliseconds) */
  fun fromUnixTimestampInMs (timestamp : Number) : Time {
  `
    (() => {
      return new Date(#{timestamp})
    })()
    `
  }

  /* Returns the UNIX Timestamp (in Milliseconds) respective to the given time */
  fun toUnixTimestampInMs (time : Time) : Number {
    `#{time}.getTime()`
  }
}
