const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('daisyui'),
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ],
  daisyui: {
    themes: [
      {
        light: {
          "primary": "#0ea5e9",        // sky-500
          "primary-content": "#ffffff", // white text
          "secondary": "#64748b",      // slate-500
          "accent": "#38bdf8",         // sky-400
          "neutral": "#e2e8f0",        // slate-200
          "neutral-content": "#1e293b", // slate-800
          "base-100": "#ffffff",       // white background
          "info": "#3abff8",
          "success": "#36d399",
          "warning": "#fbbd23",
          "error": "#f87272",
          "--rounded-btn": "0.75rem",  // rounded-xl
        },
      },
    ],
  },
}
