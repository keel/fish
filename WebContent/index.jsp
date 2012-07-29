<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.tools.*,com.pharos.fish.*,com.mongodb.DBObject" pageEncoding="UTF-8"%>
<jsp:include page="top.jsp" flush="false" > 
  <jsp:param name="t" value="" /> 
</jsp:include>
<div>[深海捕鱼]</div>
<%
//取cookie判断是否已登录
String coo = WebTool.getCookieValue(request.getCookies(), "fUser", "");
if(coo.equals("")){
%>
<div>
	游戏说明:
</div>
<form name="login" action="main.jsp?login=true" method="post">
<div>用户登录：<br />
用户名:  <input type="text" id="uName" name="uName" /><br />
密&nbsp;&nbsp;码:  <input type="text" id="uPwd" name="uPwd" /><br />
<input type="submit" name="loginSubmit" value="  快速登录  " />
</div>
</form>

<div>
	快速注册:<br />
<form name="reg" action="reg.jsp" method="post">
<div>
用户名:  <input type="text" id="uName" name="uName" /><br />
密&nbsp;&nbsp;码:  <input type="text" id="uPwd" name="uPwd" /><br />
<input type="submit" name="regSubmit" value="  快速注册  " />
</div>
</form>
</div>
<%
}else{
//如果已登录,则取得用户信息并显示,然后显示“开始游戏”
	DBObject user = Fish.findUser(coo);
	int bigLevel = (Integer)user.get("bigLevel");
	int level = (Integer)user.get("level");
	%>
<div id="userInfo">
您好，<span class="blueBold"><%=coo %></span> ,<br />
欢迎您回到“深海捕鱼”,您目前的金币数为 <span class="redBold"><%=user.get("gold") %></span> ,<br />
您目前正处于第 <span class="blueBold"><%=bigLevel %></span> 关的第 <span class="blueBold"><%=level %></span> 轮。<br />

[ <a href="main.jsp"><%if(bigLevel==1 && level==1){out.append("开始");}else{out.append("继续");} %>游戏</a> ]<br />
[ <a href="restart.jsp">全新开始</a> ]<br />
[ <a href="logout.jsp">注销用户</a> ]<br />
</div>
	<%
}
 %>
<jsp:include page="foot.jsp" flush="false" ></jsp:include>