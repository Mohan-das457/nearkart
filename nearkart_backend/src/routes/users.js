const router = require('express').Router();
const { getUsers, getUser, updateUser, toggleUser } = require('../controllers/usersController');
const { adminAuth } = require('../middleware/auth');

router.get('/',            adminAuth, getUsers);
router.get('/:id',         adminAuth, getUser);
router.put('/:id',         adminAuth, updateUser);
router.patch('/:id/toggle',adminAuth, toggleUser);

module.exports = router;
