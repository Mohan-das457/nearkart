const router = require('express').Router();
const { getAgents, getAgent, createAgent, updateAgent, toggleAgent } = require('../controllers/agentsController');
const { adminAuth } = require('../middleware/auth');

router.get('/',             adminAuth, getAgents);
router.get('/:id',          adminAuth, getAgent);
router.post('/',            adminAuth, createAgent);
router.put('/:id',          adminAuth, updateAgent);
router.patch('/:id/toggle', adminAuth, toggleAgent);

module.exports = router;
