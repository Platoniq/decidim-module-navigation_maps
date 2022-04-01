# frozen_string_literal: true

module Decidim
  module NavigationMaps
    module Cw
      # This class deals with uploading images to a Blueprints.
      class BlueprintUploader < Decidim::ImageUploader
        process :validate_size, :validate_dimensions

        version :thumbnail do
          process resize_to_fit: [nil, 237]
        end

        def extension_white_list
          %w(jpg jpeg png svg)
        end

        def max_image_height_or_width
          8000
        end
      end
    end
  end
end
