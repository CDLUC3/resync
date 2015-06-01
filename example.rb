#!/usr/bin/env ruby

# Note: This assumes we're running from the root of the resync project
$LOAD_PATH << File.dirname(__FILE__)
require 'lib/resync'

# ------------------------------------------------------------
# Reading a capability list

puts "\n------------------------------------------------------------"
puts "A capability list:\n"

capabilitylist_xml = '<?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
                xmlns:rs="http://www.openarchives.org/rs/terms/">
          <rs:ln rel="describedby"
                 href="http://example.com/info_about_set1_of_resources.xml"/>
          <rs:ln rel="up"
                 href="http://example.com/resourcesync_description.xml"/>
          <rs:md capability="capabilitylist"/>
          <url>
            <loc>http://example.com/dataset1/resourcelist.xml</loc>
            <rs:md capability="resourcelist"/>
          </url>
          <url>
            <loc>http://example.com/dataset1/resourcedump.xml</loc>
            <rs:md capability="resourcedump"/>
          </url>
          <url>
            <loc>http://example.com/dataset1/changelist.xml</loc>
            <rs:md capability="changelist"/>
          </url>
          <url>
            <loc>http://example.com/dataset1/changedump.xml</loc>
            <rs:md capability="changedump"/>
          </url>
        </urlset>'

capability_list = Resync::XMLParser.parse(capabilitylist_xml)
puts '  Links:'
capability_list.links.each do |l|
  puts "    #{l.rel}: #{l.href}"
end
puts '  Resources:'
capability_list.resources.each do |r|
  puts "    #{r.uri} (#{r.capability})"
end

# ------------------------------------------------------------
# Creating a changelist

puts "\n------------------------------------------------------------"
puts "A change list:\n\n"

change_list = Resync::ChangeList.new(
  links: [
    Resync::Link.new(
      rel: 'up',
      uri: 'http://example.com/dataset1/capabilitylist.xml'
    )
  ],
  metadata: Resync::Metadata.new(
    capability: 'changelist',
    from_time: Time.utc(2013, 1, 3)
  ),
  resources: [
    Resync::Resource.new(
      uri: 'http://example.com/res4',
      modified_time: Time.utc(2013, 1, 3, 17),
      metadata: Resync::Metadata.new(
        change: Resync::Types::Change::UPDATED,
        hashes: { 'sha-256' => 'f4OxZX_x_DFGFDgghgdfb6rtSx-iosjf6735432nklj' },
        length: 56_778,
        mime_type: 'application/json'
      ),
      links: [
        Resync::Link.new(
          rel: 'http://www.openarchives.org/rs/terms/patch',
          uri: 'http://example.com/res4-json-patch',
          modified_time: Time.utc(2013, 1, 3, 17),
          hashes: { 'sha-256' => 'f4OxZX_x_DFGFDgghgdfb6rtSx-iosjf6735432nklj' },
          length: 73,
          mime_type: 'application/json-patch'
        )
      ]
    ),
    Resync::Resource.new(
      uri: 'http://example.com/res5-full.tiff',
      modified_time: Time.utc(2013, 1, 3, 18),
      metadata: Resync::Metadata.new(
        change: Resync::Types::Change::DELETED
      )
    )
  ]
)

xml = change_list.save_to_xml
formatter = REXML::Formatters::Pretty.new
formatter.write(xml, $stdout)
puts
