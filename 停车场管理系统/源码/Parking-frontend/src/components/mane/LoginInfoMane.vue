<!--
 * 登录日志查询 - 现代版
 *
 * @Date: 2026-03-08
-->
<template>
    <div class="login-log-container">
        <!-- 面包屑 -->
        <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/maneHome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>登录日志查询</el-breadcrumb-item>
        </el-breadcrumb>

        <!-- 搜索面板 -->
        <el-card class="search-card" shadow="hover">
            <el-form :inline="true" :model="queryInfo" class="search-form">
                <el-form-item label="操作用户">
                    <el-input
                        v-model="queryInfo.person"
                        placeholder="请输入用户名"
                        prefix-icon="el-icon-user"
                        clearable
                        @keyup.enter.native="getList"
                    ></el-input>
                </el-form-item>
                <el-form-item label="IP地址">
                    <el-input
                        v-model="queryInfo.ip"
                        placeholder="请输入IP地址"
                        prefix-icon="el-icon-monitor"
                        clearable
                        @keyup.enter.native="getList"
                    ></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-search" @click="getList">查询日志</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <!-- 数据表格 -->
        <el-card class="table-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-tickets"></i>
                    <span>系统安全登录日志</span>
                </div>
                <div class="header-stats">
                    <el-tag size="small" type="info">共计 {{ total }} 条安全记录</el-tag>
                </div>
            </div>

            <el-table 
                v-loading="loading" 
                :data="loginInfos" 
                stripe 
                style="width: 100%"
                highlight-current-row
            >
                <el-table-column label="#" width="70" align="center" type="index"></el-table-column>
                
                <el-table-column label="登录账号" width="150">
                    <template slot-scope="scope">
                        <div class="user-info">
                            <i class="el-icon-user-solid" style="margin-right: 8px; color: #409EFF;"></i>
                            <span class="username-text">{{ scope.row.person }}</span>
                        </div>
                    </template>
                </el-table-column>
                
                <el-table-column label="IP地址" width="160" align="center">
                    <template slot-scope="scope">
                        <el-tag size="small" effect="plain" type="info">
                            <i class="el-icon-location-outline"></i> {{ scope.row.ip }}
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column label="终端环境" min-width="250">
                    <template slot-scope="scope">
                        <div class="env-info">
                            <el-tooltip :content="'浏览器: ' + scope.row.browser" placement="top">
                                <el-tag size="mini" type="success" effect="light" class="env-tag">
                                    <i class="el-icon-view"></i> {{ scope.row.browser }}
                                </el-tag>
                            </el-tooltip>
                            <el-tooltip :content="'操作系统: ' + scope.row.os" placement="top">
                                <el-tag size="mini" type="warning" effect="light" class="env-tag">
                                    <i class="el-icon-cpu"></i> {{ scope.row.os }}
                                </el-tag>
                            </el-tooltip>
                        </div>
                    </template>
                </el-table-column>
                
                <el-table-column label="登录时间" width="200" align="center">
                    <template slot-scope="scope">
                        <span class="time-text">
                            <i class="el-icon-time" style="margin-right: 5px; color: #909399;"></i>
                            {{ formatDateTime(scope.row.loginTime) }}
                        </span>
                    </template>
                </el-table-column>
                
                <el-table-column label="状态" width="100" align="center">
                    <template slot-scope="scope">
                        <el-tag size="mini" type="success" effect="dark">成功</el-tag>
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
            queryInfo: {
                person: "",
                ip: "",
                pagenum: 1,
                pageSize: 10,
            },
            loginInfos: [],
        };
    },
    methods: {
        resetQuery() {
            this.queryInfo = {
                person: "",
                ip: "",
                pagenum: 1,
                pageSize: 10,
            };
            this.getList();
        },
        getList() {
            this.loading = true;
            axios
                .post("/api/login-info/getLoginInfoList", this.queryInfo)
                .then((res) => {
                    this.loading = false;
                    this.total = res.data.data.total;
                    this.loginInfos = res.data.data.records;
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
        formatDateTime(val) {
            if (!val) return "-";
            return val.replace('T', ' ');
        }
    },
    mounted() {
        this.getList();
    },
};
</script>

<style scoped lang="less">
.login-log-container {
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

.username-text {
    font-weight: 600;
    color: #303133;
}

.env-info {
    display: flex;
    gap: 8px;
    .env-tag {
        font-weight: 500;
    }
}

.time-text {
    font-family: monospace;
    font-size: 13px;
    color: #606266;
}

.pagination-wrapper {
    margin-top: 25px;
    display: flex;
    justify-content: flex-end;
}
</style>
