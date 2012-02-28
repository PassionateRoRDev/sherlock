module DesignerHelper
  def initial_text_size(object)
    lines = object.lines_count
    lines = 1 if lines == 0
    (object.font_size * 1.4) * (lines + 1)
  end
end