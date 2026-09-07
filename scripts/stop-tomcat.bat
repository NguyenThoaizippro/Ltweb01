@echo off
set "JAVA_HOME=D:\DaiHoc\hk1-3\laptrinhweb\jdk-26"
set "CATALINA_HOME=D:\DaiHoc\hk1-3\laptrinhweb\apache-tomcat-11.0.4"

echo === Stopping Apache Tomcat 11.0.4 ===
call "%CATALINA_HOME%\bin\catalina.bat" stop
