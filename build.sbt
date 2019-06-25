  
lazy val rootSettings = Seq(
  scalaVersion := "2.11.8"
)

lazy val root = (project in file("."))
                .settings(rootSettings)
                .aggregate(catsAdapter, jiraAdapter, worklogsWeb)

lazy val worklogsCommon = project in file("planty-worklogs-common")

lazy val jiraAdapter = (project in file("planty-worklogs-adapter-jira"))
                       .dependsOn(worklogsCommon)

lazy val catsAdapter = (project in file("planty-worklogs-adapter-cats"))
                       .dependsOn(worklogsCommon)

lazy val worklogsWeb = (project in file("planty-worklogs-web"))
                       .dependsOn(jiraAdapter, catsAdapter)
