# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require 'yaml'

# This class offers localization to all console(info, warnings, errors) messages
class Localization

	# A hash of templates in the current language, init by .current_language_locale
	@@locales = nil

	# interpolate a template (identified by a symbol key)for the current
	# available language with the arguments given to an optional output.
	#
	# Will give the locale id + arguments if the locale is not found.
	# @param locale_id [Symbol, #read] the locale template identificator
	# @param args [Hash, #read] The variables to be interpolated in the template
	# @param output_type [Object, #use] an output that offers .puts class method, can be also STDERR or Debug
	def self.print(locale_id, args = {}, output_type = STDOUT)
		string_template_to_interpolate = current_language_locale[locale_id.to_s]
		string_template_to_interpolate ||= "Locale not found for: #{locale_id}, args: %s"
		output_type.puts string_template_to_interpolate % args
		return
	end

	private

	DEFAULT_LANGUAGES = :en
	VALID_LANGUAGES = [
		:en # , :fr, :es
	]

	def self.current_language_locale
		ENV['LANGUAGE'].split(':').each do |posible_lang|
			posible_lang = posible_lang[0...2].to_sym
			@@locales = YAML.load_file("./locales/#{posible_lang}.yml") if(
				@@locales.nil? and
				VALID_LANGUAGES.include? posible_lang
			)
		end if @@locales.nil?
		return @@locales
	end
end
