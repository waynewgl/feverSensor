#encoding: UTF-8
Apipie.configure do |config|
  config.app_name                = "体温计---接口文档"
  config.api_base_url            = ""
  config.doc_base_url            = "/apipie"
  config.validate = false
  config.app_info = "体温计接口文档 - 未完待续。 "
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
end
