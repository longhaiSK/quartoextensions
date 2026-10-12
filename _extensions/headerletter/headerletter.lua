-- Point image-dir at this extension's bundled images/ folder, expressed as a
-- root-relative Typst path, so the extension works wherever it is installed.
-- Typst's root is the project directory (or the document's directory for a
-- standalone file); the extension must live under that root.
function Meta(meta)
  if meta["image-dir"] ~= nil then
    return nil
  end
  local root = quarto.project.directory
  if root == nil then
    root = pandoc.path.directory(quarto.doc.input_file)
  end
  local images = pandoc.path.normalize(quarto.utils.resolve_path("images"))
  local rel = pandoc.path.make_relative(images, pandoc.path.normalize(root))
  if rel:sub(1, 2) == ".." or pandoc.path.is_absolute(rel) then
    quarto.log.warning("headerletter: images folder " .. images ..
      " is outside the Typst root " .. root .. "; set image-dir manually.")
    return nil
  end
  meta["image-dir"] = "/" .. rel:gsub("\\", "/")
  return meta
end
