=begin
require 'rack/lobster'

map '/health' do
  health = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["1"]]
  end
  run health
end

map '/lobster' do
  run Rack::Lobster.new
end

map '/headers' do
  headers = proc do |env|
    [200, { "Content-Type" => "text/plain" }, [
      env.select {|key,val| key.start_with? 'HTTP_'}
      .collect {|key, val| [key.sub(/^HTTP_/, ''), val]}
      .collect {|key, val| "#{key}: #{val}"}
      .sort
      .join("\n")
    ]]
  end
  run headers
end

map '/' do
  welcome = proc do |env|
    [200, { "Content-Type" => "text/html" }, [IO.read("index.html")]]
  end
  run welcome
end
=end

system({
		"JAVA_HOME" => 	"/usr/lib/jvm/java-1.8.0",
		"PATH" => 	"$JAVA_HOME/bin:$PATH",
		"JAVA_OPTS" => 	"-Dhttp.address=$OPENSHIFT_DIY_IP -Dhttp.port=$OPENSHIFT_DIY_PORT",
		"JAVA_OPTS" => 	"$JAVA_OPTS -Xms256m -Xmx416m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=96m -Duser.home=$OPENSHIFT_DATA_DIR/fakehome",
		"JAVA_OPTS" => 	"$JAVA_OPTS -Dmongodb.host=$OPENSHIFT_MONGODB_DB_HOST -Dmongodb.username=$OPENSHIFT_MONGODB_DB_USERNAME -Dmongodb.password=$OPENSHIFT_MONGODB_DB_PASSWORD"
	}, 
	"nohup $OPENSHIFT_REPO_DIR/planty-worklogs-web/target/universal/stage/bin/planty-worklogs-web |& /usr/bin/logshifter -tag diy &")

