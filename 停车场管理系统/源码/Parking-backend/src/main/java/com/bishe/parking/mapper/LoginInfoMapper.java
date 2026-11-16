package com.bishe.parking.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bishe.parking.entity.po.LoginInfo;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户登录信息 持久层
 *
 * 
 * @date: 2023-11-25
 */
@Mapper
public interface LoginInfoMapper extends BaseMapper<LoginInfo> {

}
