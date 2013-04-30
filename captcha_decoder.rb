#! /usr/bin/env ruby
require "tesseract"
require "rmagick"
require "open-uri"

=begin
  * Name: CAPTCHADecoder
  * Description Module for decoding CAPTCHA images from EPCRegister
  * Author: Ivan Turkovic
  * Date: 12.04.2013
  * License: BSD
=end

module CAPTCHADecoder
  include Magick

  PATH = '/tmp/tmp.png'

  def self.horizontal_match? image, x, y
    image.pixel_color(x + 1,y) =~ 'black' && image.pixel_color(x - 1,y) =~ 'black' ||
    image.pixel_color(x + 2,y) =~ 'black' && image.pixel_color(x - 2,y) =~ 'black'
  end

  def self.vertical_match? image, x, y
    image.pixel_color(x,y + 1) =~ 'black' && image.pixel_color(x,y - 1) =~ 'black' ||
    image.pixel_color(x,y + 2) =~ 'black' && image.pixel_color(x,y - 2) =~ 'black'
  end

  def self.determine_bridge_pixel? image, x, y
    columns = image.columns - 1
    rows = image.rows - 1 

    if x == 0 && y == 0 ||
      x == 0 && y == rows ||
      x == columns && y == 0 ||
      x == columns && y == rows 
      
      return false
    elsif x == 0 || x == columns
      vertical_match? image, x, y
    elsif y == 0 || y == rows
      horizontal_match? image, x, y
    else
      vertical_match?(image, x, y) || horizontal_match?(image, x, y)
    end

  end

  def self.clean_image original_image
    image = Image.new(original_image.columns, original_image.rows)


    0.upto(original_image.columns - 1) do |x|
      0.upto(original_image.rows) do |y|

        pixel = original_image.pixel_color(x, y)

        if determine_bridge_pixel? original_image, x, y
          image.pixel_color(x, y, Pixel.new)
        else
          image.pixel_color(x, y, pixel)
        end

      end
    end
    
    image  
  end

  class Magick::Pixel
    def =~ (other)
      other = Magick::Pixel.from_color(other) if other.is_a?(String)

      red == other.red && green == other.green && blue == other.blue
    end
  end

  # 
  # decode_captcha is a method used to decode captcha content from
  # images saved on your local disk
  #
  # * *Args*    :
  #   - +path+ -> full path to your CAPTCHA image for local files
  # * *Returns* :
  #   - decoded character array in a String
  #
  def self.decode_captcha path
    original_image = ImageList.new(path)
    original_image = original_image.threshold 0.1

    image = clean_image(original_image)
    image = clean_image(image)

    image.write(PATH)
    # image  = Magick::Image.read(PATH).first
    # image = ImageList.new(image)

    engine = Tesseract::Engine.new {|engine|
      engine.language               = :eng
      engine.page_segmentation_mode = 8
      engine.whitelist              = [*0..9].join
    }

    text = engine.text_for(PATH).gsub(/\s+/, "") 
    text
  end

  # 
  # decode_captcha is a method used to decode captcha content from
  # images saved on your local disk
  #
  # * *Args*    :
  #   - +path+ -> full url to your CAPTCHA image
  # * *Returns* :
  #   - decoded character array in a String
  #
  def self.decode_captcha_from_url url
    File.open(PATH, 'wb') do |file|
      file.write open(url).read
    end

    decode_captcha PATH
  end
end