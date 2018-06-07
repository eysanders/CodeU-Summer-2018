<%@ page import= "java.util.List" %>
<%@ page import= "codeu.model.data.Conversation" %>
<%@ page import= "codeu.model.store.basic.ConversationStore"%>
<%@ page import="codeu.model.store.basic.MessageStore"%>
<%@ page import="codeu.model.data.Message" %>
<%@ page import= "codeu.model.data.User" %>
<%@ page import= "codeu.model.store.basic.UserStore" %>
<%@ page import= "java.util.UUID" %>
<%@ page import= "codeu.model.store.persistence.PersistentDataStore" %>
<%@ page import= "com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import= "com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import= "java.lang.Object" %>
<%@ page import= "java.time.format.DateTimeFormatter" %>
<%@ page import= "java.util.Date" %>
<%@ page import= "java.time.LocalDateTime" %>
<%@ page import= "java.time.ZoneId" %>
<%@ page import= "java.time.Instant" %>
<%@ page import= "java.time.format.FormatStyle" %>
<%@ page import= "java.util.Locale" %>
<%@ page import= "java.util.HashMap" %>
<%@ page import= "java.util.Map" %>

<!DOCTYPE html>
<html>
<head>
  <title>Activity</title>
  <link rel="stylesheet" href="/css/main.css">
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <div id="container">
      <% DateTimeFormatter formatter = DateTimeFormatter.ofLocalizedDateTime( FormatStyle.SHORT ).withLocale( Locale.US ).withZone( ZoneId.systemDefault() ); %>

      <h1>Site Activity</h1>
      <p> All that's going on:</p>
      <strong> Conversations: </strong>
      <%
      List<Conversation> conversations =
        (List<Conversation>) request.getAttribute("conversations");
      List<User> users = 
        (List<User>) request.getAttribute("users");
      HashMap<UUID, String> idToName =
        (HashMap<UUID, String>) request.getAttribute("idToName");
      HashMap<UUID, String> idToTitle =
        (HashMap<UUID, String>) request.getAttribute("idToTitle");

      if(conversations == null || conversations.isEmpty()){
      %>
        <p>Aww nothing so far!</p>
      <%
      }
      else{
      %>
        <ul class="mdl-list">
      <%
        for(Conversation conversation : conversations){
      %>
         <li> 
          <% 
          String owner = (String) idToName.get(conversation.getOwnerId());
          Instant instant = conversation.getCreationTime();
          String output = formatter.format( instant ); %>
          <strong><%= output %>:</strong>
          <a href="/chat/<%= conversation.getTitle() %>">
        <%= conversation.getTitle() %></a> created by <%= owner %> 
        </li>
      <%
        }
      %>
        </ul>
      <%
      }
      %>
      <hr/>
      <strong> Users: </strong>
      <%
      if(users == null || users.isEmpty()){
      %>
        <p>Aww nothing so far!</p>
      <%
      }
      else{
      %>
        <ul class="mdl-list">
      <%
        for(User user: users){
      %>
        <li> 
         <% 
          Instant instant = user.getCreationTime();
          String output = formatter.format( instant ); %>
          <strong> <%= output %>: </strong>
          <%= user.getName() %> joined! 
        </li>
      <%
        }
      %>
      </ul>
      <%
      }
      %>
       <hr/>
      <strong> Messages: </strong>
      <%
      MessageStore messageStore = MessageStore.getInstance();
      List<Message> messages = messageStore.getAllMessages();
      if(messages == null || messages.isEmpty()){
      %>
        <p>Aww nothing so far!</p>
      <%
      }
      else{
      %>
        <ul class="mdl-list">
      <%
        for(Message message: messages){
      %>
        <li> 
         <% 
          String owner = (String) idToName.get(message.getAuthorId());
          String title = (String) idToTitle.get(message.getConversationId());
          Instant instant = message.getCreationTime();
          String output = formatter.format( instant ); %>
          <strong> <%= output %>: </strong>
          <%= owner %> sent a message in
          <a href="/chat/<%= title %>">
          <%= title %></a>
          : "<%=message.getContent()%>"
        </li>
      <%
        }
      %>
      </ul>
      <%
      }
      %>

    </div>
  </div>
</body>
</html>