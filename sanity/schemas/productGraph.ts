import { defineField, defineType } from 'sanity'

export default defineType({
  name: 'productGraph',
  title: 'Product Graph',
  type: 'object',
  fields: [
    defineField({
      name: 'nameEn',
      title: 'Graph Name (English)',
      type: 'string'
    }),
    defineField({
      name: 'nameAr',
      title: 'Graph Name (Arabic)',
      type: 'string'
    }),
    defineField({
      name: 'valueX',
      title: 'X-Axis Value',
      type: 'number',
      validation: Rule => Rule.required().min(0).max(10)
    }),
    defineField({
      name: 'valueY',
      title: 'Y-Axis Value',
      type: 'number',
      validation: Rule => Rule.required().min(0).max(10)
    }),
    defineField({
      name: 'labelXEn',
      title: 'X-Axis Label (English)',
      type: 'string'
    }),
    defineField({
      name: 'labelXAr',
      title: 'X-Axis Label (Arabic)',
      type: 'string'
    }),
    defineField({
      name: 'labelYEn',
      title: 'Y-Axis Label (English)',
      type: 'string'
    }),
    defineField({
      name: 'labelYAr',
      title: 'Y-Axis Label (Arabic)',
      type: 'string'
    })
  ]
})
