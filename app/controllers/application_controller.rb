#encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery


  def pushNotification(certificate_name, device_token, env, content)

    if env == "development"

      s_gateway = "gateway.sandbox.push.apple.com"
    else

      s_gateway = "gateway.push.apple.com"
    end


    pusher = Grocer.pusher(

            certificate: "#{Rails.root}/#{certificate_name}",      # required
            passphrase:  "",                       # optional
            gateway:     s_gateway, # optional; See note below. production..  gateway.push.apple.com
            port:        2195,                     # optional
            retries:     3                         # optional
   )

    notification = Grocer::Notification.new(

        device_token:      "#{device_token}",
        alert:             content,
        badge:             1,
        sound:             "siren.aiff",         # optional
        expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
        identifier:        1234,                 # optional
        content_available: true                  # optional; any truthy value will set 'content-available' to 1
    )

    if  !pusher.push(notification)

      render :inline => "push nontification in #{env} fail"
    else

      render :inline => "push nontification in #{env}  succeed, sending #{content}"
    end

  end


end
