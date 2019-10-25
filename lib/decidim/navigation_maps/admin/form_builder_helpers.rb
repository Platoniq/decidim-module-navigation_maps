# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module Admin
      # Custom FormBuilder with modifications for file uploads
      module FormBuilderHelpers
        # Public: Generates a file upload field and sets the form as multipart.
        # If the file is an image it displays the default image if present or the current one.
        # By default it also generates a checkbox to delete the file. This checkbox can
        # be hidden if `options[:optional]` is passed as `false`.
        #
        # attribute    - The String name of the attribute to buidl the field.
        # options      - A Hash with options to build the field.
        #              * optional: Whether the file can be optional or not.
        def upload_map(attribute, options = {})
          self.multipart = true
          options[:optional] = options[:optional].nil? ? true : options[:optional]

          file = object.send attribute
          template = ""
          template += label(attribute, label_for(attribute) + required_for_attribute(attribute))
          template += @template.file_field @object_name, attribute

          if file_is_image?(file)
            template += if file.present?
                          @template.content_tag :label, I18n.t("current_image", scope: "decidim.forms")
                        else
                          @template.content_tag :label, I18n.t("default_image", scope: "decidim.forms")
                        end
            template += @template.image_tag(file.url)
          elsif file_is_present?(file)
            template += @template.label_tag I18n.t("current_file", scope: "decidim.forms")
            template += file.file.filename
          end

          if file_is_present?(file)
            if options[:optional]
              template += content_tag :div, class: "field" do
                safe_join([
                            @template.check_box(@object_name, "remove_#{attribute}"),
                            label("remove_#{attribute}", I18n.t("remove_this_file", scope: "decidim.forms"))
                          ])
              end
            end
          end

          if object.errors[attribute].any?
            template += content_tag :p, class: "is-invalid-label" do
              safe_join object.errors[attribute], "<br/>".html_safe
            end
          end

          template.html_safe
        end
      end
    end
  end
end
