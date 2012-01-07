#!/usr/bin/ruby -w

require 'minitest/spec'

module MiniTest::Expectations
  def self.obfuscate_method(mname)
    original   = mname.to_sym
    obfuscated = ('_' + mname.to_s).to_sym
    alias :"#{obfuscated}" :"#{original}"
    remove_method original
  end

  def self.eschew_obfuscation_for_method(mname)
    original   = mname.to_s.gsub(/^_/, '').to_sym
    obfuscated = mname.to_sym
    alias :"#{original}" :"#{obfuscated}"
    remove_method obfuscated
  end
end

module MiniTest
  def self.enable_expectations
    MiniTest::Expectations.instance_methods.each do |mname|
      next unless mname =~ /^_(.*)/
      MiniTest::Expectations.eschew_obfuscation_for_method(mname)
    end
  end

  def self.disable_expectations
    MiniTest::Expectations.instance_methods.each do |mname|
      next if mname =~ /^_(.*)/
      MiniTest::Expectations.obfuscate_method(mname)
    end
  end
end

MiniTest.disable_expectations
