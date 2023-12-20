function Link(el)
  local stripped_target = el.target:gsub("%%20", " ") -- Format spaces
  local does_have_md = false
  local does_have_hashtag, stripped_target = cutPartBySep(stripped_target, "#", false) -- Remove file name for header links between files
  local target_id
  local hyperlink

  if does_have_hashtag == false then
    does_have_md = stripped_target ~= stripped_target:gsub(".md", "")

    if does_have_md == false then
      print("Warning: Link does not contain #(Link to heading) or .md(Link to note). Link: "..stripped_target)
      return el
    end

    stripped_target =  stripped_target:gsub(".md", "") -- Remove .md from string
    stripped_target = stripped_target:gsub("^[0-9]+%.%s*", "") -- Remove all leading digits and decimal point and space
    --Example: "123. Hello" will be changed into "Hello", The rationale behind it is that many notes start with a number indicator while
    -- Headers are less likely to start with this indicator. 

    stripped_target = "#"..stripped_target
  end

  target_id = parseTargetId(stripped_target)

  hyperlink = pandoc.Link(stripped_target:gsub("#", ""), target_id)

  return hyperlink

end

function Image(img)
  -- Remove image caption - pandoc does not deal well with image's text in the format of ![altText|sizeOfImage](Link)
  -- Pandoc shows the alternative text and the image size as text in an unexpected positions(like the bottom left corner)
  -- even when the image is visibale.
  img.caption = ""
  return img
end

function parseTargetId(text)
  -- Parse target from text to id in the format of heading.
  -- The id of heading is in the format of: "word-word" in lowercase
  -- That way I don't link the link to itself of any other element that has the content of the header

  target_id = text:gsub(" & ", " ") -- Special case of which & is wrapped with spaces
  target_id = target_id:gsub("[%(%)%[%]&]", "") -- Docx bookmarks do not work with & or with paranthesis
  target_id = target_id:gsub(" ", "-"):lower() -- The id of heading is in the format of: "word-word" in lowercase
  --That way I don't link the link to itself of any other element that has the content of the header

  return target_id
end

function cutPartBySep (inputstr, seperator, firstPart)
  -- Cut the first or the second part of the string by seperator and check if the string have the seperator
  if seperator == nil then
    seperator = "%s"
  end
  local result = seperator
  local i = 0
  for str in string.gmatch(inputstr, "([^"..seperator.."]+)") do
    if (i > 0 and firstPart == false) or (i == 0 and firstPart) then      
      result = result..str
    end
    i = i + 1
  end
  if result == seperator then
    result = inputstr
  end
  return i > 1 or inputstr:sub(1, #seperator) == seperator, result -- Return the result and if the string has hashtag
end

local link = ""
local isInLink = false

function Str (el)
  -- Support for wikilinks
  -- Can support wikilinks that are in the format of: [[target|text_to_show]] or [[target_and_text_to_show]]

  local elStr = tostring(el):gsub('"', ""):gsub("Str ", "") -- Convert string to a string type
  local firstPart
  local secondPart
  local doesHave

  if string.find(elStr ,"%[%[") ~= nil and string.find(elStr ,"%]%]") ~= nil then -- 1 word wikilink
    link =  elStr:gsub("%[%[", ""):gsub("%]%]", "") -- Mark as link

    -- Cut the wikilink to the target and the content(If there is only target it will return the original text
    -- which means that the content and the target will be the same)
    doesHave, secondPart = cutPartBySep(link, '|', false)
    doesHave, firstPart = cutPartBySep(link, '|', true)
    doesHave, firstPart = cutPartBySep(firstPart, "#", false) -- Remove file name
    firstPart = firstPart:gsub("|", ""):gsub("%%20", " "):gsub("#", "")
    secondPart = secondPart:gsub("|", "")

    return pandoc.Link(secondPart, "#"..parseTargetId(firstPart)) -- Convert target to target_id

  elseif string.find(elStr ,"%[%[") ~= nil then -- Starting a link that is longer than 1 word
    isInLink = true -- Mark start of link
    link = elStr:gsub("%[%[", "") -- Mark as link

  elseif string.find(elStr ,"%]%]") ~= nil then -- End of link
    link = link .. " " .. elStr:gsub("%]%]", "")
    isInLink = false

    -- Cut the wikilink to the target and the content(If there is only target it will return the original text
    -- which means that the content and the target will be the same)
    doesHave, secondPart = cutPartBySep(link, '|', false)
    doesHave, firstPart = cutPartBySep(link, '|', true)
    doesHave, firstPart = cutPartBySep(firstPart, "#", false) -- Remove file name
    firstPart = firstPart:gsub("|", ""):gsub("%%20", " ")
    secondPart = secondPart:gsub("|", "")

    return pandoc.Link(secondPart, "#"..parseTargetId(firstPart)) -- Convert target to target_id

  elseif isInLink then -- Middle of a link
    link = link .. " " .. elStr
  end

  if isInLink then
    return "" -- Delete link's text
  end
end
