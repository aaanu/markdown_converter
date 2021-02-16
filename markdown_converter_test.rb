require 'minitest/autorun'
require_relative 'markdown_converter'

# Common test data version: 5.0.0 7dfb96c
class MarkdownConverterTest < Minitest::Test
    def test_convert_sample
        input_string = '```
# Sample Document

Hello!

This is sample markdown for the [Mailchimp](https://www.mailchimp.com) homework assignment.
```'
        expected = '```
<h1>Sample Document</h1>

<p>Hello!</p>

<p>This is sample markdown for the <a href="https://www.mailchimp.com">Mailchimp</a> homework assignment.</p>
```'
        html = MarkdownConverter.new(input_string).convert
        assert_equal html, expected
    end

    def test_convert_multiple_headers
        input_string = '```
# Header one

Hello there

How are you?
What\'s going on?

## Another Header

This is a paragraph [with an inline link](http://google.com). Neat, eh?

## This is a header [with a link](http://yahoo.com)
```'
        expected = '```
<h1>Header one</h1>

<p>Hello there</p>

<p>How are you?
What\'s going on?</p>

<h2>Another Header</h2>

<p>This is a paragraph <a href="http://google.com">with an inline link</a>. Neat, eh?</p>

<h2>This is a header <a href="http://yahoo.com">with a link</a></h2>
```'
        html = MarkdownConverter.new(input_string).convert
        assert_equal html, expected
    end
end