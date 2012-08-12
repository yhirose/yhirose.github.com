#!/usr/bin/ruby

if ARGV.length < 2
  puts "Usage: ruby gen_appcast_item.rb ver build"
  exit
end

ver = ARGV[0]
build = ARGV[1]

path = "apps/BibleReadingMenulet_#{ver}.zip"

dt = Time.now.strftime("%a, %d %b %Y %T %z")

dsa = `openssl dgst -sha1 -binary < "#{path}" | openssl dgst -dss1 -sign scripts/dsa_priv.pem | openssl enc -base64`.chomp

len = File::stat(path).size

s = <<EOS
    <item>
        <title>Version #{ver}</title>
        <sparkle:releaseNotesLink>http://yhirose.github.com/BibleReadingMenulet/apps/rnotes_#{ver}.html</sparkle:releaseNotesLink>
        <pubDate>#{dt}</pubDate>
        <enclosure
            url="http://yhirose.github.com/BibleReadingMenulet/apps/BibleReadingMenulet_#{ver}.zip"
            sparkle:version="#{build}"
            sparkle:shortVersionString="#{ver}"
            sparkle:dsaSignature="#{dsa}"
            length="#{len}"
            type="application/octet-stream"
        />
    </item>
EOS

puts s
