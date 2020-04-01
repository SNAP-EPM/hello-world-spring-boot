FROM java
ADD ./target/myproject-0.0.1-SNAPSHOT.jar /myproject-0.0.1-SNAPSHOT.jar
EXPOSE 8080:8080
CMD ["java","-jar","/myproject-0.0.1-SNAPSHOT.jar"]