import { defineField, defineType } from 'sanity'

export default defineType({
  name: 'roastProfile',
  title: 'Roast Profile',
  type: 'document',
  fields: [
    defineField({
      name: 'title',
      title: 'Title (English)',
      type: 'string',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'titleAr',
      title: 'Title (Arabic)',
      type: 'string',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'isActive',
      title: 'Active',
      type: 'boolean',
      initialValue: true
    }),
    defineField({
      name: 'sortOrder',
      title: 'Sort Order',
      type: 'number',
      initialValue: 0
    })
  ],
  preview: {
    select: {
      title: 'title',
      titleAr: 'titleAr'
    },
    prepare(selection) {
      const { title, titleAr } = selection
      return {
        title,
        subtitle: titleAr
      }
    }
  }
})
