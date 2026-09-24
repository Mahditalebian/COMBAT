// Auto-discovery shim: OpenCode loads any *.js in .opencode/plugin(s)/ when
// this repository is used in place. The implementation lives outside a dotted
// directory because npm omits dot-directories from published packages.
export { CombatPlugin } from '../../plugin/opencode.js';
export { default } from '../../plugin/opencode.js';
