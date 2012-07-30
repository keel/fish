<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.tools.*" pageEncoding="UTF-8"%>
<%
WebTool.removeCookie("fUser", response);
WebTool.removeCookie("net", response);
%>
<jsp:include page="top.jsp" flush="false" ></jsp:include>
您已成功注销！<br />
<jsp:include page="foot.jsp" flush="false" ></jsp:include>