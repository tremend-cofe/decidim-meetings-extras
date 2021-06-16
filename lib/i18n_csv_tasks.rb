require 'i18n/tasks/commands'
require 'csv'

module I18nCsvTasks
  include ::I18n::Tasks::Command::Collection
  cmd :csv_export, desc: 'export translations to CSV', args: %i[locales]
  def csv_export(opts = {})
    translations_by_path = {}
    router = I18n::Tasks::Data::Router::PatternRouter.new(nil, write: i18n.config["csv"]["export"])

    opts[:locales].each do |locale|
      router.route(locale, i18n.data_forest) do |path, nodes|
        translations_by_path[path] ||= {}
        translations_by_path[path][locale] ||= {}

        nodes.leaves do |node|
          translations_by_path[path][locale][node.full_key(root: false)] = node.value
        end
      end
    end

    translations_by_path.each do |(path, translations_by_locale)|
      FileUtils.mkdir_p(File.dirname(path))

      CSV.open(path, "wb", col_sep: ";") do |csv|
        csv << (["key"] + opts[:locales])

        translations_by_locale[i18n.base_locale].keys.each do |key|
          values = opts[:locales].map do |locale|
            translations_by_locale[locale][key]
          end
          csv << values.unshift(key)
        end
      end
    end
  end

  cmd :csv_import, desc: 'import translations from CSV', args: %i[locales]
  def csv_import(opts = {})
    i18n.config["csv"]["import"].each do |file|
      csv = open(file).read.force_encoding('UTF-8')

      translations = []
      puts "Processing #{file}"
      CSV.parse(csv, {headers: true, col_sep: ";"}) do |row|
        key = row["key"]
        next unless key

        opts[:locales].each do |locale|
          unless row.has_key?(locale)
            # puts "Locale missing for key #{key}! (locales in app: #{locales} / locales in file: #{row.headers.inspect})"
            next
          end
          next if row[locale].blank?
          translations << [[locale, key].join("."), row[locale]]
        end
      end

      # # Uncomment this in order to attempt to recognise entries that are likely symbols pointing to
      # # other translations, intended to be rendered in your .yml with a preceding colon:
      # translations.map! { |t| [t.first, (t.last&.=~ /^(?=.*\.)[a-z0-9_\.]+$/) ? t.last.to_sym : t.last] }
      i18n.data.merge! I18n::Tasks::Data::Tree::Siblings.from_flat_pairs(translations)
    end
  end
end
I18n::Tasks.add_commands I18nCsvTasks
