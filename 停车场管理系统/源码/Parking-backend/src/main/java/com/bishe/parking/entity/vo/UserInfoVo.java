package com.bishe.parking.entity.vo;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * 用户信息 vo
 *
 * 
 * @date: 2026-03-02
 */
@Data
@Accessors(chain = true)
public class UserInfoVo {

    /**
     * 用户id
     */
    private Integer uid;

    /**
     * 角色id
     */
    private Integer role;

    /**
     * 状态
     */
    private Boolean state;

    /**
     * 信息
     */
    private String msg;

    public UserInfoVo() {

    }

    public UserInfoVo(Integer uid, Integer role, Boolean state, String msg) {
        this.uid = uid;
        this.role = role;
        this.state = state;
        this.msg = msg;
    }

}

