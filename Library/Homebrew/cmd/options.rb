require "formula"

module Homebrew
  def options
    if ARGV.include? "--all"
      puts_options Formula.to_a
    elsif ARGV.include? "--installed"
      puts_options Formula.installed
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_options ARGV.formulae
    end
  end

  def puts_options(formulae)
    formulae.each do |f|
      next if f.options.empty?
      if ARGV.include? "--compact"
        puts f.options.as_flags.sort * " "
      else
        puts f.full_name if formulae.length > 1
        dump_options_for_formula f
        puts
      end
    end
  end

  def dump_options_for_formula(f)
    f.options.sort_by(&:flag).each do |opt|
      puts "#{opt.flag}\n\t#{opt.description}"
    end
    puts "--devel\n\tInstall development version #{f.devel.version}" if f.devel
    puts "--HEAD\n\tInstall HEAD version" if f.head
  end
end
