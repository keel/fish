<%@ page language="java" contentType="text/html; charset=UTF-8" import="com.pharos.fish.*,com.pharos.tools.*,com.mongodb.DBObject" pageEncoding="UTF-8"%>
<%!
public static void reset(int[] fishGold){
	fishGold[0] = 0;
	fishGold[1] = 2;
	fishGold[2] = 5;
	fishGold[3] = 10;
	fishGold[4] = 50;
}
public static final int[] shootFishes(int shootWide,int[] fishes,int[] gotFishes,String[] fs,String[] gfs,int[] fishGold){
	//区间数组，用于确定捕到鱼的类型
	//start是随机起始数
	int start = 1;
	//填充fishes和gotFishes数组
	fishes[0] = Integer.parseInt(fs[0]);
	gotFishes[0] = Integer.parseInt(gfs[0]);
	for(int i = 0;i<fishes.length;i++){
		fishes[i] = Integer.parseInt(fs[i]);
		gotFishes[i] = Integer.parseInt(gfs[i]);
		start = start + gotFishes[i];
		//po[i-1] = po[i-1] + gotFishes[i];
		//po[i]= fishes[i];
	}
	int[] res = new int[shootWide];
	for (int j = 0; j < res.length; j++) {
		//取随机值对应到区间
		int r = RandomUtil.getRandomInt(start, 121);
		//System.out.println("r:"+r+" start:"+start);
		for(int i = 0;i<fishes.length;i++){
			System.out.println("fishes["+i+"]:"+fishes[i]);
		}
		//re为最终的鱼种,从0-3共4个标记
		int re = 0;
		if(r<= fishes[0]){
			re = 0;
		}else {
			for(int i = 1;i<fishes.length;i++){
				if((fishes[i-1] < r && fishes[i] >= r)){
					re = i;
					break;
				}
			}
		}
		
		//保存结果
		res[j] = re;
		gotFishes[re]++;
		//start++;
		//移动位置
		for(int i = 0;i<re;i++){
			fishes[i]++;
		}
		//System.out.println("----------");
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
	coo = Base64Coder.decodeString(coo);
	user = Fish.findUser(coo);
	if(user == null){
		response.sendRedirect("index.jsp");
		return;
	}
}
int[] fishGold = new int[5];
reset(fishGold);
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
int[] res = shootFishes(shootWide,fishes,gotFishes,fs,gfs,fishGold);
int gold = 0;
for(int i = 0;i<res.length;i++){
	gold = gold + fishGold[res[i]];
}
int cost = 1;
if(shootWide>1){
	cost = 3;
}
gold = gold - cost;
int restGold = (Integer)user.get("gold")+gold;
int topB = (Integer)user.get("topLogB");
int levelLogB = (Integer)user.get("levelLogB") + gold;
user.put("gold",restGold);
int level = (Integer)user.get("level");
int bigLevel = (Integer)user.get("bigLevel");
if(level >= 10){
	level = 1;
	bigLevel++;
	if(topB<levelLogB){
		user.put("topLogB", levelLogB);
	}
	//更新为当前level的初始值 
	//10关封顶
	int adjust = (bigLevel<11) ? bigLevel-1 : 10;
	fishes[0] = 30 + adjust + 3;
	fishes[1] = 60 + adjust + 2;
	fishes[2] = 90 + adjust + 1;
	fishes[3] = 110 + adjust;
	fishes[4] = 120;
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
	level++;
	StringBuilder sb = new StringBuilder();
	StringBuilder sb2 = new StringBuilder();
	for(int i = 0;i<fishes.length;i++){
		System.out.println("fishes["+i+"]:"+fishes[i]);
		sb.append(",").append(fishes[i]);
		sb2.append(",").append(gotFishes[i]);
	}
	//System.out.println("==========");
	sb.delete(0,1);
	sb2.delete(0,1);
	user.put("fishes", sb.toString());
	user.put("gotFishes", sb2.toString());
}
user.put("levelLogB", levelLogB);
user.put("level",level);
user.put("bigLevel",bigLevel);
Fish.save(user);
%>
<jsp:include page="top.jsp" flush="false" ></jsp:include>
<%if(gold <= 0 && shootWide == 1){%>
<div class='blueBold'>哟,这次没有捕到鱼。</div>
<%}else{ 
	//out.append("恭喜您,<br />");
	int fail = 0;
	for(int i = 0;i<res.length;i++){
		if(res[i] == 0){
			fail++;
			continue;
		}
%>
<img src="img/fish<%=String.valueOf(res[i]) %>.png" alt="fishGot" /><br />
捕到1条 <span class="redBold"><%= String.valueOf(res[i]) %></span> 级鱼,获得 <span class="redBold"><%=fishGold[res[i]] %></span> 个金币！<br />
<%}
	if(fail == 2){
		out.append("<div class='blueBold'>真不走运,这次没有捕到鱼。 </div>");
	}
	out.append("除去花费共获得 <span class='redBold'>").append(String.valueOf(gold)).append("</span> 金币！<br />");
}%>
本次捕鱼花费 <span class='redBold'><%=cost %></span>金币,目前共余有 <span class='redBold'><%=user.get("gold") %></span> 金币。<br />
[ <a href="main.jsp">再来一次</a> ]<br />
<jsp:include page="foot.jsp" flush="false" ></jsp:include>