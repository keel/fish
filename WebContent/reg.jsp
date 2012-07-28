<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.tools.*,com.pharos.fish.*,com.mongodb.DBObject" pageEncoding="UTF-8"%>
<jsp:include page="top.jsp" flush="false" >
<jsp:param name="t" value="-注册" /> 
</jsp:include>
<%
String uName = request.getParameter("uName");
String uPwd = request.getParameter("uPwd");
String handset = request.getHeader("x-up-calling-line-id");
if(StringUtil.isStringWithLen(uName, 4) && StringUtil.isStringWithLen(uPwd, 4)){
	int re = Fish.reg(uName, uPwd, handset);
	if(re == 0){
		WebTool.setCookie("fUser", uName, response);
		out.append("注册成功! <br /><a href='main.jsp'>进入游戏</a>");
	}
}else{
	out.append("注册失败! 用户名和密码必须大于4位，请重新输入. <br /><a href='index.jsp'>返回重新登录</a>");
}
%>
<jsp:include page="foot.jsp" flush="false" ></jsp:include>