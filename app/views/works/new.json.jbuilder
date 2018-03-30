json.key_format! camelize: :lower

json.form render(partial: "works/form", locals: {
  work: @work
})
