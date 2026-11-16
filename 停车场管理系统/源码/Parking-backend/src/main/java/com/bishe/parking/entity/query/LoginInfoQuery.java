package com.bishe.parking.entity.query;

import lombok.Data;

/**
 * 用户信息 查询对象
 *
 * 
 * @date: 2026-03-02
 */
@Data
public class LoginInfoQuery {

    /**
     * 用户名
     */
    private String person;

    /**
     * ip
     */
    private String ip;

    /**
     * 分页大小
     */
    private Integer pageSize;

    /**
     * 分页页数
     */
    private Integer pagenum;

}
