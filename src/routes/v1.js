import express from 'express';
const router = express.Router();

import userModule from './modules/todo.modulepost';

router.use('/users', userModule)

import todoModule from './modules/todo.moduleusers';
router.use('/todos', todoModule);

module.exports = router;