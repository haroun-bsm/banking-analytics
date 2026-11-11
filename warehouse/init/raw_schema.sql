CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id     VARCHAR(36) PRIMARY KEY,
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    date_of_birth   DATE,
    city            VARCHAR(100),
    country         VARCHAR(50),
    segment         VARCHAR(30), -- RETAIL, SME, CORPORATE
    email           VARCHAR(150),
    phone           VARCHAR(20),
    created_at      TIMESTAMP,
    updated_at      TIMESTAMP,
    is_deleted      BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS raw.accounts (
    account_id      VARCHAR(36) PRIMARY KEY,
    customer_id     VARCHAR(36),
    account_type    VARCHAR(30), -- CHECKING, SAVINGS, TERM_DEPOSIT
    status          VARCHAR(20), -- ACTIVE, CLOSED, FROZEN
    currency        VARCHAR(3) DEFAULT 'USD',
    balance         NUMERIC(18,2),
    opened_date     DATE,
    closed_date     DATE,
    created_at      TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.transactions (
    transaction_id  VARCHAR(36) PRIMARY KEY,
    account_id      VARCHAR(36),
    txn_type        VARCHAR(30), -- DEPOSIT, WITHDRAWAL, TRANSFER, FEE
    amount          NUMERIC(18,2),
    txn_date        TIMESTAMP,
    channel         VARCHAR(30), -- BRANCH, ATM, MOBILE, ONLINE
    status          VARCHAR(20), -- COMPLETED, FAILED, REVERSED
    description     TEXT,
    created_at      TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.loans (
    loan_id         VARCHAR(36) PRIMARY KEY,
    customer_id     VARCHAR(36),
    loan_type       VARCHAR(30), -- PERSONAL, MORTGAGE, AUTO, BUSINESS
    principal       NUMERIC(18,2),
    outstanding     NUMERIC(18,2),
    interest_rate   NUMERIC(5,2),
    issue_date      DATE,
    due_date        DATE,
    loan_status     VARCHAR(20), -- CURRENT, OVERDUE, DEFAULT, PAID_OFF
    days_past_due   INTEGER DEFAULT 0,
    created_at      TIMESTAMP
);