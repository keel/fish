<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.tools.*" pageEncoding="UTF-8"%>
<jsp:include page="top.jsp" flush="false" ></jsp:include>
<%
String n = request.getParameter("n");
if(StringUtil.isDigits(n)){
	int ni = Integer.parseInt(n);
	if(ni>1){
		out.append("您已更换为超级渔网,每轮花费3个金币，每次开启2个海域。");
	}else{
		out.append("您已更换为普通渔网,每轮花费1个金币，每次开启1个海域。");
	}
	WebTool.setCookie("net", String.valueOf(ni), response);
	out.append("<br />[ <a href='main.jsp'>返回继续捕鱼</a> ]<br />");
}else{
%>

更换渔网：<br />
[ <a href="changeNet.jsp?n=1">普通渔网</a> ] <br />
每轮花费1个金币，每次开启1个海域。<br />
[ <a href="changeNet.jsp?n=2">超级渔网</a> ] <br />
每轮花费3个金币，每次开启2个海域。<br />
<%} %>
<jsp:include page="foot.jsp" flush="false" ></jsp:include>