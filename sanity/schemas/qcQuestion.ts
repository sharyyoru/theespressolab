import { defineField, defineType } from 'sanity'

export default defineType({
  name: 'qcQuestion',
  title: 'QC Question Template',
  type: 'document',
  description: 'Predefined questions for Quality Control inspections',
  fields: [
    defineField({
      name: 'question',
      title: 'Question',
      type: 'string',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'category',
      title: 'Category',
      type: 'string',
      options: {
        list: [
          { title: 'Packaging', value: 'packaging' },
          { title: 'Product Quality', value: 'quality' },
          { title: 'Labeling', value: 'labeling' },
          { title: 'Weight/Quantity', value: 'weight' },
          { title: 'Appearance', value: 'appearance' },
          { title: 'Other', value: 'other' }
        ]
      },
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'answerType',
      title: 'Answer Type',
      type: 'string',
      options: {
        list: [
          { title: 'Rating (1-5)', value: 'rating' },
          { title: 'Yes/No', value: 'boolean' },
          { title: 'Text', value: 'text' },
          { title: 'Multiple Choice', value: 'choice' }
        ]
      },
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'choices',
      title: 'Multiple Choice Options',
      type: 'array',
      of: [{ type: 'string' }],
      hidden: ({ parent }) => parent?.answerType !== 'choice'
    }),
    defineField({
      name: 'isRequired',
      title: 'Required Question',
      type: 'boolean',
      initialValue: true
    }),
    defineField({
      name: 'helpText',
      title: 'Help Text',
      type: 'text',
      rows: 2,
      description: 'Additional guidance for the inspector'
    }),
    defineField({
      name: 'sortOrder',
      title: 'Sort Order',
      type: 'number',
      initialValue: 0
    }),
    defineField({
      name: 'isActive',
      title: 'Active',
      type: 'boolean',
      initialValue: true
    })
  ],
  preview: {
    select: {
      title: 'question',
      category: 'category',
      answerType: 'answerType'
    },
    prepare(selection) {
      const { title, category, answerType } = selection
      return {
        title,
        subtitle: `${category} | ${answerType}`
      }
    }
  }
})
