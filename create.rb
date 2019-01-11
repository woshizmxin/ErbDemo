#!/usr/bin/env ruby
require 'erb'
require 'json'

class Creater
  def proc
    str = IO.read("config.json");
    configs=JSON.parse(str)
    configs.each do |p|
      create(p)
    end
  end

  def create(p)
    Dir.mkdir("dist") unless FileTest.exist?("dist")
    todir = "dist/" +p["name"]
    Dir.mkdir(todir) unless FileTest.exist?(todir)
    Dir.foreach("template") do |file|
      if file !="." and file !=".."
        data = p["data"]
        tofile =File.new(todir+"/"+file, "w")
        fromfile = "template/"+file
        File.open(fromfile) {|fh|
          e = ERB.new(fh.read)
          tofile.print e.result(binding)
        }
        tofile.close
      end
    end
  end
end

c = Creater.new()
c.proc()