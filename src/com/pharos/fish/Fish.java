/**
 * 
 */
package com.pharos.fish;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;

/**
 * 
 * @author keel
 *
 */
public class Fish {

	/**
	 * 
	 */
	public Fish() {
		
	}
	

	private static MongoConn mongo;
	
	
	
	/**
	 * 登录
	 * @param uName
	 * @param uPwd
	 * @return 登录成功返回DBObject,失败返回null
	 */
	public static final DBObject login(String uName,String uPwd){
		DBCollection coll = mongo.getColl("fUser");
		BasicDBObject q = new BasicDBObject("uName",uName).append("uPwd", uPwd);
		DBObject u = coll.findOne(q);
		return u;
	}
	
	/**
	 * 保存用户信息
	 * @param user DBObject
	 */
	public static final void save(DBObject user){
		DBCollection coll = mongo.getColl("fUser");
		coll.save(user);
	}
	
	/**
	 * 获取用户信息
	 * @param uName
	 * @return DBObject
	 */
	public static final DBObject findUser(String uName){
		DBCollection coll = mongo.getColl("fUser");
		BasicDBObject q = new BasicDBObject("uName",uName);
		DBObject u = coll.findOne(q);
		return u;
	}
	
	public static final void reset(String uName){
		DBCollection coll = mongo.getColl("fUser");
		BasicDBObject q = new BasicDBObject("uName",uName);
		DBObject user = coll.findOne(q);
		user.put("gold", 300);
		user.put("level", 1);
		user.put("bigLevel", 1);
		user.put("fishnet", 0);
		user.put("toolA", 0);
		user.put("toolB", 0);
		user.put("fishes", "30,30,30,20,10");
		user.put("gotFishes", "0,0,0,0,0");
//		user.put("topLogA", 0);
//		user.put("topLogB", 0);
		coll.save(user);
	}
	

	
	/**
	 * 用户注册
	 * @param uName
	 * @param uPwd
	 * @param handset
	 * @return 0表示成功,1用户名已存在
	 */
	public static final int reg(String uName,String uPwd,String handset){
		DBCollection coll = mongo.getColl("fUser");
		BasicDBObject q = new BasicDBObject("uName",uName);
		DBObject u = coll.findOne(q);
		if (u == null) {
			BasicDBObject user = new BasicDBObject("uName",uName).append("uPwd", uPwd);
			user.append("handset", handset);
			user.append("gold", 300);
			user.append("level", 1);
			user.append("bigLevel", 1);
			user.append("fishnet", 0);
			user.append("toolA", 0);
			user.append("toolB", 0);
			user.append("topLogA", 0);
			user.append("topLogB", 0);
			user.append("createTime", System.currentTimeMillis());
			user.append("fishes", "30,30,30,20,10");
			user.append("gotFishes", "0,0,0,0,0");
			coll.save(user);
			return 0;
		}else{
			//用户名已存在
			return 1;
		}
	}
	
	public static void init(){
		mongo = new MongoConn();
		mongo.init();
	}
	
	public static void exit(){
		mongo.exit();
	}
	
	
}
