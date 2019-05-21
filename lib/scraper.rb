require 'open-uri'
require 'pry'

class Scraper

    def self.scrape_index_page(index_url)
        index = Nokogiri::HTML(open(index_url))
        students = index.css("div.student-card")
        students.each_with_object(hashes = []) do |student|
            hashes << { 
                name: student.css("h4.student-name").text,
                location: student.css("p.student-location").text,
                profile_url: student.css("a").attribute("href").value}
        end
    end

    def self.scrape_profile_page(profile_url)
        profile = Nokogiri::HTML(open(profile_url))
        
        social_hash = {}

        socials = profile.css("div.social-icon-container a")
        socials.each_with_object(social_hash) do |social| 
            link = social.attribute("href").value
            site = URI.parse(link).host
            social_hash[site] = link
        end
        
        profile_hash = {}
        social_hash.each do |site, url|
            case
            when site.include?("github")
                profile_hash[:github] = url
            when site.include?("twitter")
                profile_hash[:twitter] = url
            when site.include?("linkedin")
                profile_hash[:linkedin] = url
            else 
                profile_hash[:blog] = url
            end
        end

        profile_hash[:bio] = profile.css("div.description-holder p").text
        profile_hash[:profile_quote] = profile.css("div.profile-quote").text
    
        profile_hash
    end

end
