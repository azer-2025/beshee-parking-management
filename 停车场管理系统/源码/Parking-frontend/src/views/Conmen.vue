<!--
 * 菜单栏
 *
 *
 * @Date: 2023-12-03
-->
<template>
    <el-container class="home-container">
        <!-- 头部区域 -->
        <el-header height="64px">
            <div class="header-left">
                <div class="logo-box">
                    <span class="logo-text">停车场管理系统</span>
                </div>
            </div>
            
            <div class="header-right">
                <div class="user-info">
                    <el-avatar icon="el-icon-user-solid" size="small" style="background: #409EFF; margin-right: 8px;"></el-avatar>
                    <span class="welcome-text">欢迎您，<b>{{ userInfo.nike }}</b></span>
                </div>
                <div class="divider"></div>
                <el-button 
                    type="text" 
                    class="logout-btn" 
                    @click="logout"
                >
                    <i class="el-icon-switch-button" style="font-weight: bold; margin-right: 4px;"></i>
                    退出登录
                </el-button>
            </div>
        </el-header>

        <!-- 页面主体区域 -->
        <el-container class="main-body">
            <!-- 侧边栏 -->
            <el-aside width="260px" class="modern-aside">
                <el-menu
                    background-color="#ffffff"
                    text-color="#606266"
                    active-text-color="#409EFF"
                    :unique-opened="true"
                    :collapse-transition="false"
                    router
                    :default-active="activePath"
                    class="modern-menu"
                >
                    <el-menu-item
                        v-for="item in menuList"
                        :key="item.id"
                        :index="'/' + item.path"
                        @click="savePath('/' + item.path)"
                        class="menu-item"
                    >
                        <div class="active-bar"></div>
                        <i :class="item.icon" class="menu-icon"></i>
                        <span slot="title" class="menu-name">{{ item.name }}</span>
                    </el-menu-item>
                </el-menu>
            </el-aside>
            
            <!-- 右侧内容主体 -->
            <el-main>
                <transition name="fade-transform" mode="out-in">
                    <router-view></router-view>
                </transition>
            </el-main>
        </el-container>
    </el-container>
</template>

<script>
import axios from "axios";
export default {
    data() {
        return {
            menuList: [
                {
                    name: "系统首页",
                    id: 101,
                    path: "conmenHome",
                    icon: "el-icon-s-home",
                },
                {
                    name: "个人中心",
                    id: 111,
                    path: "userInfo",
                    icon: "el-icon-user",
                },
                {
                    name: "预定停车位",
                    id: 131,
                    path: "carInfo",
                    icon: "el-icon-location",
                },
                {
                    name: "缴费中心",
                    id: 141,
                    path: "cost",
                    icon: "el-icon-wallet",
                },
            ],
            userInfo: {},
            activePath: "/conmenHome",
        };
    },
    created() {
        const savedPath = window.sessionStorage.getItem("savePath");
        if (savedPath) {
            this.activePath = savedPath;
        }
    },
    methods: {
        getUserInfo() {
            const uid = window.sessionStorage.getItem("token");
            axios.get("/api/user/getUserByUid?uid=" + uid).then((res) => {
                this.userInfo = res.data.data;
            });
        },
        logout() {
            this.$confirm('确定要退出当前系统吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                window.sessionStorage.clear();
                this.$router.push("/login");
                this.$message.success("您已安全退出系统");
            }).catch(() => {});
        },
        savePath(savePath) {
            this.activePath = savePath;
            window.sessionStorage.setItem("savePath", savePath);
        },
    },
    mounted() {
        this.getUserInfo();
    },
};
</script>

<style scoped lang="less">
.home-container {
    height: 100vh;
}

.el-header {
    background-color: #ffffff;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 24px;
    box-shadow: 0 1px 4px rgba(0,21,41,.08);
    z-index: 100;
}

.header-left {
    display: flex;
    align-items: center;
}

.logo-box {
    display: flex;
    align-items: center;
    
    .logo-img {
        height: 32px;
        margin-right: 12px;
    }
    
    .logo-text {
        font-size: 20px;
        font-weight: 700;
        color: #1a1a1a;
        letter-spacing: 1px;
        background: linear-gradient(135deg, #409EFF, #0052d9);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }
}

.header-right {
    display: flex;
    align-items: center;
    
    .user-info {
        display: flex;
        align-items: center;
        margin-right: 16px;
        
        .welcome-text {
            font-size: 14px;
            color: #606266;
            b { color: #303133; }
        }
    }
    
    .divider {
        width: 1px;
        height: 16px;
        background-color: #dcdfe6;
        margin-right: 16px;
    }
    
    .logout-btn {
        color: #f56c6c;
        font-size: 14px;
        font-weight: 500;
        
        &:hover {
            color: #ff8989;
        }
    }
}

.main-body {
    background-color: #f5f7fa;
}

.el-aside {
    background-color: #ffffff;
    box-shadow: 2px 0 10px rgba(0,21,41,.05);
    z-index: 90;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    overflow-x: hidden;
    
    &::-webkit-scrollbar {
        display: none;
    }
}

.modern-menu {
    border-right: none;
    padding: 15px 0;
}

.menu-item {
    height: 50px;
    line-height: 50px;
    margin: 4px 16px;
    border-radius: 10px;
    padding-left: 20px !important;
    position: relative;
    transition: all 0.3s ease;
    overflow: hidden;
    
    .active-bar {
        position: absolute;
        left: 0;
        top: 15%;
        height: 70%;
        width: 4px;
        background-color: #409EFF;
        border-radius: 0 4px 4px 0;
        opacity: 0;
        transform: scaleY(0);
        transition: all 0.3s ease;
    }
    
    &.is-active {
        background: linear-gradient(90deg, rgba(64, 158, 255, 0.1) 0%, rgba(64, 158, 255, 0.02) 100%) !important;
        color: #409EFF !important;
        font-weight: 600;
        
        .active-bar {
            opacity: 1;
            transform: scaleY(1);
        }
        
        .menu-icon {
            color: #409EFF;
            transform: scale(1.1);
        }
    }
    
    &:hover {
        background-color: #f5f7fa !important;
        padding-left: 25px !important;
        
        .menu-icon {
            color: #409EFF;
        }
    }
    
    .menu-icon {
        font-size: 18px;
        margin-right: 12px;
        color: #909399;
        transition: all 0.3s ease;
    }
    
    .menu-name {
        font-size: 14px;
        letter-spacing: 0.5px;
    }
}

/* 路由动画 */
.fade-transform-enter-active,
.fade-transform-leave-active {
    transition: all .3s;
}

.fade-transform-enter {
    opacity: 0;
    transform: translateX(-30px);
}

.fade-transform-leave-to {
    opacity: 0;
    transform: translateX(30px);
}
</style>
