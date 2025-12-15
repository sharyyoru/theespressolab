import { sanityClient, queries, urlFor } from './sanity';

// Fetch site settings
export const getSiteSettings = async () => {
  try {
    const data = await (sanityClient.fetch as any)(queries.siteSettings);
    return data;
  } catch (error) {
    console.error('Error fetching site settings:', error);
    return null;
  }
};

// Fetch all products
export const getProducts = async () => {
  try {
    const data = await (sanityClient.fetch as any)(queries.products);
    return data;
  } catch (error) {
    console.error('Error fetching products:', error);
    return [];
  }
};

// Fetch featured products
export const getFeaturedProducts = async () => {
  try {
    const data = await (sanityClient.fetch as any)(queries.featuredProducts);
    return data;
  } catch (error) {
    console.error('Error fetching featured products:', error);
    return [];
  }
};

// Fetch collections
export const getCollections = async () => {
  try {
    const data = await (sanityClient.fetch as any)(queries.collections);
    return data;
  } catch (error) {
    console.error('Error fetching collections:', error);
    return [];
  }
};

// Fetch categories
export const getCategories = async () => {
  try {
    const data = await (sanityClient.fetch as any)(queries.categories);
    return data;
  } catch (error) {
    console.error('Error fetching categories:', error);
    return [];
  }
};

// Helper to get optimized image URL
export const getImageUrl = (image: any, width?: number, height?: number) => {
  if (!image) return '';
  
  let urlBuilder = urlFor(image);
  
  if (width) urlBuilder = urlBuilder.width(width);
  if (height) urlBuilder = urlBuilder.height(height);
  
  return urlBuilder.url();
};

// Helper to format price
export const formatPrice = (price: number, currency: string = 'AED') => {
  return `${currency} ${price.toFixed(2)}`;
};
