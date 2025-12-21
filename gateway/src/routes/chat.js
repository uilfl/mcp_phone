const express = require('express');
const router = express.Router();
const Joi = require('joi');
const { authenticateToken } = require('../middleware/auth');
const { validateRequest } = require('../middleware/validator');
const { MCPService } = require('../services/mcpService');
const { logger } = require('../config/logger');

const mcpService = new MCPService();

// Chat message schema
const chatSchema = Joi.object({
  message: Joi.string().required().max(5000),
  profile_id: Joi.string().required(),
  conversation_id: Joi.string().optional(),
});

// Send message endpoint
router.post('/', authenticateToken, validateRequest(chatSchema), async (req, res) => {
  try {
    const { message, profile_id, conversation_id } = req.body;
    const userId = req.user.userId;

    logger.info('Processing chat message', {
      userId,
      profileId: profile_id,
      conversationId: conversation_id,
    });

    // Process message through MCP service
    const response = await mcpService.processMessage({
      userId,
      message,
      profileId: profile_id,
      conversationId: conversation_id,
    });

    res.json({
      success: true,
      data: {
        response: response.text,
        metadata: response.metadata,
        conversationId: response.conversationId,
      },
    });
  } catch (error) {
    logger.error('Chat error:', error);
    res.status(500).json({
      success: false,
      error: { message: 'Failed to process message' },
    });
  }
});

// Get conversation history
router.get('/history/:conversationId', authenticateToken, async (req, res) => {
  try {
    const { conversationId } = req.params;
    const userId = req.user.userId;

    // TODO: Implement conversation history retrieval
    res.json({
      success: true,
      data: {
        conversationId,
        messages: [],
      },
    });
  } catch (error) {
    logger.error('History fetch error:', error);
    res.status(500).json({
      success: false,
      error: { message: 'Failed to fetch conversation history' },
    });
  }
});

module.exports = router;
