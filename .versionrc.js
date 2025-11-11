/**
 * AI Diagrams Toolkit - commit-and-tag-version configuration
 *
 * IMPORTANT: Must be .versionrc.js (not .json) to load external templates
 *
 * Version: Explicit configuration for commit-and-tag-version@12.4.4
 * Spec: conventional-changelog-config-spec v2.2.0
 * Last Updated: 2025-11-10
 */

const fs = require('fs');
const path = require('path');

// Helper to load template files
function loadTemplate(filename) {
  return fs.readFileSync(
    path.join(__dirname, '.changelog-templates', filename),
    'utf-8'
  );
}

module.exports = {
  // ── Header & CHANGELOG ────────────────────────────────────────────────────
  header: '# Changelog\n\nAll notable changes to this project will be documented in this file.\n\nThe format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),\nand this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).\n',

  infile: 'CHANGELOG.md',

  // ── Commit Types (Keep a Changelog mapping) ──────────────────────────────
  // Maps Conventional Commits types to Keep a Changelog sections
  // See: https://keepachangelog.com/en/1.0.0/
  types: [
    { type: 'feat', section: 'Added', hidden: false },              // NEW features
    { type: 'fix', section: 'Fixed', hidden: false },               // BUG fixes
    { type: 'perf', section: 'Changed', hidden: false },            // PERFORMANCE improvements
    { type: 'docs', section: 'Documentation', hidden: false },      // DOCUMENTATION changes
    { type: 'revert', section: 'Reverted', hidden: false },         // REVERTED changes
    { type: 'security', section: 'Security', hidden: false },       // SECURITY fixes
    { type: 'deprecate', section: 'Deprecated', hidden: false },    // DEPRECATIONS
    { type: 'remove', section: 'Removed', hidden: false },          // REMOVED features
    { type: 'refactor', section: 'Changed', hidden: true },         // Internal refactoring (hidden)
    { type: 'style', section: 'Changed', hidden: true },            // Code style (hidden)
    { type: 'test', section: 'Changed', hidden: true },             // Tests (hidden)
    { type: 'build', section: 'Changed', hidden: true },            // Build system (hidden)
    { type: 'ci', section: 'Changed', hidden: true },               // CI/CD (hidden)
    { type: 'chore', section: 'Changed', hidden: true }             // Maintenance (hidden)
  ],

  // ── Versioning ────────────────────────────────────────────────────────────
  preMajor: false,

  packageFiles: [
    { filename: '.semver', type: 'plain-text' }
  ],

  bumpFiles: [
    { filename: '.semver', type: 'plain-text' }
  ],

  // ── Git Behavior ──────────────────────────────────────────────────────────
  tagPrefix: 'v',
  releaseCommitMessageFormat: 'chore(release): {{currentTag}}',
  sign: false,
  signoff: false,
  noVerify: false,
  commitAll: false,
  tagForce: false,
  gitTagFallback: true,
  firstRelease: true,

  // ── URLs & Links ──────────────────────────────────────────────────────────
  commitUrlFormat: '{{host}}/{{owner}}/{{repository}}/commit/{{hash}}',
  compareUrlFormat: '{{host}}/{{owner}}/{{repository}}/compare/{{previousTag}}...{{currentTag}}',
  issueUrlFormat: '{{host}}/{{owner}}/{{repository}}/issues/{{id}}',
  userUrlFormat: '{{host}}/{{user}}',
  issuePrefixes: ['#'],

  // ── Lifecycle Scripts ─────────────────────────────────────────────────────
  scripts: {
    prebump: '',
    prechangelog: '',
    precommit: '',
    pretag: '',
    posttag: ''
  },

  // ── Skip Options ──────────────────────────────────────────────────────────
  skip: {
    bump: false,
    changelog: false,
    commit: false,
    tag: false
  },

  // ── Other Options ─────────────────────────────────────────────────────────
  releaseCount: 1,
  silent: false,
  dryRun: false,

  // ── 🎨 EXPLICIT TEMPLATES (versionados, no defaults) ──────────────────────
  writerOpts: {
    mainTemplate: loadTemplate('template.hbs'),
    headerPartial: loadTemplate('header.hbs'),
    commitPartial: loadTemplate('commit.hbs'),
    footerPartial: loadTemplate('footer.hbs'),

    // Commit grouping and sorting
    groupBy: 'type',                     // Group commits by type
    commitsSort: ['scope', 'subject'],   // Sort commits by scope, then subject
    noteGroupsSort: 'title',             // Sort note groups by title
    noteSort: false,                     // Don't sort notes

    // Transform function - maps commit types to Keep a Changelog sections
    transform: (commit, context) => {
      // Map commit type to section (from types array above)
      const typeMapping = {
        'feat': 'Added',
        'fix': 'Fixed',
        'perf': 'Changed',
        'docs': 'Documentation',
        'revert': 'Reverted',
        'security': 'Security',
        'deprecate': 'Deprecated',
        'remove': 'Removed',
        'refactor': 'Changed',
        'style': 'Changed',
        'test': 'Changed',
        'build': 'Changed',
        'ci': 'Changed',
        'chore': 'Changed'
      };

      // Skip hidden types
      const hiddenTypes = ['refactor', 'style', 'test', 'build', 'ci', 'chore'];
      if (hiddenTypes.includes(commit.type)) {
        return null; // Skip this commit
      }

      // Set the section title based on type
      commit.type = typeMapping[commit.type] || commit.type;

      // Ensure shortHash exists (conventional-changelog provides this)
      if (typeof commit.hash === 'string' && !commit.shortHash) {
        commit.shortHash = commit.hash.substring(0, 7);
      }

      // Capitalize first letter of subject
      if (commit.subject) {
        commit.subject = commit.subject.charAt(0).toUpperCase() + commit.subject.slice(1);
      }

      return commit;
    }
  }
};
