import streamlit as st
import plotly.express as px
from db import query

st.title("📊 Executive Overview")

# ------------------------
# KPI CARDS
# ------------------------

deposits = query("""
SELECT total_deposits
FROM kpi_deposits_growth
ORDER BY month_start DESC
LIMIT 1
""")

active = query("""
SELECT active_customers
FROM kpi_active_customers
ORDER BY month_start DESC
LIMIT 1
""")

npl = query("""
SELECT npl_ratio_pct
FROM kpi_npl_ratio
ORDER BY month_start DESC
LIMIT 1
""")

col1, col2, col3 = st.columns(3)

col1.metric("💰 Total Deposits (MTD)", f"{deposits.iloc[0,0]:,.0f}")
col2.metric("👥 Active Customers", f"{active.iloc[0,0]:,.0f}")
col3.metric("⚠️ NPL Ratio %", f"{npl.iloc[0,0]:.2f}%")

# ------------------------
# MOM DEPOSITS
# ------------------------

df = query("""
SELECT * FROM kpi_deposits_growth
ORDER BY month_start
""")

fig = px.line(df, x="month_start", y="mom_growth_pct",
              title="MoM Deposit Growth %")

st.plotly_chart(fig, use_container_width=True)

# ------------------------
# NPL TREND
# ------------------------

df2 = query("""
SELECT * FROM kpi_npl_ratio
ORDER BY month_start
""")

fig2 = px.line(df2, x="month_start", y="npl_ratio_pct",
               title="NPL Ratio Trend")

st.plotly_chart(fig2, use_container_width=True)

# ------------------------
# DEPOSITS BY MONTH
# ------------------------

fig3 = px.bar(df, x="month_name", y="total_deposits",
              title="Deposits by Month")

st.plotly_chart(fig3, use_container_width=True)