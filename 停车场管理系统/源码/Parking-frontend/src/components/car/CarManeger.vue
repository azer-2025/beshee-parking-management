<!--
 * 车位管理 - 现代版
 *
 * @Date: 2026-03-08
-->
<template>
    <div class="car-manager-container">
        <!-- 面包屑 -->
        <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/maneHome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>车位信息管理</el-breadcrumb-item>
        </el-breadcrumb>

        <!-- 搜索与操作区 -->
        <el-card class="search-card" shadow="hover">
            <el-form :inline="true" :model="queryInfo" class="search-form">
                <el-form-item label="停车区域">
                    <el-input
                        v-model="queryInfo.carArea"
                        placeholder="请输入区域名称"
                        prefix-icon="el-icon-location"
                        clearable
                    ></el-input>
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
                    <el-button type="primary" icon="el-icon-search" @click="getList">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
                </el-form-item>
                
                <div class="action-btns">
                    <el-button type="success" icon="el-icon-plus" @click="addCar">新增车位</el-button>
                </div>
            </el-form>
        </el-card>

        <!-- 数据表格区 -->
        <el-card class="table-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-office-building"></i>
                    <span>车位资源列表</span>
                </div>
                <el-tag type="info" size="small">当前管理 {{ total }} 个车位</el-tag>
            </div>

            <el-table 
                v-loading="loading" 
                :data="cars" 
                stripe 
                style="width: 100%"
                highlight-current-row
            >
                <el-table-column label="#" width="60" align="center" type="index"></el-table-column>
                
                <el-table-column label="车位编号" width="120" align="center">
                    <template slot-scope="scope">
                        <span class="stall-badge">{{ scope.row.stallNum }}</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="所属区域" prop="stallArea" min-width="180">
                    <template slot-scope="scope">
                        <i class="el-icon-map-location" style="margin-right: 5px; color: #909399;"></i>
                        {{ scope.row.stallArea }}
                    </template>
                </el-table-column>
                
                <el-table-column label="车位类型" width="140" align="center">
                    <template slot-scope="scope">
                        <el-tag :type="scope.row.stallType === '固定车位' ? 'primary' : 'info'" size="mini" effect="plain">
                            {{ scope.row.stallType }}
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column label="车位状态" width="140" align="center">
                    <template slot-scope="scope">
                        <el-tag 
                            :type="scope.row.stallState === '空闲中' ? 'success' : 'danger'" 
                            size="small"
                        >
                            <i :class="scope.row.stallState === '空闲中' ? 'el-icon-check' : 'el-icon-close'"></i>
                            {{ scope.row.stallState }}
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column label="收费标准" width="150" align="center">
                    <template slot-scope="scope">
                        <span class="money-text">¥ {{ scope.row.stallMoney }}</span>
                        <span class="unit-text">/小时</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="操作" align="center" fixed="right" width="180">
                    <template slot-scope="scope">
                        <div class="table-actions">
                            <el-tooltip content="修改车位信息" placement="top">
                                <el-button
                                    size="mini"
                                    type="primary"
                                    icon="el-icon-edit"
                                    circle
                                    @click="toEdit(scope.row)"
                                ></el-button>
                            </el-tooltip>
                            
                            <el-tooltip content="删除该车位" placement="top">
                                <el-button
                                    size="mini"
                                    type="danger"
                                    icon="el-icon-delete"
                                    circle
                                    @click="carDelete(scope.row.sid)"
                                ></el-button>
                            </el-tooltip>
                        </div>
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

        <!-- 新增/编辑车位对话框 -->
        <el-dialog
            :visible.sync="dialogVisible"
            width="500px"
            center
            @close="handleClose"
            custom-class="modern-dialog"
        >
            <div slot="title" class="dialog-header">
                <i :class="isEdit ? 'el-icon-edit' : 'el-icon-circle-plus-outline'"></i>
                <span>{{ isEdit ? '修改车位信息' : '新增停车泊位' }}</span>
            </div>

            <el-form :model="carForm" :rules="registerRules" ref="carFormRef" label-width="100px" class="modern-form">
                <el-form-item label="车位编号" prop="stallNum">
                    <el-input v-model="carForm.stallNum" placeholder="如: A-001" prefix-icon="el-icon-key"></el-input>
                </el-form-item>
                
                <el-form-item label="车位区域" prop="stallArea">
                    <el-input v-model="carForm.stallArea" placeholder="如: 幸福家园小区A区" prefix-icon="el-icon-location-information"></el-input>
                </el-form-item>
                
                <el-form-item label="车位类型" prop="stallType">
                    <el-select v-model="carForm.stallType" placeholder="请选择类型" style="width: 100%">
                        <el-option
                            v-for="item in carTypesFilter"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value"
                        ></el-option>
                    </el-select>
                </el-form-item>

                <div v-if="!isEdit" class="form-notice">
                    <i class="el-icon-info"></i>
                    <span>注：新创建的车位默认状态为“空闲中”。</span>
                </div>
            </el-form>

            <span slot="footer" class="dialog-footer">
                <el-button @click="handleClose" class="dialog-btn cancel">取 消</el-button>
                <el-button type="primary" @click="handleSubmit" class="dialog-btn confirm">
                    {{ isEdit ? '保存修改' : '立即创建' }}
                </el-button>
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
            isEdit: false,
            dialogVisible: false,
            carForm: {
                sid: "",
                stallNum: "",
                stallArea: "",
                stallType: "",
            },
            registerRules: {
                stallNum: [{ required: true, message: "请输入车位编号", trigger: "blur" }],
                stallArea: [{ required: true, message: "请输入车位区域", trigger: "blur" }],
                stallType: [{ required: true, message: "请选择车位类型", trigger: "blur" }],
            },
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
    computed: {
        carTypesFilter() {
            return this.carTypes.filter(item => item.value !== null);
        }
    },
    methods: {
        getList() {
            this.loading = true;
            axios.post("/api/stall/pageStall", this.queryInfo).then((res) => {
                this.loading = false;
                this.total = res.data.data.total;
                this.cars = res.data.data.records;
            }).catch(() => { this.loading = false; });
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
        addCar() {
            this.isEdit = false;
            this.carForm = { sid: "", stallNum: "", stallArea: "", stallType: "" };
            this.dialogVisible = true;
        },
        toEdit(car) {
            this.isEdit = true;
            this.carForm = {
                sid: car.sid,
                stallArea: car.stallArea,
                stallNum: car.stallNum,
                stallType: car.stallType,
            };
            this.dialogVisible = true;
        },
        handleClose() {
            this.dialogVisible = false;
            this.$refs.carFormRef.resetFields();
        },
        handleSubmit() {
            this.$refs.carFormRef.validate((valid) => {
                if (valid) {
                    const url = this.isEdit ? "/api/stall/update" : "/api/stall/add";
                    axios.post(url, this.carForm).then((res) => {
                        if (res.data.data.flag) {
                            this.$message.success(this.isEdit ? "更新成功！" : "添加成功！");
                            this.getList();
                            this.dialogVisible = false;
                        } else {
                            this.$message.error(res.data.data.msg);
                        }
                    });
                }
            });
        },
        async carDelete(sid) {
            const re = await this.$confirm(
                "此操作将永久删除该车位信息, 是否继续?",
                "严重提示",
                {
                    confirmButtonText: "确定删除",
                    cancelButtonText: "取消",
                    type: "error",
                }
            ).catch((err) => err);
            
            if (re === "confirm") {
                axios.get("/api/stall/del?sid=" + sid).then((res) => {
                    if (res.data.data) {
                        this.$message.success("车位信息已移除");
                        this.getList();
                    } else {
                        this.$message.error("删除失败，该车位当前可能处于占用状态");
                    }
                });
            }
        },
    },
    mounted() {
        this.getList();
    },
};
</script>

<style scoped lang="less">
.car-manager-container {
    padding: 0 4px;
}

.search-card {
    border-radius: 12px;
    
    .search-form {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        gap: 10px;
        
        .el-form-item {
            margin-bottom: 0;
            margin-right: 15px;
        }
    }
    
    .action-btns {
        margin-left: auto;
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

.money-text {
    font-weight: 700;
    color: #E6A23C;
    font-size: 16px;
}

.unit-text {
    font-size: 12px;
    color: #909399;
}

.table-actions {
    display: flex;
    justify-content: center;
    gap: 12px;
}

.pagination-wrapper {
    margin-top: 25px;
    display: flex;
    justify-content: flex-end;
}

/* 对话框通用样式 */
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

.modern-form {
    padding: 10px 10px 0;
}

.form-notice {
    background-color: #fdf6ec;
    border-radius: 6px;
    padding: 12px 16px;
    margin-top: 20px;
    display: flex;
    align-items: center;
    i { color: #e6a23c; margin-right: 8px; font-size: 16px; }
    span { color: #e6a23c; font-size: 13px; }
}

.dialog-btn {
    padding: 10px 25px;
    border-radius: 8px;
    font-weight: 500;
}
</style>
