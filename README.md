# Link_Convertor_md_to_docx_pandoc_plugin
A Lua Filter to use for pandoc in order to convert internal and external links from multiplie markdown files to heading links that will work on the docx format.

Link format must not be WikiLinks.

## This plugin knows how to deal with:
1. Regular header's links - Link to a header in the same note.
   Example: \[This is a heading 1](#This%20is%20a%20heading%201)
3. Header's links in a different note - Link to a header that is in a different note.
   Example: \[This is a heading 1](differentFile.md#This%20is%20a%20heading%201)
4. Links to notes - Converts the name of the note(While removing starting indicators - Example: "123. Hello" will be changed into "Hello", The rationale behind it is that many notes start with a number indicator while headers are less likely to start with this indicator.) to a heading. For this type of link to work properly you should have a heading with the same name as the note(Without starting indicators) inside the note).
   Example: \[differentFile](differentFile.md)

## Important commands:

### Command to run the plugin
pandoc --reference-doc=template.docx -o fileName.docx --lua-filter=Link_Convertor_md_to_docx_pandoc_plugin.lua *.md

### Command to create default template.docx for styling the headers(Used after some bugs in the header convertion between markdown and docx)
pandoc -o template.docx --print-default-data-file reference.docx
