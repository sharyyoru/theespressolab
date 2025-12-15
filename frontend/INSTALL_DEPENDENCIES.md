# Install Required Dependencies

Run these commands in the frontend directory:

```bash
cd frontend

# Install TailwindCSS and dependencies
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Install additional UI libraries
npm install lucide-react
npm install embla-carousel-react
npm install clsx tailwind-merge

# Install fonts (if needed)
npm install @fontsource/inter @fontsource/playfair-display
```

Then run step 11 SQL for Supabase storage buckets.
