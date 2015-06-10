class DocxTemplate < ActiveRecord::Base

  mount_uploader :raw_template, RawTemplateDocxTemplateUploader
  mount_uploader :template_fields, TemplateFieldsDocxTemplateUploader
  mount_uploader :sample_template, SampleTemplateDocxTemplateUploader
end
