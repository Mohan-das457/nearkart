const router = require('express').Router();
const { sendOtp, verifyOtp, adminLogin } = require('../controllers/authController');

router.post('/send-otp',    sendOtp);
router.post('/verify-otp',  verifyOtp);
router.post('/admin-login', adminLogin);

module.exports = router;
