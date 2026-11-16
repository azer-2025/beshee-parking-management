/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : localhost:3306
 Source Schema         : DB_Parking

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for car
-- ----------------------------
DROP TABLE IF EXISTS `car`;
CREATE TABLE `car` (
  `tid` int NOT NULL AUTO_INCREMENT COMMENT '车辆编号',
  `card` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车牌号',
  `car_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车类别',
  `person` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '用户',
  `xtime` datetime DEFAULT NULL COMMENT '录入时间',
  PRIMARY KEY (`tid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of car
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for fee
-- ----------------------------
DROP TABLE IF EXISTS `fee`;
CREATE TABLE `fee` (
  `fid` int NOT NULL AUTO_INCREMENT COMMENT '收费标准ID',
  `car_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车位类型',
  `money` double(255,2) DEFAULT NULL COMMENT '价格',
  `money_desc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '价格描述',
  `fee_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`fid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of fee
-- ----------------------------
BEGIN;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

COMMIT;

-- ----------------------------
-- Table structure for login_info
-- ----------------------------
DROP TABLE IF EXISTS `login_info`;
CREATE TABLE `login_info` (
  `yid` int NOT NULL AUTO_INCREMENT COMMENT '登录日志编号                                                                                      ',
  `person` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '用户',
  `ip` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'IP地址',
  `browser` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '浏览器',
  `os` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作系统',
  `login_time` datetime DEFAULT NULL COMMENT '登录时间',
  PRIMARY KEY (`yid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of login_info
-- ----------------------------
BEGIN;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

COMMIT;

-- ----------------------------
-- Table structure for recharge
-- ----------------------------
DROP TABLE IF EXISTS `recharge`;
CREATE TABLE `recharge` (
  `cid` int NOT NULL AUTO_INCREMENT COMMENT '充值编号',
  `person` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '用户',
  `money` double(255,2) DEFAULT NULL COMMENT '充值金额',
  `ctime` datetime DEFAULT NULL COMMENT '充值时间',
  PRIMARY KEY (`cid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of recharge
-- ----------------------------
BEGIN;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

COMMIT;

-- ----------------------------
-- Table structure for stall
-- ----------------------------
DROP TABLE IF EXISTS `stall`;
CREATE TABLE `stall` (
  `sid` int NOT NULL AUTO_INCREMENT COMMENT '车位编号',
  `stall_num` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车位号',
  `stall_area` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车位区域',
  `stall_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车位类型',
  `stall_state` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车位状态',
  `stall_money` double(255,0) DEFAULT NULL COMMENT '车位收费',
  `stall_live` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '逻辑删除标志，1为可见，0为不可见',
  `user_id` int DEFAULT NULL COMMENT '用户编号',
  PRIMARY KEY (`sid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of stall
-- ----------------------------
BEGIN;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

COMMIT;

-- ----------------------------
-- Table structure for stall_res
-- ----------------------------
DROP TABLE IF EXISTS `stall_res`;
CREATE TABLE `stall_res` (
  `pid` int NOT NULL AUTO_INCREMENT COMMENT '停车记录ID',
  `person` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '停车用户',
  `stall_id` int DEFAULT NULL COMMENT '车位编码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `over_time` datetime DEFAULT NULL COMMENT '结束时间',
  `pay_money` double(255,2) DEFAULT NULL COMMENT '缴费金额',
  PRIMARY KEY (`pid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of stall_res
-- ----------------------------
BEGIN;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

COMMIT;

-- ----------------------------
-- Table structure for stall_type
-- ----------------------------
DROP TABLE IF EXISTS `stall_type`;
CREATE TABLE `stall_type` (
  `oid` int NOT NULL COMMENT '车位类型编号',
  `otype` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车位类型',
  `omoney` double(255,0) DEFAULT NULL COMMENT '车位价格',
  PRIMARY KEY (`oid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of stall_type
-- ----------------------------
BEGIN;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `uid` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '密码',
  `nike` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '昵称',
  `age` int DEFAULT NULL COMMENT '年龄',
  `sex` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '性别',
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '联系方式',
  `card` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT '车牌号',
  `money` double(255,2) DEFAULT NULL COMMENT '余额',
  `role` int NOT NULL DEFAULT '1' COMMENT '角色。0系统管理员，1车主',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;

-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.


-- Data rows omitted from the public source snapshot.

COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
