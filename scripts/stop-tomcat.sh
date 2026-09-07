#!/bin/bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-26.jdk/Contents/Home"
export CATALINA_HOME="/Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/apache-tomcat-11.0.4"

echo "=== Stopping Apache Tomcat 11.0.4 ==="
"$CATALINA_HOME/bin/shutdown.sh"
