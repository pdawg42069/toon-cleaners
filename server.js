require('dotenv').config()
const express = require('express');
const { Pool } = require('pg');
const path = require('path');

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
app.use(express.static(path.join(__dirname, 'public')));

// GET all customers
app.get('/api/customers', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM customers ORDER BY customer_id');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// POST new customer
app.post('/api/customers', async (req, res) => {
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

// PUT update customer
app.put('/api/customers/:id', async (req, res) => {
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
app.delete('/api/customers/:id', async (req, res) => {
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
