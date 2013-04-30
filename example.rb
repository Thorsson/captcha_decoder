#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__))
require "captcha_decoder.rb"

# using with local files
puts CAPTCHADecoder::decode_captcha('./examples/1.png')
puts CAPTCHADecoder::decode_captcha('./examples/2.png')
puts CAPTCHADecoder::decode_captcha('./examples/3.png')
puts CAPTCHADecoder::decode_captcha('./examples/4.png')
puts CAPTCHADecoder::decode_captcha('./examples/5.png')
puts CAPTCHADecoder::decode_captcha('./examples/6.png')
puts CAPTCHADecoder::decode_captcha('./examples/7.png')

# using with local files
puts CAPTCHADecoder::decode_captcha_from_url('https://www.epcregister.com/extendedcaptcha?cookie=QP6uTJQ%2B8eO%2Brap2P5oqMveDjXgcsR4l%2F0ODK5AYWpg%3D')
