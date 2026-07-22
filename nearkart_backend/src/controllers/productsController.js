const Product = require('../models/Product');

const getProducts = async (req, res) => {
  const filter = { isActive: true };
  if (req.query.storeId) filter.storeId = req.query.storeId;
  if (req.query.category) filter.category = req.query.category;
  const products = await Product.find(filter);
  res.json(products);
};

const getProduct = async (req, res) => {
  const product = await Product.findById(req.params.id).populate('storeId', 'name address');
  if (!product) return res.status(404).json({ message: 'Product not found' });
  res.json(product);
};

const createProduct = async (req, res) => {
  const product = await Product.create(req.body);
  res.status(201).json(product);
};

const updateProduct = async (req, res) => {
  const product = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
  if (!product) return res.status(404).json({ message: 'Product not found' });
  res.json(product);
};

const deleteProduct = async (req, res) => {
  await Product.findByIdAndUpdate(req.params.id, { isActive: false });
  res.json({ message: 'Product deactivated' });
};

module.exports = { getProducts, getProduct, createProduct, updateProduct, deleteProduct };
