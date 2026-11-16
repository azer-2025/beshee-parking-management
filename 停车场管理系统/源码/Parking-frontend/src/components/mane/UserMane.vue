<!--
 * 用户信息管理 - 现代版
 *
 * @Date: 2026-03-08
-->
<template>
    <div class="user-management-container">
        <!-- 面包屑 -->
        <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/maneHome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>用户信息管理</el-breadcrumb-item>
        </el-breadcrumb>

        <!-- 搜索与操作区 -->
        <el-card class="search-card" shadow="hover">
            <el-form :inline="true" :model="queryInfo" class="search-form">
                <el-form-item label="用户名">
                    <el-input
                        v-model="queryInfo.username"
                        placeholder="请输入用户名"
                        prefix-icon="el-icon-user"
                        clearable
                    ></el-input>
                </el-form-item>
                <el-form-item label="姓名">
                    <el-input
                        v-model="queryInfo.nike"
                        placeholder="请输入真实姓名"
                        prefix-icon="el-icon-postcard"
                        clearable
                    ></el-input>
                </el-form-item>
                <el-form-item label="车牌号">
                    <el-input
                        v-model="queryInfo.card"
                        placeholder="请输入车牌号"
                        prefix-icon="el-icon-truck"
                        clearable
                    ></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-search" @click="getList">搜索</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
                </el-form-item>
                
                <div class="action-btns">
                    <el-button type="success" icon="el-icon-plus" @click="addUser">新增用户</el-button>
                    <el-button type="warning" icon="el-icon-coin" @click="feeUserShow = true">快速充值</el-button>
                </div>
            </el-form>
        </el-card>

        <!-- 数据表格区 -->
        <el-card class="table-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-user"></i>
                    <span>注册用户列表</span>
                </div>
                <el-tag type="info" size="small">共计 {{ total }} 名用户</el-tag>
            </div>

            <el-table 
                v-loading="loading" 
                :data="users" 
                stripe 
                style="width: 100%"
                highlight-current-row
            >
                <el-table-column label="#" width="60" align="center" type="index"></el-table-column>
                
                <el-table-column label="账户信息" min-width="150">
                    <template slot-scope="scope">
                        <div class="user-cell">
                            <el-avatar :size="32" icon="el-icon-user" class="user-avatar"></el-avatar>
                            <div class="user-detail">
                                <div class="username">{{ scope.row.username }}</div>
                                <el-tag v-if="scope.row.username === 'admin'" size="mini" type="danger" effect="plain">系统管理员</el-tag>
                            </div>
                        </div>
                    </template>
                </el-table-column>
                
                <el-table-column label="真实姓名" prop="nike" width="120" align="center"></el-table-column>
                
                <el-table-column label="性别" width="80" align="center">
                    <template slot-scope="scope">
                        <el-tag :type="scope.row.sex === '男' ? '' : 'danger'" size="mini" effect="light">
                            {{ scope.row.sex }}
                        </el-tag>
                    </template>
                </el-table-column>
                
                <el-table-column label="联系方式" prop="phone" width="130" align="center"></el-table-column>
                
                <el-table-column label="绑定车牌" width="120" align="center">
                    <template slot-scope="scope">
                        <span v-if="scope.row.card" class="card-text">{{ scope.row.card }}</span>
                        <span v-else class="empty-text">未绑定</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="账户余额" width="120" align="center">
                    <template slot-scope="scope">
                        <span class="balance-text">¥ {{ (scope.row.money || 0).toFixed(2) }}</span>
                    </template>
                </el-table-column>
                
                <el-table-column label="操作" align="center" fixed="right" width="220">
                    <template slot-scope="scope">
                        <div class="table-actions">
                            <el-tooltip content="编辑用户信息" placement="top">
                                <el-button
                                    size="mini"
                                    type="primary"
                                    icon="el-icon-edit"
                                    circle
                                    @click="toEdit(scope.row)"
                                    :disabled="scope.row.username === 'admin' && userInfo.username !== 'admin'"
                                ></el-button>
                            </el-tooltip>
                            
                            <el-tooltip content="重置登录密码" placement="top">
                                <el-button
                                    size="mini"
                                    type="warning"
                                    icon="el-icon-key"
                                    circle
                                    @click="rePassword(scope.row.uid)"
                                    :disabled="scope.row.username === 'admin'"
                                ></el-button>
                            </el-tooltip>
                            
                            <el-tooltip content="删除该用户" placement="top">
                                <el-button
                                    size="mini"
                                    type="danger"
                                    icon="el-icon-delete"
                                    circle
                                    @click="userDelete(scope.row.uid)"
                                    :disabled="scope.row.username === 'admin'"
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

        <!-- 修改用户对话框 -->
        <el-dialog
            title="编辑用户信息"
            :visible.sync="editShow"
            width="500px"
            center
            @close="editClose"
        >
            <el-form :model="editUser" :rules="editRules" ref="editRules" label-width="80px" class="dialog-form">
                <div class="form-grid">
                    <el-form-item label="姓名" prop="nike">
                        <el-input v-model="editUser.nike"></el-input>
                    </el-form-item>
                    <el-form-item label="性别">
                        <el-radio-group v-model="editUser.sex">
                            <el-radio label="男">男</el-radio>
                            <el-radio label="女">女</el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label="年龄" prop="age">
                        <el-input-number v-model.number="editUser.age" :min="18" :max="120" style="width: 100%"></el-input-number>
                    </el-form-item>
                    <el-form-item label="余额" prop="money">
                        <el-input-number v-model.number="editUser.money" :precision="2" :step="100" style="width: 100%"></el-input-number>
                    </el-form-item>
                </div>
                <el-form-item label="联系电话" prop="phone">
                    <el-input v-model="editUser.phone" prefix-icon="el-icon-phone"></el-input>
                </el-form-item>
                <el-form-item label="车牌号码" prop="card">
                    <el-input v-model="editUser.card" prefix-icon="el-icon-truck"></el-input>
                </el-form-item>
                <el-form-item label="登录密码" prop="password">
                    <el-input v-model="editUser.password" show-password placeholder="若不修改请保持原样"></el-input>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="editClose">取 消</el-button>
                <el-button type="primary" @click="editCommit('editRules')">保存修改</el-button>
            </span>
        </el-dialog>

        <!-- 新增用户对话框 -->
        <el-dialog
            :visible.sync="addShow"
            width="600px"
            center
            @close="addClose"
            custom-class="modern-dialog"
        >
            <div slot="title" class="dialog-header">
                <i class="el-icon-circle-plus-outline"></i>
                <span>新增系统注册用户</span>
            </div>

            <el-form :model="registerUser" :rules="registerRules" ref="registerRules" label-width="100px" class="modern-form">
                <el-row :gutter="25">
                    <el-col :span="12">
                        <el-form-item label="用户名" prop="username">
                            <el-input v-model="registerUser.username" placeholder="登录账号" prefix-icon="el-icon-user"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="初始密码" prop="password">
                            <el-input v-model="registerUser.password" show-password placeholder="6-15位密码" prefix-icon="el-icon-lock"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-row :gutter="25">
                    <el-col :span="12">
                        <el-form-item label="真实姓名" prop="nike">
                            <el-input v-model="registerUser.nike" placeholder="用户姓名" prefix-icon="el-icon-postcard"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="用户性别">
                            <el-radio-group v-model="registerUser.sex" class="gender-radio">
                                <el-radio-button label="男">男</el-radio-button>
                                <el-radio-button label="女">女</el-radio-button>
                            </el-radio-group>
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-row :gutter="25">
                    <el-col :span="12">
                        <el-form-item label="用户年龄" prop="age">
                            <el-input-number v-model.number="registerUser.age" :min="18" :max="100" controls-position="right" style="width: 100%"></el-input-number>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="联系电话" prop="phone">
                            <el-input v-model="registerUser.phone" placeholder="手机号码" prefix-icon="el-icon-phone"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-form-item label="车牌号码" prop="card">
                    <el-input v-model="registerUser.card" placeholder="输入完整车牌号 (如: 粤B12345)" prefix-icon="el-icon-truck"></el-input>
                </el-form-item>
                
                <div class="form-notice">
                    <i class="el-icon-info"></i>
                    <span>注：带有 * 的为必填项，初始余额默认为 0.00 元。</span>
                </div>
            </el-form>

            <span slot="footer" class="dialog-footer">
                <el-button @click="addClose" class="dialog-btn cancel">取 消</el-button>
                <el-button type="primary" @click="submitForm('registerRules')" class="dialog-btn confirm">立即创建用户</el-button>
            </span>
        </el-dialog>

        <!-- 快速充值对话框 -->
        <el-dialog
            title="管理员手动充值"
            :visible.sync="feeUserShow"
            width="420px"
            center
            @close="feeUserShow = false"
        >
            <div class="recharge-header">
                <i class="el-icon-bank-card"></i>
                <p>请仔细核对充值账号，充值后不可撤回</p>
            </div>
            <el-form :model="feeUser" :rules="feeUserRules" ref="feeUserRules" label-width="70px">
                <el-form-item label="用户名" prop="username">
                    <el-input v-model="feeUser.username" placeholder="请输入要充值的用户名"></el-input>
                </el-form-item>
                <el-form-item label="金额" prop="money">
                    <el-input-number v-model="feeUser.money" :precision="2" :step="100" :min="1" style="width: 100%"></el-input-number>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="feeUserShow = false">取 消</el-button>
                <el-button type="primary" @click="feeUserCon('feeUserRules')">确认充值</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import axios from "axios";
export default {
    data() {
        var checkUsername = (rule, value, callback) => {
            if (!value) {
                return callback(new Error("用户名不能为空"));
            }
            setTimeout(() => {
                axios
                    .get("/api/user/checkUsername?username=" + value)
                    .then((res) => {
                        if (!res.data.data) {
                            callback(new Error("用户名已存在"));
                        } else {
                            callback();
                        }
                    });
            }, 10);
        };
        var checkAge = (rule, value, callback) => {
            if (!value) {
                return callback(new Error("年龄不能为空"));
            }
            if (!Number.isInteger(value)) {
                callback(new Error("请输入数字值"));
            } else {
                if (value < 18) {
                    callback(new Error("必须年满18岁"));
                } else {
                    callback();
                }
            }
        };
        return {
            total: 0,
            loading: true,
            queryInfo: {
                username: "",
                nike: "",
                card: "",
                pagenum: 1,
                pageSize: 10,
            },
            users: [],
            userInfo: { // 用于判断当前登录用户权限
                username: ''
            },
            editUser: {
                password: "",
                nike: "",
                sex: "",
                age: "",
                phone: "",
                money: "",
                card: "",
            },
            registerUser: {
                username: "",
                password: "",
                nike: "",
                sex: "男",
                age: 18,
                phone: "",
                card: ""
            },
            addShow: false,
            editShow: false,
            editRules: {
                nike: [{ required: true, message: "请输入姓名", trigger: "blur" }],
                password: [
                    { required: true, message: "请输入密码", trigger: "blur" },
                    { min: 6, max: 15, message: "长度在 6 到 15 个字符", trigger: "blur" },
                ],
                age: [{ required: true, validator: checkAge, trigger: "blur" }],
                phone: [{ required: true, message: "请输入联系电话", trigger: "blur" }],
                card: [{ required: true, message: "请输入车牌号", trigger: "blur" }],
            },
            registerRules: {
                username: [{ required: true, validator: checkUsername, trigger: "blur" }],
                password: [
                    { required: true, message: "请输入密码", trigger: "blur" },
                    { min: 6, max: 15, message: "长度在 6 到 15 个字符", trigger: "blur" },
                ],
                nike: [{ required: true, message: "请输入姓名", trigger: "blur" }],
                age: [{ required: true, validator: checkAge, trigger: "blur" }],
                phone: [{ required: true, message: "请输入联系电话", trigger: "blur" }],
                card: [{ required: true, message: "请输入车牌号", trigger: "blur" }],
            },
            feeUserShow: false,
            feeUserRules: {
                username: [{ required: true, message: "请输入用户名", trigger: "blur" }],
                money: [{ required: true, message: "请输入金额", trigger: "blur" }],
            },
            feeUser: {
                username: "",
                money: 100,
            },
        };
    },
    methods: {
        resetQuery() {
            this.queryInfo = {
                username: "",
                nike: "",
                card: "",
                pagenum: 1,
                pageSize: 10,
            };
            this.getList();
        },
        feeUserCon(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    axios.post("/api/fee/userFee", this.feeUser).then((res) => {
                        if (res.data.data.flag) {
                            this.$message.success("账户充值成功！");
                            this.feeUserShow = false;
                            this.getList();
                            this.feeUser = { username: "", money: 100 };
                        } else {
                            this.$message.error(res.data.data.msg);
                        }
                    });
                }
            });
        },
        getList() {
            this.loading = true;
            axios.post("/api/user/getUsers", this.queryInfo).then((res) => {
                this.loading = false;
                this.total = res.data.data.total;
                this.users = res.data.data.records;
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
        addUser() {
            this.registerUser = {
                username: "",
                password: "",
                nike: "",
                sex: "男",
                age: 18,
                phone: "",
                card: ""
            };
            this.addShow = true;
        },
        editClose() {
            this.editShow = false;
            this.$refs.editRules.resetFields();
        },
        toEdit(user) {
            this.editUser = JSON.parse(JSON.stringify(user)); // 深拷贝
            this.editShow = true;
        },
        editCommit(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    axios.post("/api/user/update", this.editUser).then((res) => {
                        if (res.data.flag) {
                            this.$message.success("用户信息修改成功！");
                            this.getList();
                            this.editShow = false;
                        } else {
                            this.$message.error("修改失败，请重试！");
                        }
                    });
                }
            });
        },
        async userDelete(uid) {
            const re = await this.$confirm(
                "此操作将永久删除该用户及其所有相关停车记录, 是否继续?",
                "严重提示",
                {
                    confirmButtonText: "确定删除",
                    cancelButtonText: "取消",
                    type: "error",
                }
            ).catch((err) => err);

            if (re === "confirm") {
                axios.get("/api/user/del?uid=" + uid).then((res) => {
                    if (res.data.data) {
                        this.$message.success("用户已成功移除");
                        this.getList();
                    } else {
                        this.$message.error("删除失败，该用户可能存在未完成订单");
                    }
                });
            }
        },
        async rePassword(uid) {
            const re = await this.$confirm(
                "重置该用户的密码为初始密码 (通常为123456), 是否继续?",
                "密码重置提示",
                {
                    confirmButtonText: "确定重置",
                    cancelButtonText: "取消",
                    type: "warning",
                }
            ).catch((err) => err);

            if (re === "confirm") {
                axios.get("/api/user/resetPassword?uid=" + uid).then((res) => {
                    if (res.data.data) {
                        this.$message.success("密码重置成功");
                    } else {
                        this.$message.error("重置操作失败");
                    }
                });
            }
        },
        addClose() {
            this.addShow = false;
            this.$refs.registerRules.resetFields();
        },
        submitForm(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    this.loading = true;
                    axios.post("/api/user/register", this.registerUser).then((res) => {
                        this.loading = false;
                        if (res.data.data) {
                            this.$message.success("新用户注册成功！");
                            this.getList();
                            this.addShow = false;
                        } else {
                            this.$message.error("添加失败, 请检查用户名是否重复");
                        }
                    }).catch(() => { this.loading = false; });
                }
            });
        },
    },
    mounted() {
        this.getList();
        // 获取当前操作人信息
        const uid = window.sessionStorage.getItem("token");
        axios.get("/api/user/getUserByUid?uid=" + uid).then((res) => {
            this.userInfo = res.data.data;
        });
    },
};
</script>

<style scoped lang="less">
.user-management-container {
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
        display: flex;
        gap: 10px;
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

.user-cell {
    display: flex;
    align-items: center;
    
    .user-avatar {
        background-color: #ecf5ff;
        color: #409EFF;
        margin-right: 12px;
    }
    
    .user-detail {
        .username {
            font-weight: 600;
            color: #303133;
            font-size: 14px;
        }
    }
}

.card-text {
    font-family: monospace;
    font-weight: 700;
    color: #409EFF;
    background: #f0f7ff;
    padding: 2px 6px;
    border-radius: 4px;
}

.balance-text {
    font-weight: 700;
    color: #E6A23C;
}

.empty-text {
    color: #C0C4CC;
    font-size: 12px;
}

.table-actions {
    display: flex;
    justify-content: center;
    gap: 8px;
}

.pagination-wrapper {
    margin-top: 25px;
    display: flex;
    justify-content: flex-end;
}

/* 对话框表单优化 */
.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 20px;
}

/* 新增/编辑对话框美化样式 */
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
    
    i {
        font-size: 24px;
        color: #409EFF;
        margin-right: 12px;
    }
}

.modern-form {
    padding: 10px 15px 0;
}

.gender-radio {
    width: 100%;
    display: flex;
    
    /deep/ .el-radio-button {
        flex: 1;
        .el-radio-button__inner {
            width: 100%;
        }
    }
}

.form-notice {
    background-color: #fdf6ec;
    border-radius: 6px;
    padding: 12px 16px;
    margin-top: 15px;
    display: flex;
    align-items: center;
    
    i {
        color: #e6a23c;
        margin-right: 8px;
        font-size: 16px;
    }
    
    span {
        color: #e6a23c;
        font-size: 13px;
    }
}

.dialog-btn {
    padding: 10px 25px;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.2s;
    
    &.cancel:hover {
        background-color: #f5f7fa;
        color: #409EFF;
    }
    
    &.confirm {
        background: linear-gradient(135deg, #409EFF, #0052d9);
        border: none;
        box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
        
        &:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(64, 158, 255, 0.4);
        }
    }
}

.recharge-header {
    text-align: center;
    margin-bottom: 25px;
    i { font-size: 48px; color: #E6A23C; margin-bottom: 10px; }
    p { color: #909399; font-size: 14px; margin: 0; }
}
</style>
