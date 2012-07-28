<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.fish.*,com.pharos.tools.*" pageEncoding="UTF-8"%>
<%
String subTitle = (StringUtil.isStringWithLen(request.getParameter("t"), 1))?request.getParameter("t"):"";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>深海捕鱼<%=subTitle %></title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>
