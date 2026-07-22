const mongoose = require('mongoose');

const orderItemSchema = new mongoose.Schema({
  productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
  name:      { type: String, required: true },
  price:     { type: Number, required: true },
  qty:       { type: Number, required: true },
  unit:      { type: String, default: '' },
});

const orderSchema = new mongoose.Schema({
  userId:          { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  storeId:         { type: mongoose.Schema.Types.ObjectId, ref: 'Store', required: true },
  agentId:         { type: mongoose.Schema.Types.ObjectId, ref: 'Agent', default: null },
  items:           [orderItemSchema],
  subtotal:        { type: Number, required: true },
  deliveryFee:     { type: Number, default: 0 },
  discount:        { type: Number, default: 0 },
  total:           { type: Number, required: true },
  deliveryAddress: { type: String, required: true },
  paymentMethod:   { type: String, default: 'Cash on Delivery' },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled'],
    default: 'pending',
  },
}, { timestamps: true });

module.exports = mongoose.model('Order', orderSchema);
