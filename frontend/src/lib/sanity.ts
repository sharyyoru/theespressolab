import { createClient } from '@sanity/client'
import imageUrlBuilder from '@sanity/image-url'

const projectId = process.env.REACT_APP_SANITY_PROJECT_ID || ''
const dataset = process.env.REACT_APP_SANITY_DATASET || 'production'

export const sanityClient = createClient({
  projectId,
  dataset,
  useCdn: true,
  apiVersion: '2024-01-01'
})

const builder = imageUrlBuilder(sanityClient)

export const urlFor = (source: any) => {
  return builder.image(source)
}

// Sanity queries
export const queries = {
  siteSettings: `*[_type == "siteSettings"][0]{
    title,
    logo,
    logoLight,
    favicon,
    ogImage,
    topBanner,
    socialMedia,
    contact,
    defaultCurrency
  }`,
  
  products: `*[_type == "product" && is_active == true] | order(_createdAt desc) {
    _id,
    sku,
    "name_en": name.en,
    "name_ar": name.ar,
    "description_en": description.en,
    "description_ar": description.ar,
    price,
    sale_price,
    "category": category->{"name_en": name.en, "name_ar": name.ar, slug},
    "collections": collections[]->{"title_en": title.en, "title_ar": title.ar, slug},
    images,
    variants,
    is_active,
    is_featured
  }`,
  
  featuredProducts: `*[_type == "product" && is_active == true && is_featured == true] | order(_createdAt desc) [0...10] {
    _id,
    sku,
    "name_en": name.en,
    "name_ar": name.ar,
    price,
    sale_price,
    "category": category->{"name_en": name.en, slug},
    images
  }`,
  
  collections: `*[_type == "collection"] | order(order asc) {
    _id,
    "title_en": title.en,
    "title_ar": title.ar,
    "description_en": description.en,
    "description_ar": description.ar,
    slug,
    image,
    order
  }`,
  
  categories: `*[_type == "category"] | order(order asc) {
    _id,
    "name_en": name.en,
    "name_ar": name.ar,
    slug,
    icon,
    order
  }`
}
