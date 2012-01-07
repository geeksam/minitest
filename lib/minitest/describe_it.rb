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
  def self.obfuscate_expectation_methods
    MiniTest::Expectations.instance_methods.each do |method|
      next if method =~ /^_(must|wont)_/
      original   = method.to_sym
      obfuscated = ('_%s' % method.to_s).to_sym
      alias :"#{obfuscated}" :"#{original}"
      remove_method original
    end
  end

  def self.elucidate_expectation_methods
    MiniTest::Expectations.instance_methods.each do |method|
      next unless method =~ /^_(must|wont)_/
      original   = method.to_s.gsub(/^_/, '').to_sym
      obfuscated = method.to_sym
      alias :"#{original}" :"#{obfuscated}"
      remove_method obfuscated
    end
  end
end

MiniTest.obfuscate_expectation_methods
