#!/usr/bin/env node
'use strict';

const path = require('node:path');
const fs = require('node:fs');
const { spawnSync } = require('node:child_process');

const AGENTS = ['claude', 'codex', 'cursor', 'opencode'];
const COMMANDS = ['install', 'uninstall'];

const USAGE = `bipit — turn your agent session into a build-in-public post

Usage:
  npx bipit [install] --agent <a> [--scope user|project] [--prefix DIR] [--copy] [--dry-run]
  npx bipit uninstall --agent <a> [--scope user|project] [--prefix DIR]

  <a>: claude | codex | cursor | opencode | all

After installing, open your agent and run: /bipit`;

function buildArgs(argv) {
  const args = argv.slice();
  let command = 'install';
  if (args[0] && !args[0].startsWith('-')) {
    command = args.shift();
  }
  if (!COMMANDS.includes(command)) {
    throw new Error(`Unknown command: ${command}`);
  }

  let agent;
  const scriptArgs = [];
  for (let i = 0; i < args.length; i++) {
    const a = args[i];
    if (a === '--agent') {
      agent = args[++i];
      scriptArgs.push('--agent', agent);
    } else {
      scriptArgs.push(a);
    }
  }

  if (!agent) {
    throw new Error('--agent is required');
  }

  let perAgent = null;
  if (agent === 'all') {
    perAgent = AGENTS.slice();
  } else if (!AGENTS.includes(agent)) {
    throw new Error(`Unsupported agent: ${agent}`);
  }

  return { command, agent, perAgent, scriptArgs };
}

function resolveScript(command) {
  return path.join(__dirname, '..', 'scripts', `${command}.sh`);
}

function run(argv) {
  if (argv.length === 0 || argv[0] === '-h' || argv[0] === '--help') {
    console.log(USAGE);
    process.exit(0);
  }

  let parsed;
  try {
    parsed = buildArgs(argv);
  } catch (err) {
    console.error(err.message);
    console.error('\n' + USAGE);
    process.exit(2);
  }

  const script = resolveScript(parsed.command);
  if (!fs.existsSync(script)) {
    console.error(`Missing script: ${script}`);
    process.exit(1);
  }

  const agents = parsed.perAgent || [parsed.agent];
  let failures = 0;
  for (const ag of agents) {
    const agentArgs = parsed.scriptArgs.map((value, i) =>
      parsed.scriptArgs[i - 1] === '--agent' ? ag : value
    );
    const res = spawnSync('sh', [script, ...agentArgs], { stdio: 'inherit' });
    if (res.status !== 0) {
      failures++;
    }
  }
  process.exit(failures > 0 ? 1 : 0);
}

if (require.main === module) {
  run(process.argv.slice(2));
}

module.exports = { buildArgs, resolveScript, AGENTS, COMMANDS };
