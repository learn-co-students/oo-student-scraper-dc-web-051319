require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
      html = File.read(index_url)
      index_page = Nokogiri::HTML(html)
      #index_page.css(".roster-cards-container")
      #roster.css(".student-card .student-name")
      #roster.css(".student-card .student-location").text

      roster = []

      index_page.css(".roster-cards-container .student-card").each do |student|
        roster << {:name => student.css(".student-name").text, :location => student.css(".student-location").text, :profile_url => student.css("a").attribute("href").value}
      end

      roster
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile_page = Nokogiri::HTML(html)
    
    student_hash = {}

    profile_page.css(".social-icon-container a").each do |social|
      href = social.attribute("href").value
      
      if href.include?("twitter")
        student_hash[:twitter] = href
      elsif href.include?("github")
        student_hash[:github] = href
      elsif href.include?("linkedin")
        student_hash[:linkedin] = href
      else
        student_hash[:blog] = href
      end
    end

    if profile_quote = profile_page.css(".vitals-text-container .profile-quote").text
      student_hash[:profile_quote] = profile_quote
    end 

    if bio = profile_page.css(".description-holder p").text
      student_hash[:bio] = bio
    end
    # student_hash = {
    #   :profile_quote => profile_page.css(".vitals-text-container .profile-quote").text,
    #   :bio => profile_page.css(".description-holder p").text
    #   }
    student_hash
  end

end

p Scraper.scrape_profile_page("./fixtures/student-site/students/david-kim.html")