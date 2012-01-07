#!/usr/bin/ruby -w

require 'minitest/spec'

module MiniTest
  def self.obfuscate_expectation_methods
    MiniTest::Expectations.obfuscate_expectation_methods
  end

  def self.elucidate_expectation_methods
    MiniTest::Expectations.elucidate_expectation_methods
  end
end

module MiniTest::Expectations
  def self.__rename_method(old_name, new_name)
    alias :"#{new_name}" :"#{old_name}"
    remove_method old_name
  end

  def self.obfuscate_expectation_methods
    MiniTest::Expectations.instance_methods.each do |method|
      next if method =~ /^__OBFUSCATED_(must|wont)_.*__$/
      original   = method.to_sym
      obfuscated = ('__OBFUSCATED_%s__' % method.to_s).to_sym
      __rename_method original, obfuscated
    end
  end

  def self.elucidate_expectation_methods
    MiniTest::Expectations.instance_methods.each do |method|
      next unless method =~ /^__OBFUSCATED_(must|wont)_.*__$/
      original   = method.to_s.gsub(/(^__OBFUSCATED_|__$)/, '').to_sym
      obfuscated = method.to_sym
      __rename_method obfuscated, original
    end
  end
end

MiniTest.obfuscate_expectation_methods
