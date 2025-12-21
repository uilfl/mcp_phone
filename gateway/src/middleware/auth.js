const jwt = require('jsonwebtoken');
const { config } = require('../config');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      error: { message: 'Access token required' },
    });
  }

  jwt.verify(token, config.jwt.secret, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        error: { message: 'Invalid or expired token' },
      });
    }

    req.user = user;
    next();
  });
};

const generateToken = (userId, userInfo = {}) => {
  return jwt.sign(
    { userId, ...userInfo },
    config.jwt.secret,
    { expiresIn: config.jwt.expiresIn }
  );
};

module.exports = { authenticateToken, generateToken };
