module Plugin::FreePlan
  class QA < Diva::Model
    include Diva::Model::MessageMixin

    field.string :id, required: true
    field.string :question, required: true
    field.string :answer, required: true

    field.time :created, required: true

    def description
      [question, answer].join("\n\n")
    end

    def user
      Plugin::FreePlan::User.new(name: '広告')
    end

    def created
      Time.now
    end
  end

  class User < Diva::Model
    include Diva::Model::UserMixin

    field.string :name

    def icon
      Skin[:mikuslime]
    end
  end
end
