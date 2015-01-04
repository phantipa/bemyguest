<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Welcome to be my guest!</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>
<div class="container-full">
    <div class="row">
        <div class="col-lg-12 text-center v-center">
            <h1>Be my Guest!</h1>

            <p class="lead">
                <%
                    String guestbookName = request.getParameter("guestbookName");
                    if (guestbookName == null) {
                        guestbookName = "default";
                    }
                    pageContext.setAttribute("guestbookName", guestbookName);
                    UserService userService = UserServiceFactory.getUserService();
                    User user = userService.getCurrentUser();
                    if (user != null) {
                        pageContext.setAttribute("user", user);
                %>

                Hello,
                <b>${fn:escapeXml(user.nickname)}</b>
                ! (You can <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)

                <%
                } else {
                %>

                Hello!
                <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
                to include your name with greetings you post.
                <%
                    }
                %>
            </p>
            <form class="col-lg-12" action="/sign" method="post">
                <div class="input-group input-group-lg col-sm-offset-4 col-sm-4">
                    <input type="text" class="center-block form-control input-lg" name="content" title="I wanna say.."
                           placeholder="I wanna say..">
                    <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
                    <span class="input-group-btn">
                    <button class="btn btn-lg btn-primary" type="submit">OK</button></span>
                </div>
            </form>
        </div>
    </div>
    <!-- /row -->
</div>
<!-- /container full -->
<div class="container">


    <br>
    <%--Guest Book--%>
    <div class="row">
        <%
            DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
            // Run an ancestor query to ensure we see the most up-to-date
            // view of the Greetings belonging to the selected Guestbook.
            Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
            List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(3));
            if (greetings.isEmpty()) {
        %>
        <%--<p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>--%>
        <div class="text-center">
        <p>Hooray! You'll be the first guest.</p>
        </div>
        <%
        } else {
        %>

        <ul class="list-group">
            <%--<tr><td><p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p></td></tr>--%>
            <%
                for (Entity greeting : greetings) {
                    pageContext.setAttribute("greeting_content", greeting.getProperty("content"));
                    pageContext.setAttribute("greeting_date", greeting.getProperty("date"));
            %>

            <li class="list-group-item">
                <blockquote><p>${fn:escapeXml(greeting_content)}</p>
                    <footer>
                        <%
                            if (greeting.getProperty("user") == null) {
                        %>
                        Anonymous
                        <%
                        } else {
                            pageContext.setAttribute("greeting_user", greeting.getProperty("user"));
                        %>
                        ${fn:escapeXml(greeting_user.nickname)}
                        <%
                            }
                        %>
                    </footer>
                </blockquote>
            </li>
            <%
                    }
                }
            %>
        </ul>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <br><br>
            <p class="pull-right"> &nbsp; ©Copyright 2015 <a href="mailto:phantipa.cha@gmail.com">Phantipa</a></p>
            <br><br>
        </div>
    </div>
    <%--<form action="/guestbook.jsp" method="get">
        <div><input type="text" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/></div>
        <div><input type="submit" value="Switch Guestbook"/></div>
    </form>--%>
</div>
</body>
</html>