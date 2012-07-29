<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.tools.*,com.pharos.fish.*,com.mongodb.DBObject" pageEncoding="UTF-8"%>
<%
//取cookie判断是否已登录
String coo = WebTool.getCookieValue(request.getCookies(), "fUser", "");
DBObject user = null;
if(coo.equals("")){
	String order = request.getParameter("login");
	if(order.equals("true")){
		String uName = request.getParameter("uName");
		String uPwd = request.getParameter("uPwd");
		user = Fish.login(uName, uPwd);
		if(user == null){
			out.append("登录失败! 请重新输入正确的用户名和密码.<br /><a href='index.jsp'>返回登录</a>");
			return;
		}else{
			WebTool.setCookie("fUser", uName, response);
		}
	}else{
		response.sendRedirect("index.jsp");
		return;
	}
}else{
	user = Fish.findUser(coo);
}
//计算关卡,轮数
int bigLevel = (Integer)user.get("bigLevel");
if(bigLevel == 0){
	bigLevel = 1;
}
int restTurn = 10 - (Integer)user.get("level");
boolean upgrade = false;
if(restTurn <= 0){
	restTurn = 9;
	bigLevel++;
	upgrade = true;
	user.put("level", 1);
	user.put("bigLevel", bigLevel);
}
//else if(restTurn >= 9){
//	upgrade = true;
//}
//计算鱼数
String fish = user.get("fishes").toString();
String gotfish = user.get("gotFishes").toString();
int[] fishes = new int[5];
if(upgrade || fish.equals("")){
	//更新为当前level的初始值 
	int adjust = (bigLevel<=10) ? bigLevel : 10;
	fishes[0] = 30;
	fishes[1] = 30 + (adjust-1);
	fishes[2] = 30 + (adjust-1);
	fishes[3] = 20 - (adjust-1)*2;
	fishes[4] = 10;
	StringBuilder sb = new StringBuilder();
	StringBuilder sb2 = new StringBuilder();
	for(int i = 0;i<fishes.length;i++){
		sb.append(",").append(fishes[i]);
		sb2.append(",").append("0");
	}
	sb.delete(0,1);
	sb2.delete(0,1);
	user.put("fishes", sb.toString());
	user.put("gotFishes", sb2.toString());
}else{
	String[] fs = fish.split(",");
	String[] gfs = gotfish.split(",");
	for(int i = 0;i<fishes.length;i++){
		fishes[i] = Integer.parseInt(fs[i]) - Integer.parseInt(gfs[i]);
	}
}
if(upgrade || fish.equals("")){
	Fish.save(user);
}
String n = request.getParameter("n");
int ni = 1;
if(StringUtil.isDigits(n)){
	ni = Integer.parseInt(n);
}
%>
<jsp:include page="top.jsp" flush="false" >
<jsp:param name="t" value="" /> 
</jsp:include>
第 <%=bigLevel %> 关 ,还剩余 <%=restTurn+1 %> 轮:<br />
据探测,目前所有海域内还有约 <%=fishes[1] %> 条1级小鱼, <%=fishes[2] %> 条2级鱼, <%=fishes[3] %> 条3级鱼 , <%=fishes[4] %> 条特大鱼. <br />
目前使用渔网: <%if(ni<=1) {%>普通(每次消耗1金币)<%}else{ %>超级(每次消耗2金币)<%} %>
 <a href="changeNet.jsp">更换渔网</a> <br />
点击下方目标海域发起捕鱼:
<div>
<table>
<%
int cc = 1;
for(int i=0;i<4;i++){
	out.append("<tr>");
	for(int j=0;j<3;j++){
		out.append("<td><a href='shoot.jsp?t=");
		out.append(String.valueOf(cc));
		out.append("&n=");
		out.append(String.valueOf(ni));
		out.append("'> ");
		out.append(String.valueOf(cc));
		out.append(" </a></td>");
		cc++;
	}
	out.append("</tr>");
}
%>
</table>
</div>
<jsp:include page="foot.jsp" flush="false" ></jsp:include>