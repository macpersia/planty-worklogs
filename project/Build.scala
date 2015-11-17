import sbt._
import Keys._

object PlantyJiraBuild extends Build {

  lazy val plantyWorklogs = (project in file(".")).
				aggregate(jiraView, jiraWeb)

  lazy val jiraView = (project in file("planty-jira-view"))

  lazy val jiraWeb =  (project in file("planty-jira-web")).
			dependsOn(jiraView)

}

