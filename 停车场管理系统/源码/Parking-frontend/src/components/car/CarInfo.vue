<!--
 * 预定停车位 - 现代版
 *
 * @Date: 2026-03-08
-->
<template>
    <div class="reserve-container">
        <!-- 面包屑 -->
        <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/conmenHome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>预定停车位</el-breadcrumb-item>
        </el-breadcrumb>

        <el-card class="search-card" shadow="hover">
            <el-form :inline="true" :model="queryInfo" class="search-form">
                <el-form-item label="停车区域">
                    <el-input
                        v-model="queryInfo.carArea"
                        placeholder="请输入或选择区域"
                        prefix-icon="el-icon-location-outline"
                        clearable
                    >
                    </el-input>
                </el-form-item>
                <el-form-item label="车位类型">
                    <el-select
                        v-model="queryInfo.carType"
                        placeholder="全部类型"
                        clearable
                    >
                        <el-option
                            v-for="item in carTypes"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value"
                        ></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="当前状态">
                    <el-select
                        v-model="queryInfo.carState"
                        placeholder="全部状态"
                        clearable
                    >
                        <el-option
                            v-for="item in carStates"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value"
                        ></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-button
                        type="primary"
                        icon="el-icon-search"
                        @click="getList"
                        class="search-btn"
                    >搜索车位</el-button>
                    <el-button 
                        icon="el-icon-refresh" 
                        @click="resetQuery"
                    >重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <el-card class="table-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-office-building"></i>
                    <span>实时泊位列表</span>
                </div>
                <div class="header-action">
                    <el-tag type="info" size="small">当前共计 {{ total }} 个泊位</el-tag>
                </div>
            </div>

            <!-- 车位信息表格 -->
            <el-table 
                v-loading="loading" 
                :data="cars" 
                stripe 
                highlight-current-row
                style="width: 100%"
            >
                <el-table-column
                    width="60"
                    label="#"
                    align="center"
                    type="index"
                ></el-table-column>
                
                <el-table-column label="车位编号" width="120" align="center">
                    <template slot-scope="scope">
                        <span class="stall-badge">{{ scope.row.stallNum }}</span>
                    </template>
                </el-table-column>
                
                <el-table-column
                    label="所属区域"
                    prop="stallArea"
                    min-width="180"
                >
                    <template slot-scope="scope">
                        <i class="el-icon-location-information" style="margin-right: 5px; color: #909399;"></i>
                        {{ scope.row.stallArea }}
                    </template>
                </el-table-column>
                
                <el-table-column
                    label="泊位类型"
                    width="120"
                    align="center"
                >
                    <template slot-scope="scope">
                        <el-tag :type="scope.row.stallType === '固定车位' ? 'primary' : 'info'" size="mini" effect="plain">
                            {{ scope.row.stallType }}
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column
                    label="当前状态"
                    width="120"
                    align="center"
                >
                    <template slot-scope="scope">
                        <el-tag 
                            :type="scope.row.userId ? 'danger' : 'success'" 
                            size="small"
                        >
                            <i :class="scope.row.userId ? 'el-icon-lock' : 'el-icon-check'"></i>
                            {{ scope.row.userId ? '已占用' : '空闲中' }}
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column
                    label="计费标准"
                    width="150"
                    align="center"
                >
                    <template slot-scope="scope">
                        <span class="price-text">{{ scope.row.stallMoney }}</span>
                        <span class="price-unit">元/小时</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="操作" width="150" align="center">
                    <template slot-scope="scope">
                        <el-button
                            v-if="!scope.row.userId"
                            @click="useStall(scope.row)"
                            type="warning"
                            size="mini"
                            icon="el-icon-position"
                            class="order-btn"
                        >
                            立即预定</el-button
                        >
                        <el-button
                            v-else
                            type="info"
                            size="mini"
                            icon="el-icon-circle-close"
                            disabled
                        >
                            已被预定</el-button
                        >
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
                >
                </el-pagination>
            </div>
        </el-card>

        <!-- 预定确认对话框 -->
        <el-dialog
            title="泊位预定确认"
            :visible.sync="orderDialogVisible"
            width="400px"
            center
        >
            <div class="confirm-content">
                <div class="confirm-icon">
                    <i class="el-icon-question"></i>
                </div>
                <p>确定要预定该泊位吗？</p>
                <div class="stall-details" v-if="selectedStall">
                    <div class="detail-item">
                        <span class="label">泊位编号:</span>
                        <span class="value">{{ selectedStall.stallNum }}</span>
                    </div>
                    <div class="detail-item">
                        <span class="label">所属区域:</span>
                        <span class="value">{{ selectedStall.stallArea }}</span>
                    </div>
                    <div class="detail-item">
                        <span class="label">收费标准:</span>
                        <span class="value price">{{ selectedStall.stallMoney }} 元/时</span>
                    </div>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="orderDialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="confirmOrder">确 定 预 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import axios from "axios";
export default {
    data() {
        return {
            total: 0,
            loading: true,
            queryInfo: {
                carArea: "",
                carType: null,
                carState: null,
                pagenum: 1,
                pageSize: 10,
            },
            cars: [],
            uid: undefined,
            selectedStall: null,
            orderDialogVisible: false,
            carTypes: [
                { value: null, label: "全部类型" },
                { value: "临时车位", label: "临时车位" },
                { value: "固定车位", label: "固定车位" },
            ],
            carStates: [
                { value: null, label: "全部状态" },
                { value: "已停车", label: "已停车" },
                { value: "空闲中", label: "空闲中" },
            ],
        };
    },
    methods: {
        getList() {
            this.loading = true;
            axios
                .post("/api/stall/pageStall", this.queryInfo)
                .then((res) => {
                    this.loading = false;
                    this.total = res.data.data.total;
                    this.cars = res.data.data.records;
                }).catch(() => {
                    this.loading = false;
                });
        },
        resetQuery() {
            this.queryInfo = {
                carArea: "",
                carType: null,
                carState: null,
                pagenum: 1,
                pageSize: 10,
            };
            this.getList();
        },
        handleSizeChange(newSize) {
            this.queryInfo.pageSize = newSize;
            this.getList();
        },
        handleCurrentChange(newPage) {
            this.queryInfo.pagenum = newPage;
            this.getList();
        },
        useStall(row) {
            this.selectedStall = row;
            this.orderDialogVisible = true;
        },
        confirmOrder() {
            this.orderDialogVisible = false;
            axios
                .get(
                    "/api/stall/orderStall?uid=" + this.uid + "&sid=" + this.selectedStall.sid
                )
                .then((res) => {
                    if (res.data.data) {
                        this.$message.success("预定成功！请在指定时间内入场。");
                        this.getList();
                    } else {
                        this.$message.error("预定失败，该车位可能刚被他人锁定。");
                    }
                });
        }
    },
    mounted() {
        this.uid = window.sessionStorage.getItem("token");
        this.getList();
    },
};
</script>

<style scoped lang="less">
.reserve-container {
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

.stall-badge {
    background: #f0f7ff;
    color: #409EFF;
    padding: 4px 10px;
    border-radius: 6px;
    font-weight: 700;
    font-family: monospace;
    border: 1px solid #d9ecff;
}

.price-text {
    font-size: 18px;
    font-weight: 700;
    color: #E6A23C;
}

.price-unit {
    font-size: 12px;
    color: #909399;
    margin-left: 4px;
}

.order-btn {
    font-weight: 600;
    box-shadow: 0 2px 6px rgba(230, 162, 60, 0.2);
    
    &:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(230, 162, 60, 0.3);
    }
}

.pagination-wrapper {
    margin-top: 25px;
    display: flex;
    justify-content: flex-end;
}

.confirm-content {
    text-align: center;
    padding: 10px 0;
    
    .confirm-icon {
        font-size: 60px;
        color: #E6A23C;
        margin-bottom: 15px;
    }
    
    p {
        font-size: 16px;
        font-weight: 600;
        color: #303133;
        margin-bottom: 20px;
    }
}

.stall-details {
    background: #f8f9fb;
    border-radius: 8px;
    padding: 20px;
    text-align: left;
    
    .detail-item {
        margin-bottom: 10px;
        display: flex;
        justify-content: space-between;
        
        &:last-child { margin-bottom: 0; }
        
        .label { color: #909399; font-size: 14px; }
        .value { color: #303133; font-weight: 600; }
        
        .price { color: #E6A23C; }
    }
}
</style>
