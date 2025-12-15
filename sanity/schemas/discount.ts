import { defineField, defineType } from 'sanity'

export default defineType({
  name: 'discount',
  title: 'Discount / Coupon',
  type: 'document',
  fields: [
    defineField({
      name: 'code',
      title: 'Coupon Code',
      type: 'string',
      validation: Rule => Rule.required()
    }),
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
      name: 'description',
      title: 'Description (English)',
      type: 'text',
      rows: 3
    }),
    defineField({
      name: 'descriptionAr',
      title: 'Description (Arabic)',
      type: 'text',
      rows: 3
    }),
    defineField({
      name: 'discountType',
      title: 'Discount Type',
      type: 'string',
      options: {
        list: [
          { title: 'Percentage', value: 'percentage' },
          { title: 'Fixed Amount', value: 'fixed_amount' },
          { title: 'Free Shipping', value: 'free_shipping' }
        ]
      },
      validation: Rule => Rule.required()
    }),
    defineField({
      name: 'discountValue',
      title: 'Discount Value',
      type: 'number',
      description: 'Percentage (e.g., 20 for 20%) or fixed amount',
      validation: Rule => Rule.required().min(0)
    }),
    defineField({
      name: 'minPurchaseAmount',
      title: 'Minimum Purchase Amount',
      type: 'number',
      initialValue: 0
    }),
    defineField({
      name: 'maxDiscountAmount',
      title: 'Maximum Discount Amount',
      type: 'number',
      description: 'Optional cap for percentage discounts'
    }),
    defineField({
      name: 'usageLimit',
      title: 'Usage Limit',
      type: 'number',
      description: 'Maximum number of times this code can be used'
    }),
    defineField({
      name: 'validFrom',
      title: 'Valid From',
      type: 'datetime',
      initialValue: () => new Date().toISOString()
    }),
    defineField({
      name: 'validUntil',
      title: 'Valid Until',
      type: 'datetime'
    }),
    defineField({
      name: 'isWholesaleOnly',
      title: 'Wholesale Only',
      type: 'boolean',
      initialValue: false
    }),
    defineField({
      name: 'applicableProducts',
      title: 'Applicable Products',
      type: 'array',
      of: [{ type: 'reference', to: [{ type: 'product' }] }],
      description: 'Leave empty for all products'
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
      title: 'code',
      subtitle: 'title',
      discountType: 'discountType',
      discountValue: 'discountValue'
    },
    prepare(selection) {
      const { title, subtitle, discountType, discountValue } = selection
      return {
        title,
        subtitle: `${subtitle} - ${discountValue}${discountType === 'percentage' ? '%' : ' SAR'}`
      }
    }
  }
})
