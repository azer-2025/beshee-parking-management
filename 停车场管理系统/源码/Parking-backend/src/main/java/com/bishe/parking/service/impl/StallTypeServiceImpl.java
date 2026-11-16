package com.bishe.parking.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bishe.parking.entity.po.StallType;
import com.bishe.parking.mapper.StallTypeMapper;
import com.bishe.parking.service.StallTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 车位类型 服务层实现类
 *
 * 
 * @date: 2026-03-02
 */
@Service
@RequiredArgsConstructor
public class StallTypeServiceImpl extends ServiceImpl<StallTypeMapper, StallType> implements StallTypeService {

}
