<!--
 * 车位费用设置 - 现代版
 *
 * @Date: 2026-03-08
-->
<template>
    <div class="money-setting-container">
        <!-- 面包屑 -->
        <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/maneHome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>车位费用设置</el-breadcrumb-item>
        </el-breadcrumb>

        <!-- 搜索面板 -->
        <el-card class="search-card" shadow="hover">
            <el-form :inline="true" class="search-form">
                <el-form-item label="车位类型">
                    <el-input
                        v-model="carType"
                        placeholder="请输入车位类型搜索"
                        prefix-icon="el-icon-price-tag"
                        clearable
                        @keyup.enter.native="getList"
                    ></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-search" @click="getList">搜索</el-button>
                    <el-button icon="el-icon-refresh" @click="carType = ''; getList()">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <!-- 数据表格 -->
        <el-card class="table-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-coin"></i>
                    <span>计费标准配置</span>
                </div>
            </div>

            <el-table 
                v-loading="loading" 
                :data="fees" 
                stripe 
                style="width: 100%"
            >
                <el-table-column label="#" width="80" align="center" type="index"></el-table-column>
                
                <el-table-column label="车位类型" width="180">
                    <template slot-scope="scope">
                        <el-tag :type="scope.row.carType === '固定车位' ? 'primary' : 'success'" effect="dark">
                            {{ scope.row.carType }}
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column label="计费价格" width="180" align="center">
                    <template slot-scope="scope">
                        <span class="price-value">¥ {{ scope.row.money }}</span>
                        <span class="price-unit">/ 小时</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="说明" prop="moneyDesc" min-width="250">
                    <template slot-scope="scope">
                        <span class="desc-text">{{ scope.row.moneyDesc || '暂无详细说明' }}</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="配置时间" width="200" align="center">
                    <template slot-scope="scope">
                        <i class="el-icon-time" style="margin-right: 5px; color: #909399;"></i>
                        <span class="time-text">{{ dateFormat(scope.row.feeTime, 3) }}</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="操作" width="120" align="center" fixed="right">
                    <template slot-scope="scope">
                        <el-tooltip content="编辑价格配置" placement="top">
                            <el-button
                                @click="toEdit(scope.row)"
                                type="primary"
                                icon="el-icon-edit-outline"
                                circle
                                size="small"
                            ></el-button>
                        </el-tooltip>
                    </template>
                </el-table-column>
            </el-table>
        </el-card>

        <!-- 编辑对话框 -->
        <el-dialog
            :visible.sync="feeShow"
            width="450px"
            center
            @close="editClose"
            custom-class="modern-dialog"
        >
            <div slot="title" class="dialog-header">
                <i class="el-icon-edit-outline"></i>
                <span>调整车位价格</span>
            </div>

            <el-form :model="feeEdit" label-width="100px" class="modern-form">
                <el-form-item label="车位类型">
                    <el-input v-model="feeEdit.carType" disabled prefix-icon="el-icon-collection-tag"></el-input>
                </el-form-item>
                
                <el-form-item label="收费标准" required>
                    <el-input-number 
                        v-model="feeEdit.money" 
                        :precision="2" 
                        :step="1" 
                        :min="0"
                        style="width: 100%"
                        controls-position="right"
                    ></el-input-number>
                    <div class="input-tip">单位：元/小时</div>
                </el-form-item>
                
                <el-form-item label="价格说明">
                    <el-input 
                        type="textarea" 
                        v-model="feeEdit.moneyDesc" 
                        placeholder="请输入该类型价格的适用场景或备注信息"
                        :rows="3"
                    ></el-input>
                </el-form-item>
            </el-form>

            <span slot="footer" class="dialog-footer">
                <el-button @click="editClose" class="dialog-btn">取 消</el-button>
                <el-button type="primary" @click="editCon" class="dialog-btn confirm">确认更新配置</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import axios from "axios";
export default {
    data() {
        return {
            loading: true,
            carType: "",
            fees: [],
            feeShow: false,
            feeEdit: {
                carType: "",
                money: 0,
                moneyDesc: "",
            },
        };
    },
    methods: {
        getList() {
            this.loading = true;
            axios.get("/api/fee/list?carType=" + this.carType).then((res) => {
                this.loading = false;
                this.fees = res.data.data;
            }).catch(() => { this.loading = false; });
        },
        toEdit(row) {
            this.feeEdit.carType = row.carType;
            this.feeEdit.money = row.money;
            this.feeEdit.moneyDesc = row.moneyDesc;
            this.feeShow = true;
        },
        editClose() {
            this.feeShow = false;
        },
        editCon() {
            if (this.feeEdit.money < 0) {
                return this.$message.error("价格不能为负数");
            }
            axios.post("/api/fee/update", this.feeEdit).then((res) => {
                if (res.data.data.flag) {
                    this.$message.success("计费标准已成功更新");
                    this.getList();
                    this.feeShow = false;
                } else {
                    this.$message.error(res.data.data.msg);
                }
            });
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
.money-setting-container {
    padding: 0 4px;
}

.search-card {
    border-radius: 12px;
    .search-form { margin-top: 10px; }
}

.card-header {
    display: flex;
    align-items: center;
    .header-title {
        display: flex;
        align-items: center;
        font-weight: 700;
        font-size: 18px;
        i { margin-right: 10px; font-size: 20px; color: #409EFF; }
    }
}

.price-value {
    font-size: 18px;
    font-weight: 700;
    color: #E6A23C;
}

.price-unit {
    font-size: 12px;
    color: #909399;
    margin-left: 4px;
}

.desc-text {
    color: #606266;
    font-size: 14px;
}

.time-text {
    font-family: monospace;
    font-size: 13px;
    color: #909399;
}

/* 对话框美化 */
.modern-dialog /deep/ .el-dialog__header {
    padding: 24px 30px;
    border-bottom: 1px solid #f0f0f0;
    margin: 0;
}

.dialog-header {
    display: flex;
    align-items: center;
    font-size: 18px;
    font-weight: 700;
    color: #1a1a1a;
    i { font-size: 24px; color: #409EFF; margin-right: 12px; }
}

.modern-form { padding: 15px 15px 0; }

.input-tip {
    font-size: 12px;
    color: #909399;
    margin-top: 4px;
    line-height: 1;
}

.dialog-btn {
    padding: 10px 25px;
    border-radius: 8px;
    
    &.confirm {
        background: linear-gradient(135deg, #409EFF, #0052d9);
        border: none;
        color: white;
        &:hover { opacity: 0.9; transform: translateY(-1px); }
    }
}
</style>
