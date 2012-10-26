# -*- encoding : utf-8 -*-
require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV['RECAPTCHA_PUBLIC_KEY'] = '6LdnRNgSAAAAAMOBozEv1861xrICRaVA9_OUAEj8'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LdnRNgSAAAAAJ9HZejTY95wc5PxhW4y8b76b7TT'

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
