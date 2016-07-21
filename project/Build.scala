import sbt._
import Keys._

object Build extends Build {

  override lazy val settings = super.settings ++ Seq(
    scalaVersion := "2.11.6"
  )
  lazy val plantyWorklogs = (project in file(".")).
				aggregate(jiraView, worklogsWeb)

  lazy val worklogsCommon = project in file("planty-worklogs-common")

  lazy val jiraView = (project in file("planty-jira-view")).
      dependsOn(worklogsCommon)

  lazy val catsView = (project in file("planty-cats-view")).
      dependsOn(worklogsCommon)

  lazy val worklogsWeb =  (project in file("planty-worklogs-web")).
			dependsOn(jiraView, catsView)

}
