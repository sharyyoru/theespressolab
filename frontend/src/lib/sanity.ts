import { createClient } from '@sanity/client'

const projectId = process.env.REACT_APP_SANITY_PROJECT_ID || ''
const dataset = process.env.REACT_APP_SANITY_DATASET || 'production'

export const sanityClient = createClient({
  projectId,
  dataset,
  useCdn: true,
  apiVersion: '2024-01-01'
})

// Image URL builder - install @sanity/image-url when needed
export const urlFor = (source: any) => {
  // Placeholder - will be implemented when @sanity/image-url is properly configured
  return source
}
