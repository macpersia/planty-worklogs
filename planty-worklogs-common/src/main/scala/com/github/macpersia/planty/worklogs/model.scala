package com.github.macpersia.planty.worklogs

import java.time.LocalDate
import java.util.TimeZone

package object model {

  class WorklogFilter( author_ : Option[String],
                       fromDate_ : LocalDate,
                       toDate_ : LocalDate,
                       timeZone_ : TimeZone ) {
    val author = author_
    val fromDate = fromDate_
    val toDate = toDate_
    val timeZone = timeZone_
  }

  case class WorklogEntry( date: LocalDate,
                           description: String,
                           duration: Double )
}
