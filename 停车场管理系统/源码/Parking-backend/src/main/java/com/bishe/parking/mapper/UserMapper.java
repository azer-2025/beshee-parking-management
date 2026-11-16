package com.bishe.parking.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bishe.parking.entity.dto.DateType;
import com.bishe.parking.entity.po.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户信息 持久层
 *
 * 
 * @date: 2023-11-25
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {

    /**
     * 获取用户停车类型记录
     *
     * @param person 用户
     * @return 停车位类型
     */
    List<DateType> getUserDataType(@Param("person") String person);

    /**
     * 获取用户缴费记录
     *
     * @param person 用户
     * @return 缴费记录
     */
    List<DateType> getUserDataMoney(@Param("person") String person);
}
