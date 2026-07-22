const mongoose = require('mongoose');

const agentSchema = new mongoose.Schema({
  name:          { type: String, required: true },
  phone:         { type: String, required: true, unique: true },
  vehicleNumber: { type: String, default: '' },
  vehicleType:   { type: String, default: 'Motorcycle' },
  isOnline:      { type: Boolean, default: false },
  isActive:      { type: Boolean, default: true },
  rating:        { type: Number, default: 5.0 },
  totalDeliveries: { type: Number, default: 0 },
  totalEarnings:   { type: Number, default: 0 },
}, { timestamps: true });

module.exports = mongoose.model('Agent', agentSchema);
