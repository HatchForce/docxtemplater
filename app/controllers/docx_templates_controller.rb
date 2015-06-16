class DocxTemplatesController < ApplicationController

  def index
    @docx_templates = DocxTemplate.all
  end

  def generate
    @docx_template = DocxTemplate.find params[:id]

    yomu = Yomu.new @docx_template.raw_template.path
    @text = yomu.text

    _x = @text.scan(/\$(.*?)$/)
    _x = _x.join(' ').delete('$')
    _x = _x.delete(',')
    @fields = _x.split(' ')
  end

  def download
    @docx_template = DocxTemplate.find params[:id]
    respond_to do |format|
      format.docx do
        # Initialize DocxReplace with your template
        doc = DocxReplace::Doc.new(@docx_template.raw_template.path, "#{Rails.root}/tmp")

        # Replace some variables. $var$ convention is used here, but not required.
        #data = {title: "Fabulous Document", first_name: "Prasanna", last_name: "Kumar", location: "Hyderabad"}
        params[:faker].each do |k, v|
          doc.replace("$#{k}$", v)
        end

        # Write the document back to a temporary file
        tmp_file = Tempfile.new('word_template', "#{Rails.root}/tmp/docx")
        doc.commit(tmp_file.path)

        if params[:doc_name] == ""
          download_file_name = "#{@docx_template.raw_template_identifier}_#{Time.now.to_i}.docx"
          logger.debug "-----------"
          logger.debug download_file_name
        else
          download_file_name = "#{params[:doc_name]}.docx"
        end

        # Respond to the request by sending the temp file
        send_file tmp_file.path, filename: download_file_name, disposition: 'attachment'
      end
    end
  end

  def merge_files

  end

  def download_merge_files
    raise params.inspect
  end
end

=begin
  def download
    @docx_template = DocxTemplate.find params[:id]
    template = Sablon.template(File.expand_path(@docx_template.raw_template.path))
    context = params[:docx_fields]
    tmp_file = Tempfile.new('output.docx', "#{Rails.root}/tmp")
    template.render_to_file tmp_file.path, context, properties
    send_file tmp_file.path, filename: "final.docx", disposition: 'attachment'
  end

  def download1
    @docx_template = DocxTemplate.find params[:id]

    template = Sablon.template(File.expand_path(@docx_template.raw_template.path))
    skill = Struct.new(:index, :label, :rating)
    position = Struct.new(:when, :where, :tasks, :description)
    language = Struct.new(:name, :skill)
    education = Struct.new(:when, :where, :what)
    referee = Struct.new(:name, :company, :position, :phone)

    context = {
        current_time: Time.now.strftime("%d.%m.%Y %H:%M"),
        metadata: { generator: "Sablon" },
        title: "Resume",
        person: OpenStruct.new("first_name" => "Prasanna", "last_name" => "Kumar",
                               "phone" => "720-719-8442",
                               "email" => "prasanna@hatchforce.com",
                               "address" => {
                                   "street" => "1009 Fraggle Drive",
                                   "municipality" => "Wheaton",
                                   "province_zip" => "IL 60187"}),
        skills: [skill.new("1.", "Rails", "★" * 4),
                 skill.new("2.", "Ruby", "★" * 3),
                 skill.new("3.", "Python", "★" * 1),
                 skill.new("4.", "XML, XSLT, JSP"),
                 skill.new("5.", "automated testing", "★" * 3),
        ],
        education: [
            education.new("2005 – 2008", "Birmingham University", "Degree: BSc Hons Computer Science. 2:1 Attained."),
            education.new("2003 – 2005", "Yale Sixth Form College, Bristol.", "3 A Levels - Mathematics (A), Science (A), History (B)"),
            education.new("1997 – 2003", "Berry High School, Bristol.", "11 GCSE’s – 5 As, 5 Bs, 1 C")
        ],
        certifications: [],
        career: [position.new("February 2013 - Present", "Apps Limited", [],
                              "Ruby on Rails Web Developer for this retail merchandising company."),
                 position.new("June 2010 - December 2012", "Digital Design Limited",
                              ["Ongoing ASP.NET website development using C#.",
                               "Developed CRM web application using SQL Server 2008.",
                               "SQL Server Reporting.",
                               "Helped junior developers gain understanding of C# and .NET framework and apply this accordingly."],
                              "Software Engineer for this financial services provider."),
                 position.new("June 2008 - June 2010", "Development Consultancy Limited",
                              ["Development of new features and testing of functionality.",
                               "Assisted in development and documentation of several ASP.NET based applications.",
                               "Web application maintenance.",
                               "Ensured development was signed off prior to unit testing.",
                               "Liaised with various service providers."])
        ],
        languages: [language.new("English", "native speaker"),
                    language.new("German", "fluent"),
                    language.new("French", "basics"),
        ],
        about_me: Sablon.content(:markdown, "I am fond of writing *short stories* and *poems* in my spare time,  \nand have won several literary contests in pursuit of my **passion**."),
        activities: ["Writing", "Photography", "Traveling"],
        referees: [
            referee.new("Mary P. Larsen", "Strongbod",
                        "Organizational development consultant", "509-471-9365"),
            referee.new("Jeanne P. Eldridge", "Widdmann",
                        "Information designer", "530-376-1628")
        ]
    }

    properties = {
        start_page_number: 7
    }

    tmp_file = Tempfile.new('output.docx', "#{Rails.root}/tmp")
    template.render_to_file tmp_file.path, context, properties
    send_file tmp_file.path, filename: "final.docx", disposition: 'attachment'
  end


  def download2

    @docx_template = DocxTemplate.find params[:id]

    # template = Sablon.template(File.expand_path(@docx_template.raw_template.path))
    # context = {
    #     title: "Fabulous Document",
    #     skills: ["Ruby", "Markdown", "ODF"]
    # }
    # template.render_to_file File.expand_path("~/Desktop/output.docx"), context



    using docx replace
    respond_to do |format|
      format.docx do
        # Initialize DocxReplace with your template
        doc = DocxReplace::Doc.new(@docx_template.raw_template.path, "#{Rails.root}/tmp")

        # Replace some variables. $var$ convention is used here, but not required.
        doc.replace("$title$", "Fabulous Document")

        # Write the document back to a temporary file
        tmp_file = Tempfile.new('word_template', "#{Rails.root}/tmp")
        doc.commit(tmp_file.path)

        # Respond to the request by sending the temp file
        send_file tmp_file.path, filename: "report.docx", disposition: 'attachment'
      end
    end
  end
end
=end