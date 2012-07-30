<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.fish.*,com.pharos.tools.*" pageEncoding="UTF-8"%>
<%
String coo = WebTool.getCookieValue(request.getCookies(), "fUser", "");
if(coo.equals("")){
	response.sendRedirect("index.jsp");
	return;
}
coo = Base64Coder.decodeString(coo);
String reset = request.getParameter("reset");
if(StringUtil.isStringWithLen(reset, 1) && reset.equals("true")){
	Fish.reset(coo);
	response.sendRedirect("index.jsp");
	return;
}
%>
<jsp:include page="top.jsp" flush="false" ></jsp:include>
您选择重新开始“深海捕鱼”的旅程，所有金币和级别将重置，确认重新开始吗？<br />
[ <a href="restart.jsp?reset=true">确定</a> ]<br />
[ <a href="index.jsp">返回</a> ]<br />

<jsp:include page="foot.jsp" flush="false" ></jsp:include>