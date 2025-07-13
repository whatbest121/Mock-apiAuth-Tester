const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Mock Data
const users = [
  { id: 1, phone_number: '0970177079', status: 'active' }
];

// Utility Functions
const validatePhoneNumber = (phone) => {
  const phoneRegex = /^0[0-9]{9}$/;
  return phoneRegex.test(phone);
};

const userExists = (phone) => {
  return users.some(user => user.phone_number === phone);
};

// Routes
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Mock server is running' });
});

app.get('/api/auth', (_, res) => {
  res.json(users)
})

app.get('/api/auth/:user_id', (req, res) => {
  const result = []
  users.map((v) => {
    if (v.id === Number(req.params.user_id)) {
      result.push(v)
    }
  })
  if (result[0] === undefined) throw new Error("user not found.")
  res.json(result[0])
})

app.post('/api/auth/login', (req, res) => {
  const { phone_number } = req.body;

  // Check if phone number is provided
  if (!phone_number) {
    return res.status(400).json({
      error: 'Phone number is required',
      code: 400
    });
  }

  // Validate phone number format
  if (!validatePhoneNumber(phone_number)) {
    return res.status(400).json({
      error: 'Invalid phone number format',
      code: 400
    });
  }

  // Check if user exists
  if (!userExists(phone_number)) {
    return res.status(400).json({
      error: 'Phone number not registered',
      code: 400
    });
  }

  // Success response
  res.json({
    access_token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock.token',
    user_id: 1,
    message: 'Login successful'
  });
});

app.post('/api/auth/register', (req, res) => {
  const { phone_number } = req.body;

  // Check if phone number is provided
  if (!phone_number) {
    return res.status(400).json({
      error: 'Phone number is required',
      code: 400
    });
  }

  // Validate phone number format
  if (!validatePhoneNumber(phone_number)) {
    return res.status(400).json({
      error: 'Invalid phone number format',
      code: 400
    });
  }

  // Check if user already exists
  if (userExists(phone_number)) {
    return res.status(400).json({
      error: 'Phone number already exists',
      code: 400
    });
  }

  // Create new user
  const newUser = {
    id: users.length + 1,
    phone_number: phone_number,
    status: 'active'
  };

  users.push(newUser);

  // Success response
  res.json({
    user_id: newUser.id,
    message: 'Registration successful'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Mock server running on http://localhost:${PORT}`);
  console.log('Available endpoints:');
  console.log('- GET /api/health');
  console.log('- POST /api/auth/login');
  console.log('- POST /api/auth/register');
});