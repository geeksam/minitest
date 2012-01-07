#!/usr/bin/ruby -w

require 'minitest/spec'

module MiniTest
  def self.obfuscate_expectation_methods
    MiniTest::Expectations.instance_methods.each do |method|
      next if method =~ /^_(.*)/
      MiniTest::Expectations.obfuscate method
    end
  end

  def self.elucidate_expectation_methods
    MiniTest::Expectations.instance_methods.each do |method|
      next unless method =~ /^_(.*)/
      MiniTest::Expectations.elucidate(method)
    end
  end
end

module MiniTest::Expectations
  def self.obfuscate(method)
    original   = method.to_sym
    obfuscated = ('_' + method.to_s).to_sym
    alias :"#{obfuscated}" :"#{original}"
    remove_method original
  end

  def self.elucidate(method)
    original   = method.to_s.gsub(/^_/, '').to_sym
    obfuscated = method.to_sym
    alias :"#{original}" :"#{obfuscated}"
    remove_method obfuscated
  end
end

MiniTest.obfuscate_expectation_methods
