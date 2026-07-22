const Store = require('../models/Store');

const getStores = async (req, res) => {
  const stores = await Store.find({ isActive: true });
  res.json(stores);
};

const getStore = async (req, res) => {
  const store = await Store.findById(req.params.id);
  if (!store) return res.status(404).json({ message: 'Store not found' });
  res.json(store);
};

const createStore = async (req, res) => {
  const store = await Store.create(req.body);
  res.status(201).json(store);
};

const updateStore = async (req, res) => {
  const store = await Store.findByIdAndUpdate(req.params.id, req.body, { new: true });
  if (!store) return res.status(404).json({ message: 'Store not found' });
  res.json(store);
};

const deleteStore = async (req, res) => {
  await Store.findByIdAndUpdate(req.params.id, { isActive: false });
  res.json({ message: 'Store deactivated' });
};

module.exports = { getStores, getStore, createStore, updateStore, deleteStore };
