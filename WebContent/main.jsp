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
%>
<jsp:include page="top.jsp" flush="false" >
<jsp:param name="t" value="" /> 
</jsp:include>
第 <span class="blue"><%=bigLevel %></span> 关 ,还剩余 <span class="blue"><%=restTurn+1 %></span> 轮:<br />
据探测,目前所有海域内还有约 <span class="orange bold"><%=fishes[1] %></span> 条1级小鱼, <span class="orange bold"><%=fishes[2] %></span> 条2级鱼, <span class="orange bold"><%=fishes[3] %></span> 条3级鱼 , <span class="orange bold"><%=fishes[4] %></span> 条特大鱼. <br />
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