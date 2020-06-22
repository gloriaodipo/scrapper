require 'selenium-webdriver'
require 'pry'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

def scraper(tracking_number, options)
  url = "https://www.17track.net/?nums=#{tracking_number}"
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.get(url)
  sleep 2
  data = driver.find_element(:css, '#cl-details').attribute('data-clipboard-text')
  result = data.split(/[\r\n]+/)
  {
    tracking_number: result[0].to_s.split(":")[1]&.gsub(" ", ""),
    package_location: result[2].to_s.split(":")[1],
    status: result[1].to_s.split(":")[1],
    last_update: result[5].to_s.split(",")[0]
  }
end

puts scraper("4207306992748927005455000010756400", options)
