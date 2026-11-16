<!--
 * 用户缴费信息 - 现代版
 *
 * @Date: 2026-03-08
-->
<template>
    <div class="cost-container">
        <!-- 面包屑 -->
        <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/conmenHome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>缴费中心</el-breadcrumb-item>
        </el-breadcrumb>

        <!-- 账户余额卡片 -->
        <el-row :gutter="20">
            <el-col :span="24">
                <el-card class="balance-card" shadow="hover">
                    <div class="balance-wrapper">
                        <div class="balance-info">
                            <div class="balance-label">
                                <i class="el-icon-wallet"></i> 账户当前余额
                            </div>
                            <div class="balance-value" v-if="userInfo.money !== undefined">
                                <span class="currency">¥</span>
                                <span class="amount">{{ userInfo.money.toFixed(2) }}</span>
                            </div>
                            <div class="user-meta">
                                <el-tag size="small" type="success" effect="dark">
                                    <i class="el-icon-check"></i> 账户状态正常
                                </el-tag>
                                <span class="account-tip">提示：余额不足时请及时充值，以免影响离场。</span>
                            </div>
                        </div>
                        <div class="balance-actions">
                            <el-button 
                                type="primary" 
                                class="recharge-btn" 
                                icon="el-icon-circle-plus-outline"
                                @click="toPay"
                            >
                                立即充值
                            </el-button>
                        </div>
                    </div>
                </el-card>
            </el-col>
        </el-row>

        <!-- 待缴费列表 -->
        <el-card class="table-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-warning-outline" style="color: #E6A23C;"></i>
                    <span>待缴费停车记录</span>
                </div>
                <el-tag type="warning" v-if="dRes.length > 0">您有 {{ dRes.length }} 笔待处理费用</el-tag>
            </div>
            
            <el-table 
                :data="dRes" 
                stripe 
                style="width: 100%"
                v-loading="loading"
                empty-text="暂无待缴费记录，您可以放心通行"
            >
                <el-table-column label="泊位区域" min-width="120">
                    <template slot-scope="scope">
                        <el-tag size="medium" effect="plain">{{ scope.row.stall.stallArea }}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="车位编号" width="120">
                    <template slot-scope="scope">
                        <span class="stall-num">#{{ scope.row.stall.stallNum }}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="createTime" label="进场时间" width="200"></el-table-column>
                <el-table-column label="当前停车时长" width="150">
                    <template slot-scope="scope">
                        {{ calculateDuration(scope.row.createTime) }}
                    </template>
                </el-table-column>
                <el-table-column label="预计费用" width="150">
                    <template slot-scope="scope">
                        <span class="price-text">¥ {{ feeChange(scope.row).toFixed(2) }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="操作" width="150" align="center">
                    <template slot-scope="scope">
                        <el-button
                            type="success"
                            size="mini"
                            icon="el-icon-money"
                            @click="payStall(scope.row)"
                        > 立即缴费</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-card>

        <!-- 缴费历史记录 -->
        <el-card class="table-card history-card" shadow="hover" style="margin-top: 24px;">
            <div slot="header" class="card-header">
                <div class="header-title">
                    <i class="el-icon-document-checked"></i>
                    <span>缴费记录明细</span>
                </div>
            </div>
            
            <el-table 
                :data="allStallRes" 
                style="width: 100%"
                size="small"
                v-loading="loading"
            >
                <el-table-column label="记录号" width="80" type="index" align="center"></el-table-column>
                <el-table-column label="车位信息" min-width="150">
                    <template slot-scope="scope">
                        {{ scope.row.stall.stallArea }} - {{ scope.row.stall.stallNum }}号
                    </template>
                </el-table-column>
                <el-table-column prop="createTime" label="操作时间" width="200"></el-table-column>
                <el-table-column label="费用金额" width="150">
                    <template slot-scope="scope">
                        <span v-if="scope.row.money !== null" class="money-done">
                            ¥ {{ scope.row.money.toFixed(2) }}
                        </span>
                        <span v-else class="money-pending">
                            ¥ {{ feeChange(scope.row).toFixed(2) }} (待计)
                        </span>
                    </template>
                </el-table-column>
                <el-table-column label="支付状态" width="150" align="center">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.money !== null" type="success" size="mini">已支付</el-tag>
                        <el-tag v-else type="danger" size="mini">未支付</el-tag>
                    </template>
                </el-table-column>
            </el-table>
        </el-card>

        <!-- 充值对话框 -->
        <el-dialog
            title="账户余额充值"
            :visible.sync="payShow"
            width="400px"
            center
            custom-class="recharge-dialog"
            @close="payClose"
        >
            <div class="recharge-form">
                <div class="dialog-icon">
                    <i class="el-icon-bank-card"></i>
                </div>
                <p class="recharge-tip">请输入您要充值的金额 (元)</p>
                <el-input-number 
                    v-model="payMoney" 
                    :precision="2" 
                    :step="100" 
                    :min="0.01" 
                    :max="10000"
                    placeholder="金额"
                    style="width: 100%"
                ></el-input-number>
                <p class="pay-msg" v-if="msgShow">{{ payMsg }}</p>
                
                <div class="quick-amounts">
                    <el-button size="mini" plain @click="payMoney = 100">100元</el-button>
                    <el-button size="mini" plain @click="payMoney = 200">200元</el-button>
                    <el-button size="mini" plain @click="payMoney = 500">500元</el-button>
                    <el-button size="mini" plain @click="payMoney = 1000">1000元</el-button>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="payClose">取 消</el-button>
                <el-button type="primary" @click="payClick" class="confirm-pay">确认充值</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import axios from "axios";
export default {
    data() {
        return {
            allStallRes: [],
            userInfo: {},
            payShow: false,
            payMoney: 0,
            payMsg: "",
            msgShow: false,
            dRes: [],
            loading: false
        };
    },
    methods: {
        getAllStallRes(uid) {
            this.loading = true;
            axios.get("/api/stall/listUserStallRes?person=" + uid).then((res) => {
                this.allStallRes = res.data.data;
                this.loading = false;
            }).catch(() => { this.loading = false; });
        },
        getUserInfo(uid) {
            axios.get("/api/user/getUserByUid?uid=" + uid).then((res) => {
                this.userInfo = res.data.data;
                if (this.userInfo.username) {
                    this.getAllStallRes(this.userInfo.username);
                    this.getUserNoPay(this.userInfo.username);
                }
            });
        },
        getUserNoPay(uid) {
            axios.get("/api/stall/allNoPay?person=" + uid).then((res) => {
                this.dRes = res.data.data;
            });
        },
        calculateDuration(startTimeStr) {
            const start = new Date(startTimeStr);
            const now = new Date();
            const diff = now - start;
            const hours = Math.floor(diff / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            return `${hours}小时 ${minutes}分钟`;
        },
        feeChange(stallRes) {
            let startTime = new Date(stallRes.createTime);
            let endTime = new Date();
            let hours = (endTime.getTime() - startTime.getTime()) / 3600000;
            return Math.max(0.1, (Math.floor(hours * 10) / 10) * stallRes.stall.stallMoney);
        },
        toPay() {
            this.payMoney = 100;
            this.payShow = true;
        },
        payClick() {
            if (this.payMoney > 0) {
                const uid = window.sessionStorage.getItem("token");
                axios
                    .post("/api/user/userPay", {
                        uid: uid,
                        money: this.payMoney,
                    })
                    .then((res) => {
                        if (res.data.data) {
                            this.$message.success("账户充值成功！");
                            this.getUserInfo(uid);
                            this.payClose();
                        } else {
                            this.$message.error("充值失败，请检查网络或稍后再试");
                        }
                    });
            } else {
                this.$message.warning("请输入有效的充值金额");
            }
        },
        payClose() {
            this.payShow = false;
            this.msgShow = false;
            this.payMsg = "";
        },
        async payStall(stallRes) {
            const amount = this.feeChange(stallRes).toFixed(2);
            const re = await this.$confirm(
                `确定为该记录缴纳停车费 ¥ ${amount} 元吗？费用将直接从账户余额扣除。`,
                "缴费确认",
                {
                    confirmButtonText: "立即支付",
                    cancelButtonText: "稍后处理",
                    type: "info",
                    center: true
                }
            ).catch((err) => err);

            if (re === "confirm") {
                let oa = {
                    pid: stallRes.pid,
                    person: stallRes.person,
                    stallId: stallRes.stallId,
                    money: parseFloat(amount)
                };
                axios.post("/api/stall/payMoneyPerson", oa).then((res) => {
                    if (res.data.data.flag) {
                        this.$message.success("支付成功，泊位已解锁！");
                        this.getAllStallRes(this.userInfo.username);
                        this.getUserNoPay(this.userInfo.username);
                        this.getUserInfo(window.sessionStorage.getItem("token"));
                    } else {
                        this.$message.error(res.data.data.msg || "支付失败，请检查余额");
                    }
                });
            }
        },
    },

    mounted() {
        const uid = window.sessionStorage.getItem("token");
        this.getUserInfo(uid);
    },
};
</script>

<style scoped lang="less">
.cost-container {
    padding: 0 4px;
}

.balance-card {
    background: linear-gradient(135deg, #1d2b64 0%, #3a6073 100%);
    color: white;
    border: none;
    
    .balance-wrapper {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 30px;
    }
    
    .balance-label {
        font-size: 16px;
        opacity: 0.9;
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        i { margin-right: 8px; font-size: 20px; }
    }
    
    .balance-value {
        margin-bottom: 20px;
        .currency { font-size: 24px; margin-right: 4px; font-weight: 500; }
        .amount { font-size: 48px; font-weight: 700; letter-spacing: 1px; }
    }
    
    .user-meta {
        display: flex;
        align-items: center;
        .account-tip { font-size: 13px; color: rgba(255,255,255,0.7); margin-left: 15px; }
    }
    
    .recharge-btn {
        padding: 15px 35px;
        font-size: 18px;
        font-weight: 600;
        background: #ffffff;
        color: #1d2b64;
        border: none;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        
        &:hover {
            background: #f0f0f0;
            transform: translateY(-2px);
        }
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

.stall-num {
    font-family: monospace;
    font-weight: bold;
    color: #409EFF;
}

.price-text {
    color: #F56C6C;
    font-weight: bold;
    font-size: 16px;
}

.money-done {
    color: #67C23A;
    font-weight: bold;
}

.money-pending {
    color: #909399;
    font-style: italic;
}

.recharge-form {
    text-align: center;
    padding: 10px 0;
    
    .dialog-icon {
        font-size: 60px;
        color: #409EFF;
        margin-bottom: 15px;
    }
    
    .recharge-tip {
        color: #606266;
        margin-bottom: 20px;
        font-size: 15px;
    }
    
    .quick-amounts {
        margin-top: 20px;
        display: flex;
        justify-content: center;
        gap: 10px;
    }
}

.confirm-pay {
    width: 60%;
}
</style>
