<!--
 * 系统首页 Dashboard - 运营看板版
 *
 * @Date: 2023-12-03
-->
<template>
    <div class="dashboard-container">
        <!-- 顶部统计卡片 -->
        <el-row :gutter="20" class="stat-row">
            <el-col :span="6" v-for="(item, index) in statistics" :key="index">
                <el-card shadow="hover" class="stat-card" :body-style="{ padding: '20px' }">
                    <div class="stat-wrapper">
                        <div class="stat-icon-box" :style="{ background: item.color + '15', color: item.color }">
                            <i :class="item.icon"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">{{ item.label }}</div>
                            <div class="stat-value-group">
                                <span class="stat-value">{{ item.value }}</span>
                                <span class="stat-unit">{{ item.unit }}</span>
                            </div>
                            <div class="stat-trend" :class="item.trend > 0 ? 'up' : 'down'">
                                <i :class="item.trend > 0 ? 'el-icon-caret-top' : 'el-icon-caret-bottom'"></i>
                                {{ Math.abs(item.trend) }}% <span>较昨日</span>
                            </div>
                        </div>
                    </div>
                </el-card>
            </el-col>
        </el-row>

        <!-- 中间图表区域 -->
        <el-row :gutter="20" class="chart-row">
            <el-col :span="16">
                <el-card shadow="hover" class="main-chart-card">
                    <div slot="header" class="card-header">
                        <div class="header-title">
                            <i class="el-icon-data-line"></i>
                            <span>近七日车流量与营收趋势</span>
                        </div>
                        <el-radio-group v-model="trendPeriod" size="mini">
                            <el-radio-button label="7d">近7天</el-radio-button>
                            <el-radio-button label="30d">近30天</el-radio-button>
                        </el-radio-group>
                    </div>
                    <div id="trendChart" class="chart-box"></div>
                </el-card>
            </el-col>
            <el-col :span="8">
                <el-card shadow="hover" class="side-chart-card">
                    <div slot="header" class="card-header">
                        <div class="header-title">
                            <i class="el-icon-pie-chart"></i>
                            <span>实时泊位占用率</span>
                        </div>
                    </div>
                    <div id="usageChart" class="chart-box"></div>
                </el-card>
            </el-col>
        </el-row>

        <!-- 底部图表与列表区域 -->
        <el-row :gutter="20" class="bottom-row">
            <el-col :span="8">
                <el-card shadow="hover" class="bottom-chart-card">
                    <div slot="header" class="card-header">
                        <div class="header-title">
                            <i class="el-icon-truck"></i>
                            <span>车型分布比例</span>
                        </div>
                    </div>
                    <div id="typeChart" class="chart-box"></div>
                </el-card>
            </el-col>
            <el-col :span="16">
                <el-card shadow="hover" class="log-card">
                    <div slot="header" class="card-header">
                        <div class="header-title">
                            <i class="el-icon-time"></i>
                            <span>实时进出场记录</span>
                        </div>
                        <el-button type="text" @click="goMoreRecords">更多记录</el-button>
                    </div>
                    <el-table :data="recentLogs" style="width: 100%" size="small" :header-cell-style="{background:'#f8f9fb'}">
                        <el-table-column prop="carId" label="车牌号码" width="120">
                            <template slot-scope="scope">
                                <el-tag size="mini" effect="plain">{{ scope.row.carId }}</el-tag>
                            </template>
                        </el-table-column>
                        <el-table-column prop="type" label="类型" width="100">
                            <template slot-scope="scope">
                                <span :style="{color: scope.row.type === '进场' ? '#67C23A' : '#F56C6C'}">
                                    <i :class="scope.row.type === '进场' ? 'el-icon-bottom-right' : 'el-icon-top-right'"></i>
                                    {{ scope.row.type }}
                                </span>
                            </template>
                        </el-table-column>
                        <el-table-column prop="stall" label="分配泊位" width="100"></el-table-column>
                        <el-table-column prop="time" label="操作时间"></el-table-column>
                        <el-table-column label="状态" width="100">
                            <template slot-scope="scope">
                                <el-badge is-dot :type="scope.row.status === '已支付' ? 'success' : 'warning'">
                                    {{ scope.row.status }}
                                </el-badge>
                            </template>
                        </el-table-column>
                    </el-table>
                </el-card>
            </el-col>
        </el-row>
    </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
    data() {
        return {
            trendPeriod: '7d',
            statistics: [
                { label: '今日累计营收', value: '3,842', unit: '元', icon: 'el-icon-money', color: '#409EFF', trend: 12.5 },
                { label: '今日车流量', value: '452', unit: '辆', icon: 'el-icon-map-location', color: '#67C23A', trend: -2.3 },
                { label: '平均停泊时长', value: '4.5', unit: '小时', icon: 'el-icon-timer', color: '#E6A23C', trend: 5.8 },
                { label: '注册会员总数', value: '1,280', unit: '人', icon: 'el-icon-user', color: '#F56C6C', trend: 0.5 },
            ],
            recentLogs: [
                { carId: '粤B·A8888', type: '进场', stall: 'A-024', time: '2026-03-08 14:22:05', status: '待缴费' },
                { carId: '京A·66666', type: '出场', stall: 'B-112', time: '2026-03-08 14:15:32', status: '已支付' },
                { carId: '沪C·9X231', type: '进场', stall: 'C-005', time: '2026-03-08 14:02:11', status: '待缴费' },
                { carId: '浙A·QW001', type: '出场', stall: 'A-018', time: '2026-03-08 13:55:40', status: '已支付' },
                { carId: '苏E·5521K', type: '进场', stall: 'B-042', time: '2026-03-08 13:42:15', status: '待缴费' },
            ],
            charts: {
                trend: null,
                usage: null,
                type: null
            }
        };
    },
    watch: {
        trendPeriod(newVal) {
            this.updateTrendChart(newVal);
        }
    },
    methods: {
        updateTrendChart(period) {
            if (!this.charts.trend) return;
            
            // 模拟不同时间段的数据
            const dataMap = {
                '7d': {
                    days: ['3/2', '3/3', '3/4', '3/5', '3/6', '3/7', '3/8'],
                    flow: [320, 450, 390, 480, 520, 610, 452],
                    revenue: [2800, 3500, 3200, 4100, 4800, 5200, 3842]
                },
                '30d': {
                    days: ['2/8', '2/15', '2/22', '3/1', '3/8'],
                    flow: [1200, 1540, 1380, 1620, 1850],
                    revenue: [12000, 15000, 14200, 18100, 21000]
                }
            };
            
            const selected = dataMap[period];
            
            this.charts.trend.setOption({
                xAxis: { data: selected.days },
                series: [
                    { data: selected.flow },
                    { data: selected.revenue }
                ]
            });
        },
        initCharts() {
            // 1. 趋势图 (Line & Bar)
            this.charts.trend = echarts.init(document.getElementById('trendChart'));
            this.charts.trend.setOption({
                tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
                legend: { bottom: '0', icon: 'rect' },
                grid: { left: '3%', right: '4%', top: '10%', bottom: '15%', containLabel: true },
                xAxis: { type: 'category', axisLine: { lineStyle: { color: '#eee' } }, axisLabel: { color: '#999' } },
                yAxis: [
                    { type: 'value', name: '流量', splitLine: { lineStyle: { type: 'dashed', color: '#f0f0f0' } } },
                    { type: 'value', name: '营收', splitLine: { show: false } }
                ],
                series: [
                    {
                        name: '车流量', type: 'bar', barWidth: '30%', itemStyle: { borderRadius: [4, 4, 0, 0], color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#409EFF' }, { offset: 1, color: '#73b9ff' }]) }
                    },
                    {
                        name: '营收趋势', type: 'line', yAxisIndex: 1, smooth: true, showSymbol: false, lineStyle: { width: 3, color: '#F56C6C' },
                        areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(245, 108, 108, 0.2)' }, { offset: 1, color: 'rgba(245, 108, 108, 0)' }]) }
                    }
                ]
            });
            this.updateTrendChart(this.trendPeriod);

            // 2. 占用率图 (Gauge or Ring)
            this.charts.usage = echarts.init(document.getElementById('usageChart'));
            this.charts.usage.setOption({
                series: [{
                    type: 'gauge',
                    startAngle: 180, endAngle: 0, min: 0, max: 1,
                    splitNumber: 8,
                    axisLine: { lineStyle: { width: 10, color: [[0.7, '#67C23A'], [0.9, '#E6A23C'], [1, '#F56C6C']] } },
                    pointer: { icon: 'path://M12.8,0.7l12,40.1H0.7L12.8,0.7z', length: '12%', width: 10, offsetCenter: [0, '-50%'], itemStyle: { color: 'auto' } },
                    axisTick: { distance: -15, splitNumber: 5, lineStyle: { width: 1, color: '#999' } },
                    splitLine: { distance: -20, length: 14, lineStyle: { width: 2, color: '#999' } },
                    axisLabel: { distance: -15, color: '#999', fontSize: 12 },
                    anchor: { show: true, showAbove: true, size: 15, itemStyle: { borderWidth: 5, borderColor: '#fff', color: '#409EFF' } },
                    title: { show: false },
                    detail: { valueAnimation: true, fontSize: 32, offsetCenter: [0, '30%'], formatter: (v) => Math.round(v * 100) + '%' },
                    data: [{ value: 0.65 }]
                }]
            });

            // 3. 车型分布图 (Pie)
            this.charts.type = echarts.init(document.getElementById('typeChart'));
            this.charts.type.setOption({
                tooltip: { trigger: 'item' },
                legend: { bottom: '0', left: 'center' },
                series: [{
                    name: '车型分布',
                    type: 'pie',
                    radius: ['45%', '70%'],
                    avoidLabelOverlap: false,
                    itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 2 },
                    label: { show: false, position: 'center' },
                    emphasis: { label: { show: true, fontSize: '18', fontWeight: 'bold' } },
                    labelLine: { show: false },
                    data: [
                        { value: 735, name: '小型轿车', itemStyle: { color: '#409EFF' } },
                        { value: 580, name: 'SUV/越野', itemStyle: { color: '#67C23A' } },
                        { value: 484, name: '新能源车', itemStyle: { color: '#E6A23C' } },
                        { value: 300, name: '货车/巴士', itemStyle: { color: '#F56C6C' } }
                    ]
                }]
            });
        },
        handleResize() {
            Object.values(this.charts).forEach(chart => chart && chart.resize());
        },
        goMoreRecords() {
            const targetPath = this.$route.path === '/maneHome' ? '/carInMane' : '/cost';
            window.sessionStorage.setItem('savePath', targetPath);
            this.$router.push(targetPath);
        }
    },
    mounted() {
        this.$nextTick(() => {
            this.initCharts();
            this.handleResize();
            window.addEventListener('resize', this.handleResize);
        });
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.handleResize);
        Object.values(this.charts).forEach(chart => chart && chart.dispose());
    }
};
</script>

<style scoped lang="less">
.dashboard-container {
    padding: 0 4px;
}

/* 统计卡片样式 */
.stat-row {
    margin-bottom: 24px;
}

.stat-card {
    border-radius: 12px;
    
    .stat-wrapper {
        display: flex;
        align-items: center;
    }
    
    .stat-icon-box {
        width: 60px;
        height: 60px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 18px;
        font-size: 28px;
    }
    
    .stat-info {
        flex: 1;
        
        .stat-label {
            font-size: 14px;
            color: #909399;
            margin-bottom: 8px;
        }
        
        .stat-value-group {
            display: flex;
            align-items: baseline;
            margin-bottom: 6px;
            
            .stat-value {
                font-size: 26px;
                font-weight: 700;
                color: #303133;
            }
            
            .stat-unit {
                font-size: 13px;
                color: #909399;
                margin-left: 4px;
            }
        }
        
        .stat-trend {
            font-size: 12px;
            display: flex;
            align-items: center;
            
            span { color: #c0c4cc; margin-left: 4px; }
            
            &.up { color: #f56c6c; }
            &.down { color: #67c23a; }
        }
    }
}

/* 图表布局样式 */
.chart-row, .bottom-row {
    margin-bottom: 24px;
}

.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 24px;
    
    .header-title {
        display: flex;
        align-items: center;
        font-weight: 600;
        font-size: 16px;
        color: #303133;
        
        i { margin-right: 10px; font-size: 18px; color: #409EFF; }
    }
}

.chart-box {
    width: 100%;
    height: 320px;
}

.main-chart-card, .side-chart-card, .bottom-chart-card, .log-card {
    border-radius: 12px;
}

/* 实时记录卡片微调 */
.log-card {
    /deep/ .el-card__body {
        padding: 10px 20px 20px;
    }
}

.el-tag--plain {
    font-family: monospace;
    font-weight: bold;
    letter-spacing: 1px;
}
</style>
