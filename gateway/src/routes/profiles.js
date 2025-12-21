const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');
const { ProfileService } = require('../services/profileService');
const { logger } = require('../config/logger');

const profileService = new ProfileService();

// Get all profiles
router.get('/', authenticateToken, async (req, res) => {
  try {
    const profiles = await profileService.getAllProfiles();
    
    res.json({
      success: true,
      data: {
        profiles,
        count: profiles.length,
      },
    });
  } catch (error) {
    logger.error('Error fetching profiles:', error);
    res.status(500).json({
      success: false,
      error: { message: 'Failed to fetch profiles' },
    });
  }
});

// Get specific profile
router.get('/:profileId', authenticateToken, async (req, res) => {
  try {
    const { profileId } = req.params;
    const profile = await profileService.getProfile(profileId);
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        error: { message: 'Profile not found' },
      });
    }
    
    res.json({
      success: true,
      data: { profile },
    });
  } catch (error) {
    logger.error('Error fetching profile:', error);
    res.status(500).json({
      success: false,
      error: { message: 'Failed to fetch profile' },
    });
  }
});

// Get profile capabilities
router.get('/:profileId/capabilities', authenticateToken, async (req, res) => {
  try {
    const { profileId } = req.params;
    const capabilities = await profileService.getProfileCapabilities(profileId);
    
    res.json({
      success: true,
      data: { capabilities },
    });
  } catch (error) {
    logger.error('Error fetching capabilities:', error);
    res.status(500).json({
      success: false,
      error: { message: 'Failed to fetch capabilities' },
    });
  }
});

module.exports = router;
