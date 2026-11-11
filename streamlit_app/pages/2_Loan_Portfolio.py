import streamlit as st
import plotly.express as px
from db import query

st.title("💳 Loan Portfolio Health")

# ------------------------
# KPI
# ------------------------

npl = query("""
SELECT npl_ratio_pct, npl_outstanding
FROM kpi_npl_ratio
ORDER BY month_start DESC
LIMIT 1
""")

col1, col2 = st.columns(2)

col1.metric("⚠️ NPL Ratio", f"{npl.iloc[0,0]:.2f}%")
col2.metric("💰 NPL Outstanding", f"{npl.iloc[0,1]:,.0f}")

# ------------------------
# LOANS BY TYPE
# ------------------------

df = query("""
SELECT loan_type, COUNT(*) as count
FROM fact_loans
GROUP BY loan_type
""")

fig = px.pie(df, names="loan_type", values="count",
             title="Loans by Type")

st.plotly_chart(fig, use_container_width=True)

# ------------------------
# LOANS BY STATUS
# ------------------------

df2 = query("""
SELECT loan_status, COUNT(*) as count
FROM fact_loans
GROUP BY loan_status
""")

fig2 = px.bar(df2, x="loan_status", y="count",
              title="Loans by Status")

st.plotly_chart(fig2, use_container_width=True)

# ------------------------
# NPL TREND
# ------------------------

trend = query("""
SELECT * FROM kpi_npl_ratio
ORDER BY month_start
""")

fig3 = px.line(trend, x="month_start", y="npl_ratio_pct",
               title="NPL Trend (12 Months)")

st.plotly_chart(fig3, use_container_width=True)
df = query("""
SELECT * FROM fact_loans LIMIT 5
""")

st.write(df)