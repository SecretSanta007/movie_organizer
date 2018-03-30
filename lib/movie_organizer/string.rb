# frozen_string_literal: true

class String
  # html = <<-stop.here_with_pipe(delimeter="\n")
  #   |<!-- Begin: comment  -->
  #   |<script type="text/javascript">
  # stop
  def here_with_pipe(delimeter = ' ')
    lines = split("\n")
    lines.map! { |c| c.sub!(/\s*\|/, '') }
    lines.join(delimeter)
  end

  def escape_single_quotes!
    gsub!(/[']/, '\\\\\'')
  end

  def escape_double_quotes!
    gsub!(/["]/, '\\\\\"')
  end
end
