class Admin::DocxTemplatesController < ApplicationController

  def index
    @docx_templates = DocxTemplate.all
  end

  def new
    @docx_template = DocxTemplate.new
  end

  def create
    @docx_template = DocxTemplate.new(docx_template_params)
    if @docx_template.save
      redirect_to admin_docx_templates_path, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
    @docx_template = DocxTemplate.find params[:id]
  end

  def update
    @docx_template = DocxTemplate.find params[:id]
    if @docx_template.update(docx_template_params)
      redirect_to admin_docx_templates_path, notice: 'Product was successfully created.'
    else
      render :edit
    end
  end

  private

  def docx_template_params
    params.require(:docx_template).permit(:name, :raw_template, :template_fields, :sample_template)
  end
end
