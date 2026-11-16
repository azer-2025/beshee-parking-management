<!--
 * 车辆进出管理 - 现代版
 *
 * @Date: 2026-03-08
-->
<template>
    <div class="car-in-out-container">
        <!-- 面包屑 -->
        <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/maneHome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>车辆进出管理</el-breadcrumb-item>
        </el-breadcrumb>

        <!-- 搜索面板 -->
        <el-card class="search-card" shadow="hover">
            <el-form :inline="true" :model="queryInfo" class="search-form">
                <el-form-item label="车主姓名">
                    <el-input
                        v-model="queryInfo.person"
                        placeholder="输入姓名查询"
                        prefix-icon="el-icon-user"
                        clearable
                    ></el-input>
                </el-form-item>
                <el-form-item label="停车区域">
                    <el-input
                        v-model="queryInfo.stallArea"
                        placeholder="输入区域关键字"
                        prefix-icon="el-icon-location-outline"
                        clearable
                    ></el-input>
                </el-form-item>
                <el-form-item label="进出时间">
                    <el-date-picker
                        v-model="times"
                        type="datetimerange"
                        range-separator="至"
                        start-placeholder="开始时间"
                        end-placeholder="结束时间"
                        value-format="yyyy-MM-dd HH:mm:ss"
                        :picker-options="pickerOptions"
                    >
                    </el-date-picker>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-search" @click="getList">开始查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <!-- 数据表格 -->
        <el-card class="table-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-sort"></i>
                    <span>进出场实时流水</span>
                </div>
                <div class="header-stats">
                    <el-tag size="small" type="info">进出记录：{{ total }} 条</el-tag>
                </div>
            </div>

            <el-table 
                v-loading="loading" 
                :data="stallRes" 
                stripe 
                style="width: 100%"
                highlight-current-row
            >
                <el-table-column label="#" width="60" align="center" type="index"></el-table-column>
                
                <el-table-column label="车主姓名" width="120">
                    <template slot-scope="scope">
                        <div class="user-info-cell">
                            <i class="el-icon-user-solid" style="margin-right: 5px; color: #409EFF;"></i>
                            <span class="user-name">{{ scope.row.person }}</span>
                        </div>
                    </template>
                </el-table-column>
                
                <el-table-column label="进场时间" width="180" align="center">
                    <template slot-scope="scope">
                        <span class="time-text">{{ dateFormat(scope.row.createTime, 3) }}</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="离场时间" width="180" align="center">
                    <template slot-scope="scope">
                        <span v-if="scope.row.overTime" class="time-text">{{ dateFormat(scope.row.overTime, 3) }}</span>
                        <el-tag type="success" size="mini" effect="dark" v-else>
                            <i class="el-icon-loading"></i> 在场中
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column label="泊位信息" min-width="180">
                    <template slot-scope="scope">
                        <div class="stall-info">
                            <el-tag size="mini" effect="plain">{{ scope.row.stall.stallArea }}</el-tag>
                            <span class="stall-num">#{{ scope.row.stall.stallNum }}</span>
                        </div>
                    </template>
                </el-table-column>
                
                <el-table-column label="费用结算" width="140" align="right">
                    <template slot-scope="scope">
                        <div v-if="scope.row.overTime" class="fee-paid">
                            <span class="amount">¥ {{ scope.row.money.toFixed(2) }}</span>
                            <span class="status-icon"><i class="el-icon-circle-check"></i></span>
                        </div>
                        <div v-else class="fee-active">
                            <span class="amount-pending">¥ {{ feeChange(scope.row).toFixed(2) }}</span>
                            <span class="tip">预计</span>
                        </div>
                    </template>
                </el-table-column>
                
                <el-table-column label="强制结算" width="120" align="center" fixed="right">
                    <template slot-scope="scope">
                        <el-tooltip :content="scope.row.overTime ? '订单已完成' : '车辆离场手动结算'" placement="top">
                            <el-button
                                @click="opare(scope.row)"
                                :type="scope.row.overTime ? 'info' : 'warning'"
                                icon="el-icon-truck"
                                circle
                                size="mini"
                                :disabled="!!scope.row.overTime"
                            ></el-button>
                        </el-tooltip>
                    </template>
                </el-table-column>
            </el-table>

            <div class="pagination-wrapper">
                <el-pagination
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                    :current-page="queryInfo.pagenum"
                    :page-sizes="[5, 10, 20, 50]"
                    :page-size="queryInfo.pageSize"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="total"
                    background
                ></el-pagination>
            </div>
        </el-card>
    </div>
</template>

<script>
import axios from "axios";
export default {
    data() {
        return {
            total: 0,
            loading: true,
            times: null,
            queryInfo: {
                person: "",
                stallArea: "",
                inTime: "",
                outTime: "",
                pagenum: 1,
                pageSize: 10,
            },
            stallRes: [],
            pickerOptions: {
                shortcuts: [{
                    text: '最近一周',
                    onClick(picker) {
                        const end = new Date();
                        const start = new Date();
                        start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
                        picker.$emit('pick', [start, end]);
                    }
                }, {
                    text: '最近一个月',
                    onClick(picker) {
                        const end = new Date();
                        const start = new Date();
                        start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
                        picker.$emit('pick', [start, end]);
                    }
                }]
            }
        };
    },
    methods: {
        resetQuery() {
            this.times = null;
            this.queryInfo = {
                person: "",
                stallArea: "",
                inTime: "",
                outTime: "",
                pagenum: 1,
                pageSize: 10,
            };
            this.getList();
        },
        getList() {
            this.loading = true;
            if (this.times && this.times.length === 2) {
                this.queryInfo.inTime = this.times[0];
                this.queryInfo.outTime = this.times[1];
            } else {
                this.queryInfo.inTime = "";
                this.queryInfo.outTime = "";
            }
            axios.post("/api/stall/allList", this.queryInfo).then((res) => {
                this.loading = false;
                this.total = res.data.data.total;
                this.stallRes = res.data.data.records;
            }).catch(() => { this.loading = false; });
        },
        handleSizeChange(newSize) {
            this.queryInfo.pageSize = newSize;
            this.getList();
        },
        handleCurrentChange(newPage) {
            this.queryInfo.pagenum = newPage;
            this.getList();
        },
        feeChange(stallRes) {
            let startTime = new Date(stallRes.createTime);
            let endTime = new Date();
            let hours = (endTime.getTime() - startTime.getTime()) / 3600000;
            return Math.max(0.1, (Math.floor(hours * 10) / 10) * stallRes.stall.stallMoney);
        },
        async opare(stallRes) {
            const re = await this.$confirm(
                `确认车主 [${stallRes.person}] 的车辆已驶出并执行手动扣费结算吗？`,
                "离场结算确认",
                {
                    confirmButtonText: "确定结算",
                    cancelButtonText: "取消",
                    type: "warning",
                    center: true
                }
            ).catch((err) => err);

            if (re === "confirm") {
                let oa = {
                    pid: stallRes.pid,
                    person: stallRes.person,
                    stallId: stallRes.stallId,
                    money: this.feeChange(stallRes)
                };
                axios.post("/api/stall/payMoney", oa).then((res) => {
                    if (res.data.data) {
                        this.$message.success("结算成功，订单已关闭");
                        this.getList();
                    } else {
                        this.$message.error("结算失败，请检查用户余额或网络连接");
                    }
                });
            }
        },
        dateFormat(val, timeType) {
            if (!val) return "-";
            let date = new Date(val);
            let Y = date.getFullYear();
            let M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1);
            let D = date.getDate() < 10 ? '0' + date.getDate() : date.getDate();
            let h = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
            let m = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
            let s = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds();
            
            if (timeType === 3) return `${Y}-${M}-${D} ${h}:${m}:${s}`;
            return `${Y}-${M}-${D}`;
        },
    },
    mounted() {
        this.getList();
    },
};
</script>

<style scoped lang="less">
.car-in-out-container {
    padding: 0 4px;
}

.search-card {
    border-radius: 12px;
    .search-form {
        margin-top: 10px;
    }
}

.table-card {
    .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        .header-title {
            display: flex;
            align-items: center;
            font-weight: 700;
            font-size: 18px;
            i { margin-right: 10px; font-size: 20px; color: #409EFF; }
        }
    }
}

.user-info-cell {
    .user-name { font-weight: 600; color: #303133; }
}

.time-text {
    font-family: monospace;
    color: #606266;
    font-size: 13px;
}

.stall-info {
    display: flex;
    align-items: center;
    gap: 8px;
    .stall-num {
        font-weight: 700;
        color: #409EFF;
        font-family: monospace;
    }
}

.fee-paid {
    color: #67C23A;
    font-weight: 700;
    .amount { font-size: 15px; }
    .status-icon { margin-left: 4px; font-size: 14px; }
}

.fee-active {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    .amount-pending {
        color: #F56C6C;
        font-weight: 700;
        font-size: 15px;
    }
    .tip { font-size: 11px; color: #909399; }
}

.pagination-wrapper {
    margin-top: 25px;
    display: flex;
    justify-content: flex-end;
}
</style>
