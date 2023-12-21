# Link_Convertor_md_to_docx_pandoc_plugin
A Lua Filter to use for pandoc in order to convert internal and external links from multiplie markdown files to heading links that will work on the docx format.

## This plugin knows how to deal with:
1. Regular header's links - Link to a header in the same note.

   Example: \[This is a heading 1](#This%20is%20a%20heading%201)
2. Header's links in a different note - Link to a header that is in a different note.

   Example: \[This is a heading 1](differentFile.md#This%20is%20a%20heading%201)
3. Links to notes - Converts the name of the note(While removing starting indicators - Example: "123. Hello" will be changed into "Hello", The rationale behind it is that many notes start with a number indicator while headers are less likely to start with this indicator.) to a heading. For this type of link to work properly you should have a heading with the same name as the note(Without starting indicators) inside the note).

   Example: \[differentFile](differentFile.md)

#### Wikilinks support:

4. Links without alternative text: Converts note name to a link to heading in the same name.

   Example: \[[noteName]]

5. Links with alternative text: Converts the target to a target id type and shows the alternative text instead of the target.

   Example: \[[target|alternative_text]]

6. Links to different note's heading: Link to a header that is in a different note.

   Example: \[[noteName\#headerName]]

7. Links to different note's heading with an alternative text: Link to a header that is in a different note. Converts the target to a target id type and shows the alternative text instead of the target.

   Example: \[[noteName\#headerName|alternative_text]]

8. Links to images: Link to an image, must start with 2 '!' because the lua function Str removes the first one and the '!' is the indicator for the type of link in the code.

   Example: \!![[image.jpg]]

9. Links to images with alternative text: Link to an image, must start with 2 '!' because the lua function Str removes the first one and the '!' is the indicator for the type of link in the code.

   Example: \!![[image.jpg|alternative text]]

### Image's caption remover:
  Remove image caption - pandoc does not deal well with image's text in the format of \![altText|sizeOfImage]\(Link)
  Pandoc shows the alternative text and the image size as text in an unexpected positions(like the bottom left corner)
  even when the image is visibale.

## Important commands:

### Command to run the plugin
pandoc --reference-doc=template.docx -o fileName.docx --lua-filter=Link_Convertor_md_to_docx_pandoc_plugin.lua *.md

### Command to create default template.docx for styling the headers(Used after some bugs in the header convertion between markdown and docx)
pandoc -o template.docx --print-default-data-file reference.docx
