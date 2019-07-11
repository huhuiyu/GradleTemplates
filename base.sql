/* 用户授权脚本 */
GRANT ALL ON online_exam.* TO 'test-projects'@'%';
FLUSH PRIVILEGES;

/* 创建数据库脚本 */
use information_schema;
drop database if exists online_exam;
create database online_exam default charset utf8mb4 collate utf8mb4_general_ci;
use online_exam;

/* 基本功能表 */
create table tb_config
(
  cid integer auto_increment primary key not null comment '主键',
  config_key varchar(50) unique comment '配置键值',
  config_value varchar(2000) comment '配置值',
  lastupdate timestamp on update now() default now() not null comment '最后更新时间'
)comment '系统配置表';

create table tb_token_info
(
  tiid integer auto_increment primary key not null comment '主键',
  token varchar(50) not null comment '令牌',
  info_key varchar(50) comment '令牌信息key值',
  info varchar(2000) comment '令牌信息值',
  lastupdate timestamp on update now() default now() not null comment '最后更新时间',
  constraint unique_tb_tokeninfo_token_info_key unique(token,info_key)
)comment 'token信息表';

create table tb_role
(
  rid integer auto_increment primary key comment '主键',
  role_name varchar(50) unique not null comment '角色名称',
  role_info varchar(200) not null comment '角色描述',
  enable enum('y','n') default 'y' not null comment '是否启用',
  lastupdate timestamp on update now() default now() not null comment '最后更新时间'
)comment '角色信息表';

create table tb_admin
(
  aid integer auto_increment primary key not null comment '主键',
  username varchar(20) unique not null comment '登录用户名',
  password varchar(50) not null comment '登录密码',
  salt varchar(20) not null comment '密码盐',
  nickname varchar(50) not null comment '昵称',
  enable enum('y','n') default 'y' not null comment '是否启用',
  lastupdate timestamp on update now() default now() not null comment '最后更新时间'
)comment '管理员信息表';

create table tb_admin_role
(
  arid integer auto_increment primary key comment '主键',
  aid integer not null comment '管理员id',
  rid integer not null comment '角色id',
  lastupdate timestamp on update now() default now() not null comment '最后更新时间',
  constraint fk_tb_admin_role_aid foreign key(aid) references tb_admin(aid),
  constraint fk_tb_admin_role_rid foreign key(rid) references tb_role(rid),
  constraint unique_tb_admin_role_aid_rid unique(aid,rid)
)comment '管理员角色表';

/* 系统配置数据 */
/* token过期时间配置，值是分钟数 */
insert into tb_config(config_key,config_value) values('token_timeout','14400');
/* 图片校验码干扰线数量 */
insert into tb_config(config_key,config_value) values('image_code_amount',20);
/* 图片校验码长度 */
insert into tb_config(config_key,config_value) values('image_code_length',5);

/* 管理员角色信息 */
insert into tb_role(role_name,role_info) values('超级管理员','可以管理全部信息的管理员');
insert into tb_role(role_name,role_info) values('管理员','可以权限管理以外全部信息的管理员');
insert into tb_role(role_name,role_info) values('用户','可以权限应用信息的管理员');

/* 默认管理员数据,密码是admin_pwd*/
insert into tb_admin(username,password,salt,nickname) values('admin','d48dc3be25a60dafc4db503fbc36d397','JX1XRO','内置管理员');