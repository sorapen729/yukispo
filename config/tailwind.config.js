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
          "success": "#dcfce7",        // green-100相当（薄い緑の背景）
          "success-content": "#166534", // green-800相当（濃い緑の文字）
          "warning": "#fbbd23",
          "error": "#fee2e2",          // red-100相当（薄い赤の背景）
          "error-content": "#b91c1c",   // red-700相当（濃い赤の文字）
          "--rounded-btn": "0.75rem",  // rounded-xl
        },
      },
    ],
  },
}
