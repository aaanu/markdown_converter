# Converts a markdown string to HTML
class MarkdownConverter
    def initialize(markdown_string)
        @markdown_string = markdown_string
        @lines_count = @markdown_string.split("\n").length
    end
    def convert
        convert_paragraphs
        convert_headers
        convert_links
        return @markdown_string
    end

    private
    def convert_headers
        @markdown_string = @markdown_string.split("\n").each.map  do |line|
            hash_count = 0
            if line[0] == "#"
                hash_count += 1 while line[hash_count] == "#"
                start = hash_count
                start += 1 while line[start] == " "
                "<h#{hash_count}>#{line[start..line.length]}</h#{hash_count}>"
            else
                line
            end
        end.join("\n")
    end

    def convert_paragraphs
        # Every line that isn't a header or other tag should be a paragraph
        @markdown_string = @markdown_string.split("\n").each_with_index.map do |line, index|
            if index == 0 || index == @lines_count - 1 # ignore the ``` we're always starting and ending the input with
                line
            elsif is_tagged?(line.strip)
                line
            else
                if line.strip.include?("\n")
                    i = line.index("\n")
                    line[i] = " "
                end
                "<p>#{line.strip}</p>"
            end
        end.join("\n")
    end

    def is_tagged?(line)
        # This isn't great but, if a line starts with something we know is its own HTML tag, we won't add a <p> tag to it
        line[0] == "#" || line[0] == nil
    end

    def convert_links
        @markdown_string = @markdown_string.split("\n").each.map do |line|
            # RegEx to match a [link](text) format
            if line.match?(/\[(.*?)\]\((.*?)\)/)
                matches = line.to_enum(:scan, /\[(.*?)\]\((.*?)\)/).map { Regexp.last_match } # Get all matches in the line
                matches.map do |line_match|
                    offset = line_match.offset(0)
                    link = line_match[0].match(/\((.*?)\)/)[1] # Get the stuff in the (parentheses)
                    text = line_match[0].match(/\[(.*?)\]/)[1] # Get the stuff in the [brackets]
                    "#{line[0..offset[0] - 1]}<a href=\"#{link}\">#{text}</a>#{line[offset[1]..line.length]}"
                end
            else
                line
            end
        end.join("\n")
    end
end