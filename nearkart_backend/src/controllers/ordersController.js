const Order = require('../models/Order');

const getOrders = async (req, res) => {
  const filter = {};
  if (req.query.userId)  filter.userId  = req.query.userId;
  if (req.query.storeId) filter.storeId = req.query.storeId;
  if (req.query.agentId) filter.agentId = req.query.agentId;
  if (req.query.status)  filter.status  = req.query.status;
  const orders = await Order.find(filter)
    .populate('userId', 'name phone')
    .populate('storeId', 'name address')
    .populate('agentId', 'name phone')
    .sort({ createdAt: -1 });
  res.json(orders);
};

const getOrder = async (req, res) => {
  const order = await Order.findById(req.params.id)
    .populate('userId', 'name phone')
    .populate('storeId', 'name address')
    .populate('agentId', 'name phone');
  if (!order) return res.status(404).json({ message: 'Order not found' });
  res.json(order);
};

const createOrder = async (req, res) => {
  const order = await Order.create({ ...req.body, userId: req.user.id });
  res.status(201).json(order);
};

const updateOrderStatus = async (req, res) => {
  const { status, agentId } = req.body;
  const update = { status };
  if (agentId) update.agentId = agentId;
  const order = await Order.findByIdAndUpdate(req.params.id, update, { new: true });
  if (!order) return res.status(404).json({ message: 'Order not found' });
  res.json(order);
};

// Admin stats
const getStats = async (req, res) => {
  const [total, pending, delivered, cancelled] = await Promise.all([
    Order.countDocuments(),
    Order.countDocuments({ status: 'pending' }),
    Order.countDocuments({ status: 'delivered' }),
    Order.countDocuments({ status: 'cancelled' }),
  ]);
  const revenueResult = await Order.aggregate([
    { $match: { status: 'delivered' } },
    { $group: { _id: null, total: { $sum: '$total' } } },
  ]);
  const revenue = revenueResult[0]?.total ?? 0;
  res.json({ total, pending, delivered, cancelled, revenue });
};

module.exports = { getOrders, getOrder, createOrder, updateOrderStatus, getStats };
