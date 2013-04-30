== Getting Started

CAPTCHA Decoder is a library to decode a specific type of captcha images based on url or local file path.

== Installation

To be able to use this library you need to install some native libraries before:

- leptonica
- tesseract
- imagemagick

best way to install it on a mac is by using brew:

$brew install imagemagick leptonica tesseract

after installing require libraries, you also need to install following gems:

- rmagick
- tesseract-ocr

$gem install rmagick
$gem install tesseract-ocr

After installing required libraries it is ready to use. There is an example file by name example.rb where it shows how to call for local file or remote url CAPTCHA image. 
