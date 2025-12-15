// =====================================================
// SANITY SCHEMA: Product
// =====================================================
// Rich content for products (descriptions, images, stories)
// Operational data (price, stock) stored in Supabase
// =====================================================

import { defineField, defineType } from 'sanity'

export default defineType({
  name: 'product',
  title: 'Product',
  type: 'document',
  fields: [
    defineField({
      name: 'title',
      title: 'Product Name (English)',
      type: 'string',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'titleAr',
      title: 'Product Name (Arabic)',
      type: 'string',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'slug',
      title: 'Slug',
      type: 'slug',
      options: {
        source: 'title',
        maxLength: 96
      },
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'sku',
      title: 'SKU',
      type: 'string',
      description: 'Must match SKU in Supabase database',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'category',
      title: 'Category',
      type: 'reference',
      to: [{ type: 'category' }],
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'mainImage',
      title: 'Main Image',
      type: 'image',
      options: {
        hotspot: true
      },
      fields: [
        {
          name: 'alt',
          type: 'string',
          title: 'Alternative Text'
        }
      ]
    }),
    defineField({
      name: 'gallery',
      title: 'Image Gallery',
      type: 'array',
      of: [
        {
          type: 'image',
          options: {
            hotspot: true
          },
          fields: [
            {
              name: 'alt',
              type: 'string',
              title: 'Alternative Text'
            }
          ]
        }
      ]
    }),
    defineField({
      name: 'video',
      title: 'Product Video',
      type: 'url',
      description: 'YouTube or Vimeo URL'
    }),
    defineField({
      name: 'description',
      title: 'Description (English)',
      type: 'blockContent',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'descriptionAr',
      title: 'Description (Arabic)',
      type: 'blockContent',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'shortDescription',
      title: 'Short Description (English)',
      type: 'text',
      rows: 3,
      description: 'Brief description for product cards'
    }),
    defineField({
      name: 'shortDescriptionAr',
      title: 'Short Description (Arabic)',
      type: 'text',
      rows: 3,
      description: 'Brief description for product cards in Arabic'
    }),
    defineField({
      name: 'story',
      title: 'Product Story (English)',
      type: 'blockContent',
      description: 'Rich story about the product origin, producer, etc.'
    }),
    defineField({
      name: 'storyAr',
      title: 'Product Story (Arabic)',
      type: 'blockContent',
      description: 'Rich story in Arabic'
    }),
    defineField({
      name: 'tasteProfiles',
      title: 'Taste Profiles',
      type: 'array',
      of: [{ type: 'reference', to: [{ type: 'tasteProfile' }] }],
      description: 'Select multiple taste profiles'
    }),
    defineField({
      name: 'roastProfiles',
      title: 'Roast Profiles',
      type: 'array',
      of: [{ type: 'reference', to: [{ type: 'roastProfile' }] }],
      description: 'Select multiple roast profiles'
    }),
    defineField({
      name: 'graph1',
      title: 'Graph 1: Acidity vs Body',
      type: 'object',
      fields: [
        { name: 'valueX', type: 'number', title: 'Acidity (0-10)', validation: Rule => Rule.min(0).max(10) },
        { name: 'valueY', type: 'number', title: 'Body (0-10)', validation: Rule => Rule.min(0).max(10) }
      ]
    }),
    defineField({
      name: 'graph2',
      title: 'Graph 2: Sweetness vs Bitterness',
      type: 'object',
      fields: [
        { name: 'valueX', type: 'number', title: 'Sweetness (0-10)', validation: Rule => Rule.min(0).max(10) },
        { name: 'valueY', type: 'number', title: 'Bitterness (0-10)', validation: Rule => Rule.min(0).max(10) }
      ]
    }),
    defineField({
      name: 'graph3',
      title: 'Graph 3: Aroma vs Aftertaste',
      type: 'object',
      fields: [
        { name: 'valueX', type: 'number', title: 'Aroma (0-10)', validation: Rule => Rule.min(0).max(10) },
        { name: 'valueY', type: 'number', title: 'Aftertaste (0-10)', validation: Rule => Rule.min(0).max(10) }
      ]
    }),
    defineField({
      name: 'tastingNotes',
      title: 'Tasting Notes',
      type: 'array',
      of: [{ type: 'string' }],
      options: {
        layout: 'tags'
      }
    }),
    defineField({
      name: 'process',
      title: 'Process',
      type: 'string',
      description: 'e.g., Washed, Natural, Honey'
    }),
    defineField({
      name: 'producer',
      title: 'Producer',
      type: 'string'
    }),
    defineField({
      name: 'origin',
      title: 'Origin',
      type: 'string',
      description: 'Country or region'
    }),
    defineField({
      name: 'elevation',
      title: 'Elevation',
      type: 'string',
      description: 'e.g., 1800-2000 MASL'
    }),
    defineField({
      name: 'variety',
      title: 'Variety',
      type: 'string',
      description: 'Coffee variety, e.g., Typica, Bourbon'
    }),
    defineField({
      name: 'cupScore',
      title: 'Cup Score',
      type: 'number',
      description: 'SCA cupping score (0-100)',
      validation: Rule => Rule.min(0).max(100)
    }),
    defineField({
      name: 'roastingProfile',
      title: 'Roasting Profile PDF',
      type: 'file',
      options: {
        accept: '.pdf'
      }
    }),
    defineField({
      name: 'specifications',
      title: 'Specifications',
      type: 'array',
      of: [
        {
          type: 'object',
          fields: [
            { name: 'label', type: 'string', title: 'Label' },
            { name: 'value', type: 'string', title: 'Value' }
          ]
        }
      ]
    }),
    defineField({
      name: 'options',
      title: 'Product Options',
      type: 'array',
      description: 'Options like grind size, weight, etc.',
      of: [
        {
          type: 'object',
          fields: [
            { 
              name: 'name', 
              type: 'string', 
              title: 'Option Name',
              description: 'e.g., Grind Size, Weight'
            },
            { 
              name: 'values', 
              type: 'array', 
              title: 'Values',
              of: [{ type: 'string' }],
              description: 'e.g., Whole Bean, Espresso, Filter'
            },
            {
              name: 'required',
              type: 'boolean',
              title: 'Required',
              initialValue: false
            }
          ]
        }
      ]
    }),
    defineField({
      name: 'tags',
      title: 'Tags',
      type: 'array',
      of: [{ type: 'string' }],
      options: {
        layout: 'tags'
      }
    }),
    defineField({
      name: 'collections',
      title: 'Collections',
      type: 'array',
      of: [{ type: 'reference', to: [{ type: 'collection' }] }],
      description: 'Select multiple collections for this product'
    }),
    defineField({
      name: 'isWholesaleOnly',
      title: 'Wholesale Only',
      type: 'boolean',
      initialValue: false,
      description: 'Only visible to approved wholesale customers'
    }),
    defineField({
      name: 'isFeatured',
      title: 'Featured Product',
      type: 'boolean',
      initialValue: false
    }),
    defineField({
      name: 'seo',
      title: 'SEO',
      type: 'object',
      fields: [
        {
          name: 'metaTitle',
          type: 'string',
          title: 'Meta Title',
          validation: Rule => Rule.max(60)
        },
        {
          name: 'metaDescription',
          type: 'text',
          title: 'Meta Description',
          rows: 3,
          validation: Rule => Rule.max(160)
        },
        {
          name: 'keywords',
          type: 'array',
          title: 'Keywords',
          of: [{ type: 'string' }]
        }
      ]
    }),
    defineField({
      name: 'publishedAt',
      title: 'Published At',
      type: 'datetime',
      initialValue: () => new Date().toISOString()
    })
  ],
  preview: {
    select: {
      title: 'title',
      sku: 'sku',
      media: 'mainImage',
      category: 'category.title'
    },
    prepare(selection) {
      const { title, sku, category } = selection
      return {
        ...selection,
        subtitle: `${sku} | ${category || 'No category'}`
      }
    }
  }
})
