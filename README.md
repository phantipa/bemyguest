Be my Guest
===========

Be my Guest is a simple app that lets the user post a greeting.

####Content

[Reference](https://github.com/phantipa/bemyguest#reference)


[Note](https://github.com/phantipa/bemyguest#note)


[3 Easy steps to Build, Run and Deploy](https://github.com/phantipa/bemyguest#easy-steps)


[Demo](https://github.com/phantipa/bemyguest#demo)

Reference
---------
* [Java 7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
* [Maven 3.1.X](http://maven.apache.org/docs/3.1.1/release-notes.html)
* [Bootstrap 3](http://getbootstrap.com/) a front-end framework including CSS, HTML and support for responsive layouts.
* [Google App Engine](https://cloud.google.com/appengine/docs/java/) a Platform as a Service.
* [Google Developers Console](https://console.developers.google.com/) supports all the Cloud Platform products.

Note
----
* You'll need [create a new project](https://console.developers.google.com/project) to get an application ID (project ID) in order to **deploy** your app to production App Engine.
* First **deploying**, login needs [app password](https://security.google.com/settings/security/apppasswords?pli=1).
* App Engine does not yet support Java8, so you should compile under Java7.

3 Easy steps to Build, Run and Deploy
-------------------------------------
        mvn clean install
        mvn appengine:devserver
        mvn appengine:update

Demo
----
http://ascendant-line-806.appspot.com/





 
