function Link(el)

  local stripped_target = el.target:gsub("%%20", " ") -- Format spaces
  local does_have_md = false
  local does_have_hashtag, stripped_target = cutFirstPartBySep(stripped_target, "#") -- Remove file name for header links between files
  local target_id
  local hyperlink

  if does_have_hashtag == false then
    does_have_md = stripped_target ~= stripped_target:gsub(".md", "")

    if does_have_md == false then
      print("Error: Link does not contain #(Link to heading) or .md(Link to note). Link: "..stripped_target)
      return pandoc.Link(stripped_target, stripped_target)
    end

    stripped_target =  stripped_target:gsub(".md", "") -- Remove .md from string
    stripped_target = stripped_target:gsub("^[0-9]+%.%s*", "") -- Remove all leading digits and decimal point and space
    --Example: "123. Hello" will be changed into "Hello", The rationale behind it is that many notes start with a number indicator while
    -- Headers are less likely to start with this indicator. 

    stripped_target = "#"..stripped_target
  end

  target_id = stripped_target:gsub(" ", "-"):lower() --The id of heading is in the format of: "word-word" in lowercase
  --That way I don't link the link to itself of any other element that has the content of the header

  hyperlink = pandoc.Link(stripped_target, target_id)

  return hyperlink

end


function cutFirstPartBySep (inputstr, seperator)
  -- Cut the first part of the string by seperator and check if the string have the seperator
  if seperator == nil then
    seperator = "%s"
  end
  local result = "#"
  local i = 0
  for str in string.gmatch(inputstr, "([^"..seperator.."]+)") do
    if i > 0 then      
      result = result..str
    end
    i = i + 1
  end
  if result == seperator then
    result = inputstr
  end
  return i > 1 or inputstr:sub(1, #seperator) == seperator, result -- Return the result and if the string has hashtag
end

