<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.tools.*,com.pharos.fish.*,com.mongodb.DBObject" pageEncoding="UTF-8"%>
<%
//取cookie判断是否已登录
String coo = WebTool.getCookieValue(request.getCookies(), "fUser", "");
String netS = WebTool.getCookieValue(request.getCookies(), "net", "");
int net = (StringUtil.isDigits(netS)) ? (Integer.parseInt(netS)) : 1;
DBObject user = null;
if(coo.equals("")){
	response.sendRedirect("index.jsp");
	return;
}else{
	coo = Base64Coder.decodeString(coo);
	user = Fish.findUser(coo);
}
//计算关卡,轮数
int bigLevel = (Integer)user.get("bigLevel");
int level = (Integer)user.get("level");
if(bigLevel == 0){
	bigLevel = 1;
}
//计算鱼数
String fish = user.get("fishes").toString();
String gotfish = user.get("gotFishes").toString();
int[] showFishes = new int[5];
String[] fs = fish.split(",");
String[] gfs = gotfish.split(",");
int[] gotFishes = new int[5];
for(int i = 1;i<fs.length;i++){
	showFishes[i] = Integer.parseInt(fs[i]) - Integer.parseInt(fs[i-1]);
}
%>
<jsp:include page="top.jsp" flush="false" >
<jsp:param name="t" value="" /> 
</jsp:include>
第 <span class="blue"><%=bigLevel %></span> 关 ,还剩余 <span class="blue"><%=(11-level) %></span> 轮:<br />
据探测,目前所有海域内还有约 <span class="orange bold"><%=showFishes[1] %></span> 条1级小鱼, <span class="orange bold"><%=showFishes[2] %></span> 条2级鱼, <span class="orange bold"><%=showFishes[3] %></span> 条3级鱼 , <span class="orange bold"><%=showFishes[4] %></span> 条特大鱼. <br />
<br />
目前使用渔网: <%if(net<=1) {%>普通(每次消耗1金币)<%}else{ %>超级(每次消耗2金币)<%} %>
 <a href="changeNet.jsp">更换渔网</a> <br />
点击下方目标海域发起捕鱼:
<div>
<img alt="map" src="img/map2.jpg" />
<table width="120">
<%
int cc = 1;
for(int i=0;i<4;i++){
	out.append("<tr>");
	for(int j=0;j<3;j++){
		out.append("<td><a href='shoot.jsp?t=");
		out.append(String.valueOf(cc));
		out.append("&n=");
		out.append(String.valueOf(net));
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