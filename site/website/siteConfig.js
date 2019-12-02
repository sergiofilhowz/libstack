/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// See https://docusaurus.io/docs/site-config for all the possible
// site configuration options.

// List of projects/orgs using your project for the users page.
const users = [
  {
    caption: 'User1',
    // You will need to prepend the image path with your baseUrl
    // if it is not '/', like: '/test-site/img/image.jpg'.
    image: '/img/undraw_open_source.svg',
    infoLink: 'https://www.facebook.com',
    pinned: true,
  },
];

const siteConfig = {
  title: 'Libstack', // Title for your website.
  tagline: 'Because you don\'t need a framework',
  url: 'https://libstack.github.io', // Your website URL
  baseUrl: '/docs/', // Base URL for your project */

  gaTrackingId: 'UA-153496698-1',

  projectName: 'docs',
  organizationName: 'libstack-project',

  // algolia: {
  //   appId: 'A07TWX0DG4',
  //   apiKey: '408e924977df0c0218fb32733e3fac85',
  //   indexName: 'github',
  // },

  // For no header links in the top nav bar -> headerLinks: [],
  headerLinks: [
    {doc: 'libstack', label: 'Docs'},
    // {doc: 'doc4', label: 'API'},
    {page: 'help', label: 'Help'},
    // {blog: true, label: 'Blog'},
  ],

  // If you have users set above, you add it here:
  users,

  /* path to images for header/footer */
  headerIcon: 'img/libstack.svg',
  footerIcon: 'img/libstack-white.svg',
  favicon: 'img/libstack.png',

  /* Colors for website */
  colors: {
    primaryColor: '#7a62f3',
    secondaryColor: '#4d566c',
  },

  /* Custom fonts for website */
  fonts: {
    myFont: [
      'Muli',
      'Serif'
    ],
    myOtherFont: [
      'Muli',
      '-apple-system',
      'system-ui'
    ]
  },

  stylesheets: [
    'https://fonts.googleapis.com/css?family=Muli:400,500,600,700',
  ],

  // This copyright info is used in /core/Footer.js and blog RSS/Atom feeds.
  copyright: `Copyright © ${new Date().getFullYear()} Sérgio Marcelino`,

  highlight: {
    // Highlight.js theme to use for syntax highlighting in code blocks.
    theme: 'default',
  },

  // Add custom scripts here that would be placed in <script> tags.
  scripts: ['https://buttons.github.io/buttons.js'],

  // On page navigation for the current documentation page.
  onPageNav: 'separate',
  // No .html extensions for paths.
  cleanUrl: true,

  // Open Graph and Twitter card images.
  ogImage: 'img/libstack.png',
  twitterImage: 'img/libstack.png',

  // For sites with a sizable amount of content, set collapsible to true.
  // Expand/collapse the links and subcategories under categories.
  // docsSideNavCollapsible: true,

  // Show documentation's last contributor's name.
  // enableUpdateBy: true,

  // Show documentation's last update time.
  // enableUpdateTime: true,

  // You may provide arbitrary config keys to be used as needed by your
  // template. For example, if you need your repo's URL...
    repoUrl: 'https://github.com/sergiofilhowz/libstack',
};

module.exports = siteConfig;
