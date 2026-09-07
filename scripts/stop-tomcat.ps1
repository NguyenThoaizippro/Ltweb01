# Script dung Apache Tomcat 11.0.4
$env:JAVA_HOME = "D:\DaiHoc\hk1-3\laptrinhweb\jdk-26"
$env:CATALINA_HOME = "D:\DaiHoc\hk1-3\laptrinhweb\apache-tomcat-11.0.4"

Write-Host "=== Stopping Apache Tomcat 11.0.4 ==="
& "$env:CATALINA_HOME\bin\catalina.bat" stop
