'use strict';
const { test } = require('node:test');
const assert = require('node:assert');
const path = require('node:path');
const { buildArgs, resolveScript, AGENTS } = require('../bin/cli.js');

test('maps install flags straight through to the script', () => {
  const { command, agent, scriptArgs } = buildArgs([
    'install', '--agent', 'claude', '--scope', 'user', '--dry-run',
  ]);
  assert.equal(command, 'install');
  assert.equal(agent, 'claude');
  assert.deepEqual(scriptArgs, ['--agent', 'claude', '--scope', 'user', '--dry-run']);
});

test('defaults the command to install', () => {
  const { command } = buildArgs(['--agent', 'codex']);
  assert.equal(command, 'install');
});

test('accepts the uninstall command', () => {
  const { command } = buildArgs(['uninstall', '--agent', 'cursor']);
  assert.equal(command, 'uninstall');
});

test('requires --agent', () => {
  assert.throws(() => buildArgs(['install']), /--agent is required/);
});

test('rejects an unknown agent', () => {
  assert.throws(() => buildArgs(['install', '--agent', 'bogus']), /Unsupported agent/);
});

test('rejects an unknown command', () => {
  assert.throws(() => buildArgs(['deploy', '--agent', 'claude']), /Unknown command/);
});

test('expands --agent all to every supported agent', () => {
  const { perAgent } = buildArgs(['install', '--agent', 'all']);
  assert.deepEqual(perAgent, ['claude', 'codex', 'cursor', 'opencode']);
  assert.deepEqual(AGENTS, ['claude', 'codex', 'cursor', 'opencode']);
});

test('resolveScript points at the matching shell script', () => {
  assert.equal(resolveScript('install'), path.join(__dirname, '..', 'scripts', 'install.sh'));
  assert.equal(resolveScript('uninstall'), path.join(__dirname, '..', 'scripts', 'uninstall.sh'));
});
