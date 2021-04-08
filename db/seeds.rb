# frozen_string_literal: true

if !Rails.env.production? || ENV["SEED"]
  print "Creating seeds for decidim_navigation maps...\n" unless Rails.env.test?

  require "decidim/faker/localized"
  seeds_root = File.join(__dir__, "seeds")

  organization = Decidim::Organization.first

  content_block = Decidim::ContentBlock.create(
    decidim_organization_id: organization.id,
    weight: 1,
    scope_name: :homepage,
    manifest_name: :navigation_map,
    published_at: Time.current,
    settings: { title: Decidim::Faker::Localized.sentence(word_count: 5) }
  )

  blueprint1 = Decidim::NavigationMaps::Blueprint.create(
    organization: organization,
    content_block: content_block,
    image: File.new(File.join(seeds_root, "antarctica.png")),
    title: Decidim::Faker::Localized.sentence(word_count: 2),
    description: Decidim::Faker::Localized.sentence(word_count: 10)
  )

  Decidim::NavigationMaps::Blueprint.create(
    organization: organization,
    image: File.new(File.join(seeds_root, "penguins.jpg")),
    title: Decidim::Faker::Localized.sentence(word_count: 2),
    description: Decidim::Faker::Localized.sentence(word_count: 10)
  )

  Decidim::NavigationMaps::BlueprintArea.create(
    blueprint: blueprint1,
    area_id: "10",
    area_type: "Feature",
    area: {
      type: "Polygon",
      coordinates: [[
        [717.21875, 277.162511],
        [717.21875, 317.104475],
        [758.029018, 317.104475],
        [758.029018, 277.162511],
        [717.21875, 277.162511]
      ]]
    },
    link: "https://en.wikipedia.org/wiki/South_Pole",
    link_type: "link",
    color: "#ff2a00",
    title: { en: "South Pole" },
    description: { en: "It's cold in here" }
  )

  Decidim::NavigationMaps::BlueprintArea.create(
    blueprint: blueprint1,
    area_id: "11",
    area_type: "Feature",
    area: {
      type: "Polygon",
      coordinates: [[
        [376.84375, 516.814296],
        [384.658482, 464.716082],
        [411.575893, 432.58885],
        [438.493304, 416.091082],
        [425.46875, 402.198225],
        [436.756696, 383.095546],
        [428.941964, 375.280814],
        [448.912946, 358.783046],
        [462.805804, 367.466082],
        [486.25, 373.544207],
        [526.191964, 416.091082],
        [450.649554, 448.218314],
        [401.15625, 484.687064],
        [376.84375, 516.814296]
      ]]
    },
    link: "#map1",
    link_type: "link",
    color: "#ffbb00",
    title: { en: "Penguins" },
    description: { en: "Penguins are beatiful animals" }
  )

  Decidim::NavigationMaps::BlueprintArea.create(
    blueprint: blueprint1,
    area_id: "12",
    area_type: "Feature",
    area: {
      type: "Polygon",
      coordinates: [[
        [1068.013393, 418.695993],
        [1023.729911, 412.617868],
        [1025.466518, 343.153582],
        [1104.482143, 324.050903],
        [1045.4375, 379.622332],
        [1068.013393, 418.695993]
      ]]
    },
    link: "#map1",
    link_type: "direct"
  )
end
