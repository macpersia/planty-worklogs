package com.github.macpersia.planty.worklogs

import com.github.macpersia.planty.worklogs.model.WorklogEntry

trait WorklogReporting extends AutoCloseable {
  def retrieveWorklogs(): Seq[WorklogEntry]
}
