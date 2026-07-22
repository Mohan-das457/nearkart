const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name:    { type: String, default: '' },
  phone:   { type: String, required: true, unique: true },
  address: { type: String, default: '' },
  isActive:{ type: Boolean, default: true },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
