require('dotenv').config()
const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const bcrypt = require('bcrypt');
const session = require('express-session');
const app = express();
const PORT = 3000;

// Postgres connection
const pool = new Pool({
  user:     process.env.DB_USER,
  host:     process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port:     process.env.DB_PORT,
});

app.use(express.json());
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false }
}));
app.use(express.static(path.join(__dirname, 'public')));

// Auth middleware
function requireAuth(req, res, next) {
  if (req.session.userId) return next();
  res.status(401).json({ error: 'Unauthorized' });
}

// Register
app.post('/api/auth/register', async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Username and password required' });
  try {
    const hash = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO users (username, password_hash) VALUES ($1, $2) RETURNING user_id, username',
      [username, hash]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    if (err.code === '23505') return res.status(409).json({ error: 'Username already exists' });
    res.status(500).json({ error: 'Database error' });
  }
});

// Login
app.post('/api/auth/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
    if (!result.rows.length) return res.status(401).json({ error: 'Invalid credentials' });
    const valid = await bcrypt.compare(password, result.rows[0].password_hash);
    if (!valid) return res.status(401).json({ error: 'Invalid credentials' });
    req.session.userId = result.rows[0].user_id;
    req.session.username = result.rows[0].username;
    res.json({ message: 'Logged in', username: result.rows[0].username });
  } catch (err) {
    res.status(500).json({ error: 'Database error' });
  }
});

// Logout
app.post('/api/auth/logout', (req, res) => {
  req.session.destroy();
  res.json({ message: 'Logged out' });
});

// Check current session
app.get('/api/auth/me', (req, res) => {
  if (req.session.userId) {
    res.json({ username: req.session.username });
  } else {
    res.status(401).json({ error: 'Not logged in' });
  }
});

// GET all customers
app.get('/api/customers', requireAuth, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM customers ORDER BY customer_id');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// POST new customer
app.post('/api/customers', requireAuth, async (req, res) => {
  const { first_name, last_name, universe, phone, email } = req.body;

  if (!first_name || !universe) {
    return res.status(400).json({ error: 'first_name and universe are required' });
  }

  try {
    const result = await pool.query(
      `INSERT INTO customers (first_name, last_name, universe, phone, email, loyalty_points)
       VALUES ($1, $2, $3, $4, $5, 0)
       RETURNING *`,
      [first_name, last_name || null, universe, phone || null, email || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});
// Check current session
app.get('/api/auth/me', (req, res) => {
  if (req.session.userId) {
    res.json({ username: req.session.username });
  } else {
    res.status(401).json({ error: 'Not logged in' });
  }
});
// PUT update customer
app.put('/api/customers/:id', requireAuth, async (req, res) => {
  const { id } = req.params;
  const { first_name, last_name, universe, phone, email } = req.body;

  if (!first_name || !universe) {
    return res.status(400).json({ error: 'first_name and universe are required' });
  }

  try {
    const result = await pool.query(
      `UPDATE customers
       SET first_name=$1, last_name=$2, universe=$3, phone=$4, email=$5
       WHERE customer_id=$6
       RETURNING *`,
      [first_name, last_name || null, universe, phone || null, email || null, id]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Customer not found' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// DELETE customer
app.delete('/api/customers/:id', requireAuth, async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      'DELETE FROM customers WHERE customer_id=$1 RETURNING *',
      [id]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Customer not found' });
    res.json({ message: 'Deleted', customer: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Toon Cleaners running at http://localhost:${PORT}`);
});
