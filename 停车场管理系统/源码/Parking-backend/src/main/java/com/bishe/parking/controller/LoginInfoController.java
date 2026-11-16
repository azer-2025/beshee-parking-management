package com.bishe.parking.controller;


import com.baomidou.mybatisplus.core.metadata.IPage;
import com.bishe.parking.common.R;
import com.bishe.parking.entity.po.LoginInfo;
import com.bishe.parking.entity.query.LoginInfoQuery;
import com.bishe.parking.service.LoginInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 登录信息 控制层
 *
 * 
 * @date: 2026-03-02
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/login-info")
public class LoginInfoController {

    private final LoginInfoService loginInfoService;

    /**
     * 获取登录用户列表
     *
     * @param loginInfoQuery 用户信息
     * @return 用户列表
     */
    @PostMapping("/getLoginInfoList")
    public R<IPage<LoginInfo>> getStallList(@RequestBody LoginInfoQuery loginInfoQuery) {
        return R.success(loginInfoService.getLoginInfoList(loginInfoQuery));
    }
}

