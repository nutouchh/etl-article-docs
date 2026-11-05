-- A Markdown fenced Div such as ::: {#tbl:storage} wraps a Markdown table.
-- Pandoc's LaTeX writer will then generate \caption{...}\label{tbl:storage}.
-- The displayed number is managed by LaTeX, not typed into Markdown.
function Div(el)
  if not el.identifier:match('^tbl:') then
    return nil
  end

  for _, block in ipairs(el.content) do
    if block.t == 'Table' then
      block.identifier = el.identifier
      return block
    end
  end

  error('Table container ' .. el.identifier .. ' must contain a Markdown table')
end
