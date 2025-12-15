/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'espresso': {
          black: '#1A1A1A',
          cream: '#E8E3D8',
          beige: '#D4CFC4',
          orange: '#E85D2A',
          brown: '#4A3428',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Inter', 'system-ui', 'sans-serif'],
      },
      letterSpacing: {
        'extra-wide': '0.15em',
      }
    },
  },
  plugins: [],
}
