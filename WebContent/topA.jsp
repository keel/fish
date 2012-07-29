<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*,com.pharos.fish.*,com.pharos.tools.*" pageEncoding="UTF-8"%>
<jsp:include page="top.jsp" flush="false" ></jsp:include>
总金币排行榜<br />
<%
ArrayList<String> ls = Fish.topA();
if(ls.isEmpty()){
	out.append("暂无排行.<br />");
}else{
	Iterator<String> it = ls.iterator();
	while(it.hasNext()){
		String s = it.next();
		out.append(s).append("<br />");
	}
}
%>
<jsp:include page="foot.jsp" flush="false" ></jsp:include>