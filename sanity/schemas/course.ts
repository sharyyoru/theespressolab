import { defineField, defineType } from 'sanity'

export default defineType({
  name: 'course',
  title: 'Course',
  type: 'document',
  fields: [
    defineField({
      name: 'title',
      title: 'Course Title (English)',
      type: 'string',
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'titleAr',
      title: 'Course Title (Arabic)',
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
      rows: 3
    }),
    defineField({
      name: 'shortDescriptionAr',
      title: 'Short Description (Arabic)',
      type: 'text',
      rows: 3
    }),
    defineField({
      name: 'mainImage',
      title: 'Main Image',
      type: 'image',
      options: {
        hotspot: true
      }
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
          }
        }
      ]
    }),
    defineField({
      name: 'durationMinutes',
      title: 'Duration (minutes)',
      type: 'number',
      validation: Rule => Rule.required().min(0)
    }),
    defineField({
      name: 'maxParticipants',
      title: 'Max Participants',
      type: 'number',
      initialValue: 10,
      validation: Rule => Rule.required().min(1)
    }),
    defineField({
      name: 'level',
      title: 'Skill Level',
      type: 'string',
      options: {
        list: [
          { title: 'Beginner', value: 'beginner' },
          { title: 'Intermediate', value: 'intermediate' },
          { title: 'Advanced', value: 'advanced' },
          { title: 'All Levels', value: 'all' }
        ]
      }
    }),
    defineField({
      name: 'whatYouLearn',
      title: 'What You Will Learn',
      type: 'array',
      of: [{ type: 'string' }]
    }),
    defineField({
      name: 'requirements',
      title: 'Requirements',
      type: 'array',
      of: [{ type: 'string' }]
    }),
    defineField({
      name: 'includes',
      title: 'What\'s Included',
      type: 'array',
      of: [{ type: 'string' }]
    }),
    defineField({
      name: 'instructor',
      title: 'Instructor',
      type: 'reference',
      to: [{ type: 'teamMember' }]
    }),
    defineField({
      name: 'isFeatured',
      title: 'Featured Course',
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
          title: 'Meta Title'
        },
        {
          name: 'metaDescription',
          type: 'text',
          title: 'Meta Description',
          rows: 3
        }
      ]
    })
  ],
  preview: {
    select: {
      title: 'title',
      media: 'mainImage',
      duration: 'durationMinutes'
    },
    prepare(selection) {
      const { title, duration } = selection
      return {
        ...selection,
        subtitle: `${duration} minutes`
      }
    }
  }
})
