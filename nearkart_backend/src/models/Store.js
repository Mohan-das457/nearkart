const mongoose = require('mongoose');

const storeSchema = new mongoose.Schema({
  name:           { type: String, required: true },
  ownerPhone:     { type: String, required: true, unique: true },
  category:       { type: String, required: true },
  description:    { type: String, default: '' },
  address:        { type: String, required: true },
  banner:         { type: String, default: '' },
  rating:         { type: Number, default: 0 },
  deliveryMinutes:{ type: Number, default: 30 },
  minOrder:       { type: Number, default: 0 },
  deliveryFee:    { type: Number, default: 0 },
  isOpen:         { type: Boolean, default: true },
  isActive:       { type: Boolean, default: true },
}, { timestamps: true });

module.exports = mongoose.model('Store', storeSchema);
