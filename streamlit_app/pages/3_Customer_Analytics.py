import streamlit as st
import plotly.express as px
from db import query

st.title("👤 Customer Analytics")

# ------------------------
# SEGMENT DISTRIBUTION
# ------------------------

df = query("""
SELECT segment, COUNT(*) as total_customers
FROM kpi_customer_segments
GROUP BY segment
""")

fig = px.pie(df, names="segment", values="total_customers",
             title="Customers by Segment")

st.plotly_chart(fig, use_container_width=True)

# ------------------------
# AVG BALANCE
# ------------------------

fig2 = px.bar(df, x="segment", y="total_customers",
              title="Customers per Segment")

st.plotly_chart(fig2, use_container_width=True)

# ------------------------
# ACTIVE CUSTOMERS TREND
# ------------------------

active = query("""
SELECT * FROM kpi_active_customers
ORDER BY month_start
""")

fig3 = px.line(active, x="month_start", y="active_customers",
               title="Active Customers Trend")

st.plotly_chart(fig3, use_container_width=True)

# ------------------------
# NET NEW ACTIVE
# ------------------------

fig4 = px.bar(active, x="month_start", y="net_new_active",
              title="Net New Active Customers")

st.plotly_chart(fig4, use_container_width=True)