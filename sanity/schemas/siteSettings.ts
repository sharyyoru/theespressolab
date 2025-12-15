import { defineType } from 'sanity'

export default defineType({
  name: 'siteSettings',
  title: 'Site Settings',
  type: 'document',
  fields: [
    {
      name: 'title',
      title: 'Site Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
    },
    {
      name: 'logo',
      title: 'Logo',
      type: 'image',
      options: {
        hotspot: true,
      },
      fields: [
        {
          name: 'alt',
          title: 'Alt Text',
          type: 'string',
        },
      ],
      validation: (Rule) => Rule.required(),
    },
    {
      name: 'logoLight',
      title: 'Logo (Light Version)',
      type: 'image',
      description: 'Logo for dark backgrounds',
      options: {
        hotspot: true,
      },
      fields: [
        {
          name: 'alt',
          title: 'Alt Text',
          type: 'string',
        },
      ],
    },
    {
      name: 'favicon',
      title: 'Favicon',
      type: 'image',
      description: 'Site favicon (32x32px recommended)',
      options: {
        accept: 'image/x-icon,image/png',
      },
      validation: (Rule) => Rule.required(),
    },
    {
      name: 'ogImage',
      title: 'Open Graph Image',
      type: 'image',
      description: 'Default social sharing image (1200x630px recommended)',
      options: {
        hotspot: true,
      },
    },
    {
      name: 'topBanner',
      title: 'Top Banner',
      type: 'object',
      fields: [
        {
          name: 'enabled',
          title: 'Enable Banner',
          type: 'boolean',
          initialValue: true,
        },
        {
          name: 'text_en',
          title: 'Banner Text (English)',
          type: 'string',
        },
        {
          name: 'text_ar',
          title: 'Banner Text (Arabic)',
          type: 'string',
        },
        {
          name: 'link',
          title: 'Banner Link',
          type: 'url',
        },
      ],
    },
    {
      name: 'socialMedia',
      title: 'Social Media',
      type: 'object',
      fields: [
        {
          name: 'facebook',
          title: 'Facebook URL',
          type: 'url',
        },
        {
          name: 'instagram',
          title: 'Instagram URL',
          type: 'url',
        },
        {
          name: 'youtube',
          title: 'YouTube URL',
          type: 'url',
        },
        {
          name: 'twitter',
          title: 'Twitter URL',
          type: 'url',
        },
        {
          name: 'tiktok',
          title: 'TikTok URL',
          type: 'url',
        },
      ],
    },
    {
      name: 'contact',
      title: 'Contact Information',
      type: 'object',
      fields: [
        {
          name: 'email',
          title: 'Email',
          type: 'string',
        },
        {
          name: 'phone',
          title: 'Phone',
          type: 'string',
        },
        {
          name: 'address_en',
          title: 'Address (English)',
          type: 'text',
          rows: 3,
        },
        {
          name: 'address_ar',
          title: 'Address (Arabic)',
          type: 'text',
          rows: 3,
        },
        {
          name: 'trn',
          title: 'TRN Number',
          type: 'string',
        },
      ],
    },
    {
      name: 'defaultCurrency',
      title: 'Default Currency',
      type: 'string',
      options: {
        list: [
          { title: 'AED', value: 'AED' },
          { title: 'USD', value: 'USD' },
          { title: 'EUR', value: 'EUR' },
        ],
      },
      initialValue: 'AED',
    },
  ],
  preview: {
    prepare() {
      return {
        title: 'Site Settings',
      }
    },
  },
})
