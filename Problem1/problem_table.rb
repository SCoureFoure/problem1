# README:
# I wasn't really sure a better way to replicate the datastate of the table
# than to just create a mock table object

# I tried something like this, and I didn't like it, so I'm leaving it here for
# ya'll to look at. Didn't think I needed it.

class ProblemTable
  # Give our table a few attributes to call later.
  attr_accessor :label
  attr_accessor :text
  def init
  # I make a temp array to house the attribute pairs
  table_elements = []

  # Put our text values into a different array
  # Value texts against index 1, 2, 4, 5, 6
  txt_values = %w(122365.24
                  599.00
                  850139.99
                  23329.50
                  566.27)

  lbl_values = ['Value 1',
    'Value 2',
    'Value 3',
    'Value 4',
    'Value 5']

  end

end
