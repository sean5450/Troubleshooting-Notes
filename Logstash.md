### Error
[logstash.agent] Failed to execute action {:action=>LogStash::PiplineAction::Create/pipeline_id:main, :exception=>"Logstash::ConfigurationError", :message=>"Expected one of [^\\r\\n], \"\\r\", \"\\n\" at line 2, column 148 

### Possible Solutions
1. Comment out `path.config: /etc/logstash` in **logstash.yml** 
2. Add to **jvm.options**
```
--add-opens=java.base/java.lang=ALL-UNNAMED
--add-opens=java.base/java.security=ALL-UNNAMED
--add-opens=java.base/java.util=ALL-UNNAMED
--add-opens=java.base/java.security.cert=ALL-UNNAMED
--add-opens=java.base/java.util.zip=ALL-UNNAMED
--add-opens=java.base/java.lang.reflect=ALL-UNNAMED 
--add-opens=java.base/java.util.regex=ALL-UNNAMED
--add-opens=java.base/java.net=ALL-UNNAMED
--add-opens=java.base/java.io=ALL-UNNAMED
--add-opens=java.base/java.lang=ALL-UNNAMED
--add-opens=java.base/javax.crypto=ALL-UNNAMED
--add-opens=java.management/sun.management=ALL-UNNAMED
```

#### Useful Links
https://discuss.elastic.co/t/logstash-service-failure-failed-to-execute-action-action-logstash-create-pipeline-id-main-exception-logstash-configurationerror/232728/9

https://www.elastic.co/guide/en/logstash/7.6/troubleshooting.html
