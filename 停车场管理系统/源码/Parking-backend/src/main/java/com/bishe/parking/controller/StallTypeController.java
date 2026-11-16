package com.bishe.parking.controller;


import com.bishe.parking.common.R;
import com.bishe.parking.entity.po.StallType;
import com.bishe.parking.service.StallTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 车位类型 控制层
 *
 * 
 * @date: 2026-03-02
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/stallType")
public class StallTypeController {

    private final StallTypeService stallTypeService;

    /**
     * 查询车位类型
     *
     * @return 车位类型
     */
    @GetMapping("/list")
    public R<List<StallType>> getList() {
        return R.success(stallTypeService.list());
    }

}

