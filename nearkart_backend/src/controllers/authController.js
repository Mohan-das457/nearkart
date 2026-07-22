const jwt = require('jsonwebtoken');
const User  = require('../models/User');
const Store = require('../models/Store');
const Agent = require('../models/Agent');

const sign = (payload) =>
  jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });

// In production replace with real OTP service. Fixed OTP for dev.
const DEV_OTP = '123456';

// POST /api/auth/send-otp
const sendOtp = async (req, res) => {
  const { phone } = req.body;
  if (!phone) return res.status(400).json({ message: 'Phone required' });
  // TODO: integrate SMS gateway
  res.json({ message: 'OTP sent', otp: DEV_OTP }); // remove otp field in production
};

// POST /api/auth/verify-otp  { phone, otp, role: 'customer'|'seller'|'agent' }
const verifyOtp = async (req, res) => {
  const { phone, otp, role = 'customer' } = req.body;
  if (otp !== DEV_OTP) return res.status(400).json({ message: 'Invalid OTP' });

  let entity;
  if (role === 'customer') {
    entity = await User.findOneAndUpdate(
      { phone },
      { phone },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );
  } else if (role === 'seller') {
    entity = await Store.findOne({ ownerPhone: phone });
    if (!entity) return res.status(404).json({ message: 'Store not registered' });
  } else if (role === 'agent') {
    entity = await Agent.findOne({ phone });
    if (!entity) return res.status(404).json({ message: 'Agent not registered' });
  } else {
    return res.status(400).json({ message: 'Invalid role' });
  }

  const token = sign({ id: entity._id, role });
  res.json({ token, role, id: entity._id });
};

// POST /api/auth/admin-login  { username, password }
const adminLogin = (req, res) => {
  const { username, password } = req.body;
  if (username !== process.env.ADMIN_USER || password !== process.env.ADMIN_PASS) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }
  const token = sign({ id: 'admin', role: 'admin' });
  res.json({ token, role: 'admin' });
};

module.exports = { sendOtp, verifyOtp, adminLogin };
