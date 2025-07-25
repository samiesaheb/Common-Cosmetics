# config/initializers/turbo_redirect.rb
module Turbo
  class Streams::TagBuilder
    def redirect(url:)
      turbo_stream_action_tag(:redirect, target: "_top") do
        tag.meta("turbo-redirect-url": url)
      end
    end
  end
end
