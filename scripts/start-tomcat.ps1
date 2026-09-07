# Script khoi dong Apache Tomcat 11.0.4
$env:JAVA_HOME = "D:\DaiHoc\hk1-3\laptrinhweb\jdk-26"
$env:CATALINA_HOME = "D:\DaiHoc\hk1-3\laptrinhweb\apache-tomcat-11.0.4"

Write-Host "=== Starting Apache Tomcat 11.0.4 ==="
Write-Host "JAVA_HOME: $env:JAVA_HOME"
Write-Host "CATALINA_HOME: $env:CATALINA_HOME"

& "$env:CATALINA_HOME\bin\catalina.bat" run
