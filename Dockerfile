FROM openjdk:11.0.7
ADD target/bioMedical-0.0.4-RELEASE.jar bioMedical-0.0.4-RELEASE.jar.original
EXPOSE 80
ENTRYPOINT ["java","-jar","bioMedical-0.0.4-RELEASE.jar"]
