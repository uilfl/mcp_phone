const express = require('express');
const router = express.Router();
const authRoutes = require('./auth');
const chatRoutes = require('./chat');
const profileRoutes = require('./profiles');

// Mount routes
router.use('/auth', authRoutes);
router.use('/chat', chatRoutes);
router.use('/profiles', profileRoutes);

// API info endpoint
router.get('/', (req, res) => {
  res.json({
    name: 'MCP Gateway API',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      chat: '/api/chat',
      profiles: '/api/profiles',
    },
  });
});

module.exports = router;
