package com.bishe.parking.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bishe.parking.entity.po.Car;
import org.apache.ibatis.annotations.Mapper;

/**
 * 车辆 持久层
 *
 * 
 * @date: 2023-11-25
 */
@Mapper
public interface CarMapper extends BaseMapper<Car> {

}
