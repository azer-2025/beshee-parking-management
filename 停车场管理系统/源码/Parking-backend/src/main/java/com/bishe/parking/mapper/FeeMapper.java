package com.bishe.parking.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bishe.parking.entity.po.Fee;
import org.apache.ibatis.annotations.Mapper;

/**
 * 车辆收费信息 持久层
 *
 * 
 * @date: 2023-11-25
 */
@Mapper
public interface FeeMapper extends BaseMapper<Fee> {

}
