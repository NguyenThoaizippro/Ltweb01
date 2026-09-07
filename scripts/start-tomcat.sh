#!/bin/bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-26.jdk/Contents/Home"
export CATALINA_HOME="/Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/apache-tomcat-11.0.4"

echo "=== Starting Apache Tomcat 11.0.4 on macOS ==="
echo "JAVA_HOME=$JAVA_HOME"
echo "CATALINA_HOME=$CATALINA_HOME"

"$CATALINA_HOME/bin/startup.sh"
