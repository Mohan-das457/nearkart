const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  storeId:       { type: mongoose.Schema.Types.ObjectId, ref: 'Store', required: true },
  name:          { type: String, required: true },
  category:      { type: String, required: true },
  price:         { type: Number, required: true },
  originalPrice: { type: Number, required: true },
  unit:          { type: String, default: '' },
  image:         { type: String, default: '' },
  description:   { type: String, default: '' },
  stock:         { type: Number, default: 0 },
  isActive:      { type: Boolean, default: true },
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema);
