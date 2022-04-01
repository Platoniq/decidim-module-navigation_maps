# frozen_string_literal: true

module Decidim
  module NavigationMaps
    # This class deals with uploading images to a Blueprints.
    class BlueprintUploader < Decidim::ImageUploader
      set_variants do
        {
          thumbnail: { resize_to_fit: [nil, 237] }
        }
      end
    end
  end
end
