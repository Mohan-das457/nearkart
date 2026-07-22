const router = require('express').Router();
const { getStores, getStore, createStore, updateStore, deleteStore } = require('../controllers/storesController');
const { auth, adminAuth } = require('../middleware/auth');

router.get('/',       getStores);
router.get('/:id',    getStore);
router.post('/',      adminAuth, createStore);
router.put('/:id',    adminAuth, updateStore);
router.delete('/:id', adminAuth, deleteStore);

module.exports = router;
