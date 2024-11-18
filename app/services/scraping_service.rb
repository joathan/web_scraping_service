# frozen_string_literal: true

require 'selenium-webdriver'

class ScrapingService
  SELENIUM_OPTIONS = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--headless')
    opts.add_argument('--disable-gpu')
    opts.add_argument('--no-sandbox')
    opts.add_argument('--disable-dev-shm-usage')
    opts.add_argument('--disable-blink-features=AutomationControlled')
  end

  def initialize(url)
    @url = url
    @driver = Selenium::WebDriver.for :chrome, options: SELENIUM_OPTIONS
  end

  def perform
    @driver.navigate.to @url

    js_selector_key = "body > div.pagecontent > div:nth-child(2) > div > div.clearfix.card-container.card-container-miolo > div.esquerda.conteudo-anuncio > div.clearfix.card.card-transparente.card-informacoes-basicas > div > ul > li:nth-child(4) > h6"
    key_value = get_element_via_js(js_selector_key)

    js_selector_value = "body > div.pagecontent > div:nth-child(2) > div > div.clearfix.card-container.card-container-miolo > div.esquerda.conteudo-anuncio > div.clearfix.card.card-transparente.card-informacoes-basicas > div > ul > li:nth-child(4) > span"
    content = get_element_via_js(js_selector_value)

    if content.is_a?(Hash) && content[:error]
      content
    else
      { 
        "#{key_value}": content }
    end
  ensure
    @driver.quit
  end

  private

  def wait_for_element(selector, timeout = 20)
    Selenium::WebDriver::Wait.new(timeout: timeout).until do
      @driver.find_element(css: selector)
    end
  rescue Selenium::WebDriver::Error::TimeoutError
    nil
  end

  def get_element_via_js(selector)
    @driver.execute_script("return document.querySelector('#{selector}').innerText;")
  rescue Selenium::WebDriver::Error::JavascriptError => e
    { error: 'JavaScript execution failed', details: e.message }
  end
end
