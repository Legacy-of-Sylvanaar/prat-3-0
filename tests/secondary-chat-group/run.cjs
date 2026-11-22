const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const cp = require('node:child_process');
const parser = require('luaparse');
const root = path.resolve(__dirname, '../..');
const read = name => fs.readFileSync(path.join(__dirname, name), 'utf8');
const addon = fs.readFileSync(path.join(root, 'modules/SecondaryChatGroup.lua'), 'utf8');
parser.parse(addon, { luaVersion: '5.1' });
console.log('PASS Lua 5.1 syntax');
const cli = require.resolve('fengari-node-cli/src/lua-cli.js');
const onHide = read('fixtures/ForeverOnHide.lua');
const temporary = fs.mkdtempSync(path.join(os.tmpdir(), 'prat-secondary-tests-'));
const wrap = text => `;(function()\n${text}\nend)();\n`;
function run(name, parts, success) {
  const file = path.join(temporary, name + '.lua');
  fs.writeFileSync(file, parts.join('\n'));
  const result = cp.spawnSync(process.execPath, [cli, file], { encoding: 'utf8' });
  process.stdout.write(result.stdout || '');
  process.stderr.write(result.stderr || '');
  if (result.error) throw result.error;
  if (result.status !== 0 || !result.stdout.includes(success) || result.stdout.includes('INTEGRATION ERROR')) {
    throw new Error(`${name} failed`);
  }
}
try {
  for (const classic of [false, true]) {
    console.log(`Testing ${classic ? 'Classic' : 'modern'} UI APIs`);
    run(classic ? 'classic' : 'modern', [
      `TEST_CLASSIC = ${classic}`, read('harness.lua'), onHide, addon, read('cases.lua'),
    ], '29 tests passed');
  }
  // Optional integration test uses real installed Ace libraries. No account files
  // are read or modified. Prat's module loader is always the current checkout.
  if (process.env.PRAT_PATH) {
    const parts = [read('harness.lua'), onHide, read('integration-environment.lua')];
    for (const lib of ['LibStub', 'CallbackHandler-1.0', 'AceAddon-3.0', 'AceDB-3.0', 'AceHook-3.0', 'AceConsole-3.0', 'AceEvent-3.0']) {
      parts.push(wrap(fs.readFileSync(path.join(process.env.PRAT_PATH, 'Libs', lib, `${lib}.lua`), 'utf8')));
    }
    parts.push(read('integration-setup.lua'));
    parts.push(`;(function(...)\n${fs.readFileSync(path.join(root, 'addon/modules.lua'), 'utf8')}\nend)('Prat-3.0', Prat);`);
    parts.push(wrap(addon), 'Prat:LoadModules()', read('integration-cases.lua'));
    run('integration', parts, '4 integration tests passed');
  } else {
    console.log('SKIP installed Ace integration (set PRAT_PATH to an installed Prat folder to enable)');
  }
} finally {
  // Remove only the exact disposable directory created by mkdtemp above.
  if (path.dirname(path.resolve(temporary)) !== path.resolve(os.tmpdir()) || !path.basename(temporary).startsWith('prat-secondary-tests-')) {
    throw new Error('Unexpected temporary directory; refusing cleanup');
  }
  fs.rmSync(temporary, { recursive: true, force: true });
}
