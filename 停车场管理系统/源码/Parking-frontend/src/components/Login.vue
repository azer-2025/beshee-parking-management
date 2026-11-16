<!--
 * 登录页
 *
 *
 * @Date: 2023-12-03
-->
<template>
    <div
        class="login_bg"
        v-loading="loading"
        element-loading-text="正在处理中,请稍等..."
        element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.7)"
    >
        <transition name="el-fade-in-linear" mode="out-in">
            <div class="glass-container login_box" v-if="!registerShow" key="login">
                <div class="login-header">
                    <h2 class="login-title">智能停车场管理系统</h2>
                    <p class="login-subtitle">欢迎回来，请登录您的账号</p>
                </div>
                
                <el-form
                    class="login_form"
                    :model="ruleForm"
                    :rules="rules"
                    ref="rules"
                    label-width="0"
                >
                    <el-form-item prop="username">
                        <el-input
                            v-model="ruleForm.username"
                            placeholder="请输入用户名"
                            class="custom-input"
                        >
                            <i slot="prefix" class="iconfont icon-user input-icon"></i>
                        </el-input>
                    </el-form-item>
                    <el-form-item prop="password">
                        <el-input
                            type="password"
                            v-model="ruleForm.password"
                            placeholder="请输入密码"
                            class="custom-input"
                            @keyup.enter.native="login"
                        >
                            <i slot="prefix" class="iconfont icon-password input-icon"></i>
                        </el-input>
                    </el-form-item>
                    
                    <div class="btn-group">
                        <el-button
                            class="action-btn login-btn"
                            type="primary"
                            @click="login"
                        >
                            <i class="iconfont icon-login-button btn-icon"></i> 登 录
                        </el-button>
                        <el-button
                            class="action-btn register-btn-outline"
                            plain
                            @click="toRegister"
                        >
                            <i class="iconfont icon-register-button btn-icon"></i> 注 册
                        </el-button>
                    </div>
                </el-form>
            </div>

            <div class="glass-container register-box" v-if="registerShow" key="register">
                <div class="login-header">
                    <h2 class="login-title">创建新账号</h2>
                    <p class="login-subtitle">请填写以下信息完成注册</p>
                </div>
                
                <el-form
                    :model="registerUser"
                    status-icon
                    :rules="registerRules"
                    ref="registerRules"
                    label-width="90px"
                    class="register-form"
                >
                    <div class="form-grid">
                        <el-form-item label="用户名" prop="username">
                            <el-input v-model="registerUser.username" placeholder="请输入用户名" class="custom-input"></el-input>
                        </el-form-item>
                        <el-form-item label="密码" prop="password">
                            <el-input type="password" v-model="registerUser.password" placeholder="请输入密码" show-password class="custom-input"></el-input>
                        </el-form-item>
                        <el-form-item label="确认密码" prop="check" class="is-required">
                            <el-input type="password" v-model="registerUser.check" placeholder="再次输入密码" show-password class="custom-input"></el-input>
                        </el-form-item>
                        <el-form-item label="姓名" prop="nike">
                            <el-input v-model="registerUser.nike" placeholder="请输入真实姓名" class="custom-input"></el-input>
                        </el-form-item>
                        <el-form-item label="性别" prop="sex" required>
                            <el-radio-group v-model="registerUser.sex">
                                <el-radio label="男">男</el-radio>
                                <el-radio label="女">女</el-radio>
                            </el-radio-group>
                        </el-form-item>
                        <el-form-item label="年龄" prop="age" class="is-required">
                            <el-input v-model.number="registerUser.age" placeholder="请输入年龄" class="custom-input"></el-input>
                        </el-form-item>
                        <el-form-item label="车牌号" prop="card" class="is-required">
                            <el-input v-model="registerUser.card" placeholder="例如: 粤B12345" class="custom-input"></el-input>
                        </el-form-item>
                        <el-form-item label="联系电话" prop="phone" required>
                            <el-input v-model="registerUser.phone" placeholder="请输入手机号码" class="custom-input"></el-input>
                        </el-form-item>
                    </div>

                    <div class="btn-group" style="margin-top: 10px;">
                        <el-button
                            class="action-btn register-btn-submit"
                            type="primary"
                            @click="submitForm('registerRules')"
                        >
                            <i class="iconfont icon-register-button btn-icon"></i> 立即注册
                        </el-button>
                        <el-button 
                            class="action-btn back-btn" 
                            plain
                            @click="toLogin"
                        >
                            <i class="iconfont icon-back-button btn-icon"></i> 返回登录
                        </el-button>
                    </div>
                </el-form>
            </div>
        </transition>
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
            setTimeout(() => {
                if (!Number.isInteger(value)) {
                    callback(new Error("请输入数字值"));
                } else {
                    if (value < 18) {
                        callback(new Error("必须年满18岁"));
                    } else {
                        callback();
                    }
                }
            }, 1000);
        };
        var validatePass2 = (rule, value, callback) => {
            if (value === "") {
                callback(new Error("请再次输入密码"));
            } else if (value !== this.registerUser.password) {
                callback(new Error("两次输入密码不一致!"));
            } else {
                callback();
            }
        };
        return {
            registerShow: false,
            loading: false,
            ruleForm: {
                username: "",
                password: "",
            },
            rules: {
                username: [
                    {
                        required: true,
                        message: "请输入用户名",
                        trigger: "blur",
                    },
                    {
                        min: 3,
                        max: 10,
                        message: "长度在 3 到 10 个字符",
                        trigger: "blur",
                    },
                ],
                password: [
                    { required: true, message: "请输入密码", trigger: "blur" },
                    {
                        min: 6,
                        max: 15,
                        message: "长度在 6 到 15 个字符",
                        trigger: "blur",
                    },
                ],
            },
            registerUser: {
                username: "",
                password: "",
                check: "",
                sex: "男",
                phone: "",
                age: "",
                card: "",
                nike: "",
            },
            registerRules: {
                username: [{ validator: checkUsername, trigger: "blur" }],
                password: [
                    { required: true, message: "请输入密码", trigger: "blur" },
                    {
                        min: 6,
                        max: 15,
                        message: "长度在 6 到 15 个字符",
                        trigger: "blur",
                    },
                ],
                check: [{ validator: validatePass2, trigger: "blur" }],
                age: [{ validator: checkAge, trigger: "blur" }],
                phone: [
                    {
                        required: true,
                        message: "请输入联系电话",
                        trigger: "blur",
                    },
                ],
                card: [
                    {
                        required: true,
                        message: "请输入车牌号",
                        trigger: "blur",
                    },
                ],
                nike: [
                    {
                        required: true,
                        message: "请输入姓名",
                        trigger: "blur",
                    },
                ],
            },
        };
    },
    methods: {
        login() {
            this.loading = true;
            axios
                .post("/api/user/login", this.ruleForm)
                .then((res) => {
                    this.loading = false;
                    if (res.data.data.state) {
                        this.$message.success("登陆成功！");
                        //  token只应在当前网站打开期间生效，所以将token保存在sessionStorage中
                        window.sessionStorage.setItem(
                            "token",
                            res.data.data.uid
                        );
                        if (res.data.data.role == 0) {
                            this.$router.push("/mane");
                        } else {
                            this.$router.push("/conmen");
                        }
                    } else {
                        this.$message.error(
                            "登录失败," + res.data.data.msg + "!"
                        );
                    }
                })
                .catch((error) => {
                    console.log(error.message);
                    this.loading = false;
                    this.$message.error("服务器异常");
                });
        },
        toRegister() {
            this.registerShow = true;
        },
        toLogin() {
            this.registerShow = false;
            this.$nextTick(() => {
                this.$refs.rules.resetFields();
            });
        },
        submitForm(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    this.loading = true;
                    axios
                        .post("/api/user/register", this.registerUser)
                        .then((res) => {
                            this.loading = false;
                            if (res.data.data) {
                                this.$message.success("注册成功！");
                                this.registerShow = false;
                            } else {
                                this.$message.error("登录失败,请重新尝试！");
                            }
                        });
                } else {
                    return false;
                }
            });
        },
        resetForm(formName) {
            this.$refs[formName].resetFields();
        },
    },
};
</script>
<style lang="less" scoped>
.login_bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    // 使用更可靠的背景图源，并增加备用渐变色
    background-color: #2c3e50;
    background-image: linear-gradient(135deg, rgba(0,0,0,0.4), rgba(0,0,0,0.2)), url("https://api.paugram.com/wallpaper/?source=sina");
    background-position: center;
    background-size: cover;
    background-repeat: no-repeat;
    
    &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at center, transparent 0%, rgba(0,0,0,0.4) 100%);
        z-index: 1;
    }
}

.glass-container {
    position: relative;
    z-index: 2;
    background: rgba(255, 255, 255, 0.92);
    backdrop-filter: blur(20px) saturate(180%);
    -webkit-backdrop-filter: blur(20px) saturate(180%);
    border: 1px solid rgba(255, 255, 255, 0.5);
    border-radius: 24px;
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
    padding: 45px 50px;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    
    &:hover {
        transform: translateY(-5px);
        box-shadow: 0 35px 60px -15px rgba(0, 0, 0, 0.3);
    }
}

.login_box {
    width: 420px;
}

.register-box {
    width: 780px;
    max-height: 85vh;
}

.login-header {
    text-align: center;
    margin-bottom: 40px;
    
    .logo {
        width: 72px;
        height: auto;
        margin-bottom: 15px;
        filter: drop-shadow(0 4px 10px rgba(0,0,0,0.1));
    }
    
    .login-title {
        font-size: 28px;
        color: #1a1a1a;
        margin: 0 0 12px 0;
        font-weight: 700;
        letter-spacing: 1.5px;
        background: linear-gradient(to right, #2c3e50, #409EFF);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }
    
    .login-subtitle {
        font-size: 14px;
        color: #909399;
        margin: 0;
        font-weight: 400;
    }
}

.custom-input {
    margin-bottom: 5px;

    /deep/ .el-input__inner {
        height: 52px;
        line-height: 52px;
        padding-left: 45px !important; // 核心修复：增加左内边距防止重叠
        border-radius: 12px;
        border: 1.5px solid #eee;
        background-color: #f9fafb;
        font-size: 15px;
        color: #333;
        transition: all 0.2s ease;
        
        &:focus {
            border-color: #409EFF;
            background-color: #fff;
            box-shadow: 0 0 0 4px rgba(64, 158, 255, 0.1);
        }
    }
    
    /deep/ .el-input__prefix {
        left: 14px;
        display: flex;
        align-items: center;
        height: 100%;
        
        .input-icon {
            font-size: 20px;
            color: #b1b1b1;
            transition: color 0.3s;
        }
    }

    /deep/ .el-input__inner:focus + .el-input__prefix .input-icon {
        color: #409EFF;
    }
}

.input-icon {
    font-size: 20px;
    color: #909399;
}

.btn-group {
    display: flex;
    justify-content: space-between;
    gap: 20px;
    margin-top: 35px;
}

.action-btn {
    flex: 1;
    height: 50px;
    font-size: 16px;
    border-radius: 10px;
    font-weight: 500;
    letter-spacing: 2px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s cubic-bezier(.64,.04,.35,1);
    border: none;
    
    .btn-icon {
        margin-right: 8px;
        font-size: 18px;
    }
}

.login-btn, .register-btn-submit {
    background: linear-gradient(135deg, #409EFF, #3a8ee6);
    box-shadow: 0 4px 15px rgba(64, 158, 255, 0.35);
    color: white;
    
    &:hover {
        background: linear-gradient(135deg, #66b1ff, #409EFF);
        box-shadow: 0 6px 20px rgba(64, 158, 255, 0.45);
        transform: translateY(-2px);
        color: white;
    }
}

.register-btn-outline, .back-btn {
    background: rgba(255, 255, 255, 0.9);
    border: 1px solid #dcdfe6;
    color: #606266;
    
    &:hover {
        color: #409EFF;
        border-color: #c6e2ff;
        background-color: #ecf5ff;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
}

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 35px;
}

/* 覆盖注册表单label样式以更协调 */
.register-form /deep/ .el-form-item__label {
    font-weight: 500;
    color: #606266;
}

// Responsive
@media (max-width: 768px) {
    .form-grid {
        grid-template-columns: 1fr;
    }
    .register-box {
        padding: 30px 25px;
    }
    .login_box {
        padding: 40px 30px;
    }
    .glass-container {
        border-radius: 16px;
    }
}
</style>
