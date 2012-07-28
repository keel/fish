<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.fish.*,com.pharos.tools.*,com.mongodb.DBObject" pageEncoding="UTF-8"%>
<%!
static final int[] fishGold = new int[5];
static{
	fishGold[0] = 0;
	fishGold[1] = 1;
	fishGold[2] = 2;
	fishGold[3] = 5;
	fishGold[4] = 10;
}
public static final int[] shootFishes(int shootWide,int[] fishes,int[] gotFishes,String[] fs,String[] gfs){
	int[] po = new int[5];
	fishes[0] = Integer.parseInt(fs[0]);
	po[0] = fishes[0] - Integer.parseInt(gfs[0]);
	for(int i = 1;i<fishes.length;i++){
		fishes[i] = Integer.parseInt(fs[i]);
		gotFishes[i] = Integer.parseInt(gfs[i]);
		po[i] = po[i-1] + fishes[i] - gotFishes[i];
	}
	
	int[] res = new int[shootWide];
	int start = 1;
	for (int j = 0; j < res.length; j++) {
		//取随机值对应到区间
		int r = RandomUtil.getRandomInt(start, 121);
		System.out.println("r:"+r);
		//re为最终的鱼种,从0-3共4个标记
		int re = 0;
		for(int i = 1;i<po.length;i++){
			if(r<= po[0] || (po[i-1] < r && po[i] >= r)){
				re = i-1;
				start++;
				break;
			}
		}
		//保存结果
		res[j] = re;
		fishes[re]--;
		gotFishes[re]++;
		if (re > 0) {
			po[re]--;
			po[0]++;
		}
	}
	
	return res;
}
%>
<%
String coo = WebTool.getCookieValue(request.getCookies(), "fUser", "");
DBObject user = null;
if(coo.equals("")){
	response.sendRedirect("index.jsp");
	return;
}else{
	user = Fish.findUser(coo);
	if(user == null){
		response.sendRedirect("index.jsp");
		return;
	}
}
//计算随机量,出结果
String fish = user.get("fishes").toString();
String gotFish = user.get("gotFishes").toString();
String net = request.getParameter("n");
//捕鱼开启的海域数
int shootWide = 1;
if(StringUtil.isDigits(net)){
	shootWide = Integer.parseInt(net);
}
String[] fs = fish.split(",");
String[] gfs = gotFish.split(",");
int[] fishes = new int[5];
int[] gotFishes = new int[5];
int[] res = shootFishes(shootWide,fishes,gotFishes,fs,gfs);
StringBuilder sb = new StringBuilder();
StringBuilder sb2 = new StringBuilder();
for(int i = 0;i<fishes.length;i++){
	sb.append(",").append(fishes[i]);
	sb2.append(",").append(gotFishes[i]);
}
sb.delete(0,1);
sb2.delete(0,1);
user.put("fishes", sb.toString());
user.put("gotFishes", sb2.toString());
int gold = 0;
for(int i = 0;i<res.length;i++){
	gold = gold + fishGold[res[i]];
}
int cost = 1;
if(shootWide>1){
	cost = 3;
}
gold = gold - cost;
user.put("gold",(Integer)user.get("gold")+gold);
int level = (Integer)user.get("level");
int bigLevel = (Integer)user.get("bigLevel");
if(level >= 10){
	level = 1;
	bigLevel++;
}else{
	level++;
}
user.put("level",level);
user.put("bigLevel",bigLevel);
Fish.save(user);
%>
<jsp:include page="top.jsp" flush="false" ></jsp:include>
<%if(gold <= 0){%>
哟,这次您没有捕到鱼。 <br />
<%}else{ 
	out.append("恭喜您,<br />");
	for(int i = 0;i<res.length;i++){
%>
捕到1条 <span class="redBold"><%= String.valueOf(res[i]) %></span> 级鱼,获得 <span class="redBold"><%=fishGold[res[i]] %></span> 个金币！<br />
<%}
	out.append("共获得 <span class='redBold'>").append(String.valueOf(gold)).append("</span> 金币！<br />");
}%>
本次捕鱼花费 <span class='redBold'><%=cost %></span>金币,目前共余有 <span class='redBold'><%=user.get("gold") %></span> 金币。<br />
[ <a href="main.jsp">再来一次</a> ]<br />
<jsp:include page="foot.jsp" flush="false" ></jsp:include>