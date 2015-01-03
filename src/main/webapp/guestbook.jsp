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

<%--<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Welcome to Balenda!</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>

<div class="jumbotron" style=" text-align: center;">
    <h1>Be my Guest!</h1>
</div>
<div class="container">

    <div class="row">
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

        <p>Hello,
            <mark>${fn:escapeXml(user.nickname)}</mark>
            ! (You can
            <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)
        </p>
        <%
        } else {
        %>

        <p>Hello!
            <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
            to include your name with greetings you post.
        </p>
    </div>
    <%
        }
    %>

    <%--Guest Book--%>
    <div class="row">
        <%
            DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
            // Run an ancestor query to ensure we see the most up-to-date
            // view of the Greetings belonging to the selected Guestbook.
            Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
            List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
            if (greetings.isEmpty()) {
        %>
        <%--<p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>--%>
        <p>Guestbook has no messages.</p>


        <%
        } else {
        %>

        <ul class="list-group">
            <%--<tr><td><p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p></td></tr>--%>

            <%
                for (Entity greeting : greetings) {
                    pageContext.setAttribute("greeting_content", greeting.getProperty("content"));

                    pageContext.setAttribute("greeting_date", greeting.getProperty("date"));

                    if (greeting.getProperty("user") == null) {
            %>
            <li class="list-group-item"><p>An anonymous person wrote:</p>

                    <%
            } else {
                pageContext.setAttribute("greeting_user", greeting.getProperty("user"));
            %>
            <li class="list-group-item"><p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>

                <%
                    }
                %>

                <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            </li>
            <%--<blockquote>${fn:escapeXml(greeting_date)}</blockquote>--%>
            <%
                    }
                }
            %>
        </ul>

    </div>

    <form action="/sign" method="post">
        <div class="form-group">
            <input type="content" class="form-control" name="content" id="exampleInputEmail1"
                   placeholder="I wanna say..">
            <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Post Greeting</button>

    </form>
    <%--End Guest Book--%>

    <%--<form action="/guestbook.jsp" method="get">
        <div><input type="text" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/></div>
        <div><input type="submit" value="Switch Guestbook"/></div>
    </form>--%>
</div>
</body>
</html>