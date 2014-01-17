#encoding: UTF-8
Apipie.configure do |config|
  config.app_name                = "体温计---接口文档"
  config.api_base_url            = ""
  config.doc_base_url            = "/apipie"
  config.validate = false
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
end
