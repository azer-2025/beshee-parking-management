package com.bishe.parking.entity.query;


import lombok.Data;

/**
 * 车辆信息 查询对象
 *
 * 
 * @date: 2026-03-02
 */
@Data
public class CarQuery {

    /**
     * 人员
     */
    private String person;

    /**
     * 车辆类型
     */
    private String carType;

    /**
     * 证件号码
     */
    private String card;

    /**
     * 分页页码
     */
    private Integer pagenum;

    /**
     * 分页大小
     */
    private Integer pageSize;

}
