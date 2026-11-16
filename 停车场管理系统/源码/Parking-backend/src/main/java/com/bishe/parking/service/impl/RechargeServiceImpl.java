package com.bishe.parking.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bishe.parking.entity.po.Recharge;
import com.bishe.parking.mapper.RechargeMapper;
import com.bishe.parking.service.RechargeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 充值 服务层实现类
 *
 * 
 * @date: 2026-03-02
 */
@Service
@RequiredArgsConstructor
public class RechargeServiceImpl extends ServiceImpl<RechargeMapper, Recharge> implements RechargeService {

}
