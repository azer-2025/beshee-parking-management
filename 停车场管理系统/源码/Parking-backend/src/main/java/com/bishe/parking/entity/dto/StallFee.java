package com.bishe.parking.entity.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 停车位费用缴费统计数据
 *
 * 
 * @date: 2026-03-02
 */
@Data
public class StallFee {

    /**
     * 名称
     */
    private LocalDateTime name;

    /**
     * 值
     */
    private Double value;

}
