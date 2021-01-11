# Decidim::NavigationMaps

![Test](https://github.com/Platoniq/decidim-module-navigation_maps/workflows/Test/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/f69b2b0ab0ffcd26f002/maintainability)](https://codeclimate.com/github/Platoniq/decidim-module-navigation_maps/maintainability)
[![Codecov](https://codecov.io/gh/Platoniq/decidim-module-navigation_maps/branch/master/graph/badge.svg?token=XhzWO0IiWt)](https://codecov.io/gh/Platoniq/decidim-module-navigation_maps)

Allows to map processes to image parts using maps.

> NOTE: This module is ready to use but in Beta status. Feel free to report any bug!

## Usage

NavigationMaps is available as a Content Block widget (currently for the
homepage only).

👉 [Check the usage guide here!](USAGE.md)

![Admin editor](examples/admin.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-navigation_maps", "~> 1.0.0"
```

And then execute:

```bash
bundle
bundle exec rails decidim_navigation_maps:install:migrations
bundle exec rails db:migrate
```

Depending on your Decidim version, choose the corresponding Plugin version to ensure compatibility:

| Navigation Maps version | Compatible Decidim versions |
|---|---|
| 1.0.x | 0.18.x, 0.21.x |

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Developing

To start contributing to this project, first:

- Install the basic dependencies (such as Ruby and PostgreSQL)
- Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
bundle
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
cd development_app
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rails s
```

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

[Rubocop](https://rubocop.readthedocs.io/) linter is used for the Ruby language.

You can run the code styling checks by running the following commands from the
console:

```
bundle exec rubocop
```

To ease up following the style guide, you should install the plugin to your
favorite editor, such as:

- Atom - [linter-rubocop](https://atom.io/packages/linter-rubocop)
- Sublime Text - [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
- Visual Studio Code - [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)

### Testing

To run the tests run the following in the gem development path:

```bash
bundle
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.

## Credits

This plugin has been developed by ![Platoniq](examples/platoniq-logo.png)

> Amb el suport de l'Ajuntament de Barcelona - Direcció de Serveis d'Innovació Democràtica
>
> ![Logo Barcelona](examples/bcn-logo.png)
