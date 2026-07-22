const router = require('express').Router();
const { getOrders, getOrder, createOrder, updateOrderStatus, getStats } = require('../controllers/ordersController');
const { auth, adminAuth } = require('../middleware/auth');

router.get('/stats',  adminAuth, getStats);
router.get('/',       auth, getOrders);
router.get('/:id',    auth, getOrder);
router.post('/',      auth, createOrder);
router.patch('/:id/status', auth, updateOrderStatus);

module.exports = router;
