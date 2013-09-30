# -*- encoding : utf-8 -*-

Encoding.default_internal = 'UTF-8'

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Labati::Application.initialize!

ENV['RECAPTCHA_PUBLIC_KEY'] = '6LdnRNgSAAAAAMOBozEv1861xrICRaVA9_OUAEj8'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LdnRNgSAAAAAJ9HZejTY95wc5PxhW4y8b76b7TT'
