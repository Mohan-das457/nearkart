const Agent = require('../models/Agent');

const getAgents = async (req, res) => {
  const agents = await Agent.find().sort({ createdAt: -1 });
  res.json(agents);
};

const getAgent = async (req, res) => {
  const agent = await Agent.findById(req.params.id);
  if (!agent) return res.status(404).json({ message: 'Agent not found' });
  res.json(agent);
};

const createAgent = async (req, res) => {
  const agent = await Agent.create(req.body);
  res.status(201).json(agent);
};

const updateAgent = async (req, res) => {
  const agent = await Agent.findByIdAndUpdate(req.params.id, req.body, { new: true });
  if (!agent) return res.status(404).json({ message: 'Agent not found' });
  res.json(agent);
};

const toggleAgent = async (req, res) => {
  const agent = await Agent.findById(req.params.id);
  if (!agent) return res.status(404).json({ message: 'Agent not found' });
  agent.isActive = !agent.isActive;
  await agent.save();
  res.json(agent);
};

module.exports = { getAgents, getAgent, createAgent, updateAgent, toggleAgent };
